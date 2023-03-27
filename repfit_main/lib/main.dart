import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//charts package:
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

//early attempt at data persistence/storage:
import 'user_data.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//data storage

void main() async{
  await Hive.initFlutter();
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

  var backgroundColors = {
    'Generator': Color.fromARGB(255, 163, 214, 255),
    'Tutorial': Color.fromARGB(255, 255, 244, 193),
    'Exercise Database': Color.fromARGB(255, 236, 192, 255),
    'History': Color.fromARGB(255, 192, 255, 216),
    'Start Session': Color.fromARGB(255, 255, 192, 192),
  };

  Color backgroundColor =
      Color.fromARGB(255, 163, 214, 255); // default background color

  void changeBackgroundColor(Color color) {
    backgroundColor = color;
    notifyListeners();
  }

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

  var pageNames = [
    'Generator',
    'Tutorial',
    'Exercise Database',
    'History',
    'Start Session',
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pageName = pageNames[selectedIndex];
    appState.backgroundColor = appState.backgroundColors[pageName] ??
        Color.fromARGB(255, 163, 214, 255); // default background color

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
      var appState = context.watch<MyAppState>();
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
                color: appState.backgroundColor,
                child: Column(
                  children: [
                    if (selectedIndex == 0)
                      Expanded(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (selectedIndex == 0) SizedBox(height: 16),
                    Expanded(child: page),
                  ],
                ),
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
  //begin modifications to add a youtube player:
  //video ids below:

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    /*if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }*/

    return ListView(
      children: [
        Center(child: new Text('Squats: ')),
        Image.asset('assets/database_vids/squat.gif'),
        Center(child: new Text('Push-Ups:')),
        Image.asset('assets/database_vids/pushup.gif'),
        Center(child: new Text('Sit-Ups: ')),
        Image.asset('assets/database_vids/situp.gif'),
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
                Image.asset('assets/database_vids/pushup.gif'),
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
                  //'   Situps are sitting and lying down repeatedly or something idk I\'m a CS and music major bro.',
                  '    1) Lie down on your back, with your feet on the floor, knees bent.\n    2) Place your hands on either side of your head in a comfortable\n   position.\n    3) Bend your hips and waist to raise your body off the ground. Make sure you keep looking straight ahead, keeping your chin off your chest in a relaxed position.\n   4) Lower your body back to the ground into the starting position.\n   5) Repeat',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Image.asset('assets/database_vids/situp.gif'),
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
                  //'   Stand, then pretend to sit. Then stand again.',
                  '   1) Stand with your feet at shoulders-width\n   2) Bend your knees in a motion like you are about to sit in a chair until your knees make an approximately 90 degree angle.\n   3)Stand back up without locking knees and begin another repetition',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Image.asset('assets/database_vids/squat.gif'),
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
        child: Container(
            child: SfCartesianChart(
                //title
                title: ChartTitle(text: 'Pushups'),
                // Initialize category axis
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
          // Initialize line series
          LineSeries<ChartData, String>(
              dataSource: [
                // Bind data source
                ChartData('week 1', 35),
                ChartData('week 2', 28),
                ChartData('week 3', 34),
                ChartData('week 4', 32),
                ChartData('week 5', 40)
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ])));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

class StartSessionPage extends StatefulWidget {
  const StartSessionPage({Key? key}) : super(key: key);

  @override
  _StartSessionPageState createState() => _StartSessionPageState();
}

class _StartSessionPageState extends State<StartSessionPage> {
  String _selectedExercise = 'Select an exercise';
  Color _buttonColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select an exercise'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text('Pushups'),
                            onTap: () {
                              setState(() {
                                _selectedExercise = 'Pushups';
                                _buttonColor = Colors.red;

                                //_write('pushups', '6');
                                _record(_selectedExercise, 1, 1);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Situps'),
                            onTap: () {
                              setState(() {
                                _selectedExercise = 'Situps';
                                _buttonColor = Colors.green;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Squats'),
                            onTap: () {
                              setState(() {
                                _selectedExercise = 'Squats';
                                _buttonColor = Colors.orange;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                _selectedExercise,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: _buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

//write to file infrastructure below:
  _write(String exercise, String reps) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String pathStart = '${directory.path}/';
    String filePath = pathStart + exercise;

    final File file = File(filePath);
    await file.writeAsString(reps);
  }

  _record(String exercise, int week, int reps) async {
    var box = Hive.box(exercise);
    box.put (week, reps)
  }
}
