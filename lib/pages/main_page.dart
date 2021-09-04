import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final http.Client? client;

  MainPage({Key? key, this.client}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(client: widget.client);
  }

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

class MainPageContent extends StatefulWidget {
  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  late final FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      myFocusNode.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainPageStateWidget(focusNode: myFocusNode),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
          child: SearchWidget(focusNode: myFocusNode),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  final FocusNode focusNode;

  const SearchWidget({Key? key, required this.focusNode}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
  late double width = 1;
  late Color color = Colors.white24;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() {
        bloc.updateText(controller.text);
        setState(() {
          if (controller.text.length == 0) {
            width = 1;
            color = Colors.white24;
          } else {
            width = 2;
            color = Colors.white;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.search,
      cursorColor: Colors.white,
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        isDense: true,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white54,
          size: 24,
        ),
        suffix: GestureDetector(
          onTap: () => controller.clear(),
          child: Icon(Icons.clear, color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: color,
            width: width,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  final FocusNode focusNode;

  MainPageStateWidget({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

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
            return Stack(
              children: [
                InfoWithButton(
                  title: 'No favorites yet',
                  subtitle: 'Search and add',
                  assetImage: SuperheroesImages.ironMan,
                  imageHeight: 119,
                  imageWidth: 108,
                  imageTopPadding: 9,
                  buttonText: 'Search',
                  onTap: () => focusNode.requestFocus(),
                )
              ],
            );
          case MainPageState.minSymbols:
            return MinSymbolWidget();
          case MainPageState.nothingFound:
            return InfoWithButton(
              title: 'Nothing found',
              subtitle: 'Search for something else',
              assetImage: SuperheroesImages.hulk,
              imageHeight: 112,
              imageWidth: 84,
              imageTopPadding: 16,
              buttonText: 'Search',
              onTap: () => focusNode.requestFocus(),
            );
          case MainPageState.loadingError:
            return InfoWithButton(
              title: 'Error happened',
              subtitle: 'Please, try again',
              assetImage: SuperheroesImages.superman,
              imageHeight: 106,
              imageWidth: 126,
              imageTopPadding: 22,
              buttonText: 'Retry',
              onTap: bloc.retry,
            );
          case MainPageState.searchResults:
            return SuperheroesList(
              title: 'Search results',
              stream: bloc.observeSearchedSuperheroes(),
              ableToSwipe: false,
            );
          case MainPageState.favorites:
            return Stack(
              children: [
                SuperheroesList(
                  title: 'Your favorites',
                  stream: bloc.observeFavoriteSuperheroes(),
                  ableToSwipe: true,
                )
              ],
            );
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

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;
  final bool ableToSwipe;

  const SuperheroesList({
    Key? key,
    required this.title,
    required this.stream,
    required this.ableToSwipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox.shrink();
        }
        final List<SuperheroInfo> superheroes = snapshot.data!;
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: superheroes.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return ListTitleWidget(title: title);
            }
            final SuperheroInfo item = superheroes[index - 1];
            return ListTile(superhero: item, ableToSwipe: ableToSwipe);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
        );
      },
    );
  }
}

class ListTile extends StatelessWidget {
  final SuperheroInfo superhero;
  final bool ableToSwipe;

  const ListTile({
    Key? key,
    required this.superhero,
    required this.ableToSwipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    final card = SuperheroCard(
      superheroInfo: superhero,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SuperheroPage(
              id: superhero.id,
            ),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ableToSwipe
          ? Dismissible(
              key: ValueKey(superhero.id),
              child: card,
              background: BackgroundCard(isLeft: true),
              secondaryBackground: BackgroundCard(isLeft: false),
              onDismissed: (_) => bloc.removeFromFavorites(superhero.id),
            )
          : card,
    );
  }
}

class BackgroundCard extends StatelessWidget {
  final bool isLeft;

  const BackgroundCard({Key? key, required this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: SuperheroesColors.red),
      child: Text(
        "Remove\nfrom\nfavorites".toUpperCase().trim(),
        textAlign: isLeft ? TextAlign.left : TextAlign.right,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ListTitleWidget extends StatelessWidget {
  const ListTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 90,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
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
