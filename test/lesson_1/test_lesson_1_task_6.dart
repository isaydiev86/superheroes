import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/main.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:superheroes/widgets/superhero_card.dart';

import '../shared/test_helpers.dart';
import 'shared.dart';

void runTestLesson1Task6() {
  testWidgets('module6', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await reachNeededState(tester, MainPageState.searchResults);

      final searchResultsTextFinder = find.text("Search results");

      expect(
        searchResultsTextFinder,
        findsOneWidget,
        reason: "There should be a Text with text 'Search results'",
      );

      final Text searchResultsText = tester.firstWidget(searchResultsTextFinder);

      checkTextProperties(
        textWidget: searchResultsText,
        textColor: const Color(0xFFFFFFFF),
        fontSize: 24,
        fontWeight: FontWeight.w800,
      );

      final columnFinder =
          findTypeByTextOnlyInParentType(Column, "Search results", MainPageStateWidget);

      expect(
        columnFinder,
        findsOneWidget,
        reason: "There should be a Column inside MainPageStateWidget ",
      );

      final Column column = tester.widget(columnFinder);

      final paddingOfText = find.descendant(
        of: columnFinder,
        matching: find.ancestor(
          of: searchResultsTextFinder,
          matching: find.byType(Padding),
        ),
      );

      expect(
        paddingOfText,
        findsOneWidget,
        reason: "Text with text 'Search results' should be wrapped with Padding",
      );

      final Padding searchResultsPadding = tester.widget(paddingOfText);

      checkEdgeInsetParam(
        widgetName: "Padding",
        param: searchResultsPadding.padding,
        paramName: "",
        edgeInsetsCheck: EdgeInsetsCheck(left: 16, right: 16),
      );

      final batmanCardFinder =
          findTypeByTextOnlyInParentType(SuperheroCard, "BATMAN", MainPageStateWidget);

      expect(
        batmanCardFinder,
        findsOneWidget,
        reason: "There should be a SuperheroCard with Batman",
      );

      final SuperheroCard batmanCard = tester.widget(batmanCardFinder);
      expect(
        batmanCard.name,
        "Batman",
        reason: "SuperheroCard with Batman should have 'Batman' as a name parameter",
      );
      expect(
        batmanCard.realName,
        "Bruce Wayne",
        reason: "SuperheroCard with Batman should have 'Bruce Wayne' as a realName parameter",
      );
      final batmanUrl = "https://www.superherodb.com/pictures2/portraits/10/100/639.jpg";
      expect(
        batmanCard.imageUrl,
        batmanUrl,
        reason: "SuperheroCard with Batman should have '$batmanUrl' as an imageUrl parameter",
      );

      final paddingOfBatmanCardTextFinder = find.descendant(
        of: columnFinder,
        matching: find.ancestor(
          of: batmanCardFinder,
          matching: find.byType(Padding),
        ),
      );

      expect(
        paddingOfBatmanCardTextFinder,
        findsOneWidget,
        reason: "SuperheroCard with Batman should be wrapped with Padding",
      );

      final Padding paddingOfBatmanCardText = tester.widget(paddingOfBatmanCardTextFinder);
      checkEdgeInsetParam(
        widgetName: "Padding",
        param: paddingOfBatmanCardText.padding,
        paramName: "",
        edgeInsetsCheck: EdgeInsetsCheck(left: 16, right: 16),
      );

      final venomCardFinder =
          findTypeByTextOnlyInParentType(SuperheroCard, "VENOM", MainPageStateWidget);

      expect(
        venomCardFinder,
        findsOneWidget,
        reason: "There should be a SuperheroCard with Venom",
      );

      final SuperheroCard venomCard = tester.widget(venomCardFinder);
      expect(
        venomCard.name,
        "Venom",
        reason: "SuperheroCard with Venom should have 'Venom' as a name parameter",
      );
      expect(
        venomCard.realName,
        "Eddie Brock",
        reason: "SuperheroCard with Venom should have 'Eddie Brock' as a realName parameter",
      );
      final venomUrl = "https://www.superherodb.com/pictures2/portraits/10/100/22.jpg";
      expect(
        venomCard.imageUrl,
        venomUrl,
        reason: "SuperheroCard with Venom should have '$venomUrl' as an imageUrl parameter",
      );

      final paddingOfVenomCardTextFinder = find.descendant(
        of: columnFinder,
        matching: find.ancestor(
          of: venomCardFinder,
          matching: find.byType(Padding),
        ),
      );

      expect(
        paddingOfVenomCardTextFinder,
        findsOneWidget,
        reason: "SuperheroCard with Venom should be wrapped with Padding",
      );

      final Padding paddingOfVenomCardText = tester.widget(paddingOfVenomCardTextFinder);
      checkEdgeInsetParam(
        widgetName: "Padding",
        param: paddingOfVenomCardText.padding,
        paramName: "",
        edgeInsetsCheck: EdgeInsetsCheck(left: 16, right: 16),
      );

      expect(
        column.children.length,
        6,
        reason: "There should be 6 widgets inside Column. Widget with text 'Your favorites',"
            " SuperheroCard with Batman, SuperheroCard with Ironman and 3 SizedBoxes",
      );

      expect(
        column.children[0],
        isInstanceOf<SizedBox>(),
        reason: "First widget in Column should be a SizedBox",
      );

      expect(
        (column.children[0] as SizedBox).height,
        90,
        reason: "Top SizedBox should have 90 height",
      );

      expect(
        column.children[2],
        isInstanceOf<SizedBox>(),
        reason: "Third widget in Column should be a SizedBox",
      );

      expect(
        (column.children[2] as SizedBox).height,
        20,
        reason: "Top SizedBox between title and first SuperheroCard should have 20 height",
      );

      expect(
        column.children[4],
        isInstanceOf<SizedBox>(),
        reason: "Fifth widget in Column should be a SizedBox",
      );

      expect(
        (column.children[4] as SizedBox).height,
        8,
        reason: "SizedBox between two SuperheroCards should have 8 height",
      );
    });
  });
}
