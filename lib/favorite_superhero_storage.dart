import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/model/superhero.dart';

class FavoriteSuperHeroStorage {
  static const _key = "favorite_superheroes";

  final updater = PublishSubject<Null>();

  static FavoriteSuperHeroStorage? _instance;

  factory FavoriteSuperHeroStorage.getInstance() =>
      _instance ??= FavoriteSuperHeroStorage._internal();

  FavoriteSuperHeroStorage._internal();

  Future<bool> addToFavorites(final Superhero superhero) async {
    final rawSuperheroes = await _getRawSuperheroes();
    rawSuperheroes.add(json.encode(superhero.toJson()));
    return _setRawSuperheroes(rawSuperheroes);
  }

  Future<bool> removeFromFavorites(final String id) async {
    final superheroes = await _getSuperheroes();
    superheroes.removeWhere((superhero) => superhero.id == id);
    return _setSuperheroes(superheroes);
  }

  Future<List<String>> _getRawSuperheroes() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_key) ?? [];
  }

  Future<bool> _setRawSuperheroes(List<String> rawSuperheroes) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(_key, rawSuperheroes);
    updater.add(null); //уведомление о новом зн-ии
    return result;
  }

  Future<List<Superhero>> _getSuperheroes() async {
    final rawSuperheroes = await _getRawSuperheroes();
    return rawSuperheroes
        .map((rawSuperhero) => Superhero.fromJson(json.decode(rawSuperhero)))
        .toList();
  }

  Future<bool> _setSuperheroes(final List<Superhero> superheroes) async {
    final rawRawSuperheroes = superheroes
        .map((superhero) => json.encode(superhero.toJson()))
        .toList();
    return _setRawSuperheroes(rawRawSuperheroes);
  }

  Future<Superhero?> getSuperhero(final String id) async {
    final superheroes = await _getSuperheroes();
    for (final superhero in superheroes) {
      if (superhero.id == id) {
        return superhero;
      }
    }
    return null;
  }

  Stream<List<Superhero>> observeFavoriteSuperheroes() async* {
    yield await _getSuperheroes();
    await for (final _ in updater) {
      yield await _getSuperheroes(); //добавление нового зн-ия
    }
  }

  Stream<bool> observeIsFavorite(final String id) {
    return observeFavoriteSuperheroes().map(
        (superheroes) => superheroes.any((superhero) => superhero.id == id));
  }

  Future<bool> updateIfInFavorite(final Superhero newSuperhero) async {
    final superheroes = await _getSuperheroes();
    final index = superheroes.indexWhere((superhero) => superhero.id == newSuperhero.id);
    if (index == -1) {
      return false;
    }
    superheroes[index] = newSuperhero;
    return _setSuperheroes(superheroes);
  }
}
