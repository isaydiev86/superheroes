import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superhero_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superheroSubject = BehaviorSubject<Superhero>();

  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  SuperheroBloc({this.client, required this.id}) {
    getFromFavorites();
  }

  Stream<Superhero> observeSuperhero() => superheroSubject;

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperHeroStorage.getInstance()
        .getSuperhero(id)
        .asStream()
        .listen(
      (superhero) {
        if (superhero != null) {
          superheroSubject.add(superhero);
          print("get superheroes in favorites $superhero");

        }
        requestSuperheroes(superhero);
      },
      onError: (error, stackTrace) =>
          print("Error happened get favorite: $error, $stackTrace"),
    );
  }

  void requestSuperheroes(final Superhero? superheroFavorite) {
    requestSubscription?.cancel();

    requestSubscription = request().asStream().listen(
      (superhero) {
        if (superhero != superheroFavorite && superheroFavorite == null) {
          superheroSubject.add(superhero);
          return;
        }
      },
      onError: (error, stackTrace) {
        print("Error happened in requestSuperheroes: $error, $stackTrace");
      },
    );
  }

  void addToFavorite() {
    final superhero = superheroSubject.valueOrNull;
    if (superhero == null) {
      print("ERROR");
      return;
    }
    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperHeroStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen(
      (event) {
        print("Add to favorites $event");
      },
      onError: (error, stackTrace) =>
          print("Error happened in add favorite: $error, $stackTrace"),
    );
  }

  void removeFromFavorites() {
    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperHeroStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen(
      (event) {
        print("remove to favorites $event");
      },
      onError: (error, stackTrace) =>
          print("Error happened remove favorite: $error, $stackTrace"),
    );
  }

  Stream<bool> observeIsFavorite() =>
      FavoriteSuperHeroStorage.getInstance().observeIsFavorite(id);

  Future<Superhero> request() async {
    final token = dotenv.env["SUPERHERO_TOKEN"];
    final response = await (client ??= http.Client())
        .get(Uri.parse("https://superheroapi.com/api/$token/$id"));

    final decode = json.decode(response.body);

    if (response.statusCode >= 500) {
      throw ApiException("Server error happened");
    } else if (response.statusCode < 500 && response.statusCode >= 400) {
      throw ApiException("Client error happened");
    }
    final decoded = json.decode(response.body);
    if (decode['response'] == 'success') {
      return Superhero.fromJson(decoded);
    } else if (decode['response'] == 'error') {
      throw ApiException("Client error happened");
    }
    throw Exception('Unknown error happened');
  }

  void dispose() {
    client?.close();

    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    getFromFavoritesSubscription?.cancel();

    superheroSubject.close();
  }
}
