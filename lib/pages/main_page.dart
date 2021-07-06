import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);

    return Stack(
      children: [
        MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: 'next state',
            onTap: () => bloc.nextState(),
          ),
        ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);

    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState state = snapshot.data!;

        switch (state) {
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.noFavorites:
            return InfoWithButton(
              title: 'No favorites yet',
              subtitle: 'Search and add',
              assetImage: SuperheroesImages.ironMan,
              imageHeight: 119,
              imageWidth: 108,
              imageTopPadding: 9,
              buttonText: 'Search',
            );
          case MainPageState.minSymbols:
            return MinSymbolWidget();
          case MainPageState.nothingFound:
            return InfoWithButton(
              title: 'Nothing found',
              subtitle: 'Search for something else',
              assetImage: SuperheroesImages.nothing,
              imageHeight: 112,
              imageWidth: 84,
              imageTopPadding: 16,
              buttonText: 'Search',
            );
          case MainPageState.loadingError:
            return InfoWithButton(
              title: 'Error happened',
              subtitle: 'Please, try again',
              assetImage: SuperheroesImages.error,
              imageHeight: 106,
              imageWidth: 126,
              imageTopPadding: 22,
              buttonText: 'Retry',
            );
          case MainPageState.searchResults:
            return SearchResultWidget();
          case MainPageState.favorites:
            return FavoritesWidget();
          default:
            return Center(
                child: Text(
              state.toString(),
              style: TextStyle(color: Colors.white),
            ));
        }
      },
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Search results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Batman',),
              ),);
            },
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Venom',),
              ),);
            },
            name: 'Venom',
            realName: 'Eddie Brock',
            imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
          ),
        ),
      ],
    );
  }
}

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Your favorites',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Batman',),
              ),);
            },
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Ironman',),
              ),);
            },
            name: 'Ironman',
            realName: 'Tony Stark',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
          ),
        ),
      ],
    );
  }
}

class NoFavoritesWidget extends StatelessWidget {
  const NoFavoritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  color: SuperheroesColors.blue,
                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(100)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Image.asset(
                  SuperheroesImages.ironMan,
                  width: 108,
                  height: 119,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'No favorites yet',
            style: TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Text('Search and add'.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 30),
          ActionButton(text: 'search', onTap: () {})
        ],
      ),
    );
  }
}

class MinSymbolWidget extends StatelessWidget {
  const MinSymbolWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 110.0),
        child: Text(
          'Enter at least 3 symbols',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(SuperheroesColors.blue),
          strokeWidth: 4,
        ),
      ),
    );
  }
}
