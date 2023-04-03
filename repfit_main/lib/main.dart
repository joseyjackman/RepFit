import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//added video player package
import 'package:video_player/video_player.dart';

//charts package:
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

//early attempt at data persistence/storage:
import 'user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'RepFit',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = TutorialPage();
        break;
      case 2:
        page = ExerciseDatabase();
        break;
      case 3:
        page = HistoryPage();
        break;
      case 4:
        page = StartSessionPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.lightbulb),
                    label: Text('Tutorial'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.library_books),
                      label: Text('Exercise Database')),
                  NavigationRailDestination(
                      icon: Icon(Icons.auto_graph), label: Text('History')),
                  NavigationRailDestination(
                      icon: Icon(Icons.directions_run),
                      label: Text('Start Session'))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
<<<<<<< Updated upstream
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
=======
                color: appState.backgroundColor,
                child: Column(
                  children: [
                    if (selectedIndex == 0)
                      Expanded(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    if (selectedIndex == 0) SizedBox(height: 16),
                    Expanded(child: page),
                  ],
                ),
>>>>>>> Stashed changes
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget intro = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'INTRO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                Text(
                  'Welcome to the RepFit fitness app! This page will show you exactly what your options are to navigate this app, as well as what each option means. Aside from this Tutorial page, there are 4 other pages: The Home page, the Exercise Database, the History page, and the Start Session page.'
                )
              ],
            )
          )
        ],
      )
    );

    Widget home = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'HOME',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                Text(
                  'The function of the Home page is to serve as an introduction to the rest of the RepFit app. There, you will find an introduction to RepFit\'s founders, as well as our mission statement.'
                )
              ],
            )
          )
        ],
      )
    );

    Widget exercisedatabase = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'EXERCISE DATABASE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                Text(
                  'The Exercise Database your one-stop shop for all your exercise questions. Conatining both videos and a text description of every exercise we track in the RepFit app, the database allows you to either begin new forms of exercise, or else brush up on your existing technique.'
                )
              ],
            )
          )
        ],
      )
    );

    Widget history = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'HISTORY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                Text(
                  'In order to view your fitness progress, head over to the History page. As you complete more exercise sessions, the graph will increase in detail, allowing you to see your exact rate of improvement for each exercise.'
                )
              ],
            )
          )
        ],
      )
    );

    Widget startsession = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'START SESSION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                Text(
                  'Last, but certainly not least, is the Start Session page, where you\'ll actually record your progress each time you work out. After navigating to the Start Session page, you\'ll be able to select the exercise you\'d like to do. After completing the exercise, simply enter the number of repetitions, and voila! The number will be automatically stored in the History tab, to be viewed next time you\'re over there.'
                )
              ],
            )
          )
        ],
      )
    );

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
<<<<<<< Updated upstream
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
=======
        intro,
        home,
        exercisedatabase,
        history,
        startsession,
>>>>>>> Stashed changes
      ],
    );
  }
}

class ExerciseDatabase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget pushupSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Pushups',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '   Pushups are blah blah blah very scary i\'m very unathletic.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget situpSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Situps',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '   Situps are sitting and lying down repeatedly or something idk I\'m a CS and music major bro.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget squatSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Squats',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '   Stand, then pretend to sit. Then stand again.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    return MaterialApp(
      title: 'Exercise Database',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise Database'),
        ),
        body: ListView(
          children: [
            pushupSection,
            situpSection,
            squatSection,
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  //making temp arraylist of "exercise" objects for chart testing
  String now = DateTime.now().toString();
  List<Exercise> userProgress = [
    Exercise(name: "push-ups", reps: 0, excTime: 0, currentTime: "now")
  ];
  Widget build(BuildContext context) {
    return Center(
        //child: Text('TEST'),
        child: Container(child: SfCartesianChart()));
  }
}

class StartSessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TEST'),
    );
  }
}
