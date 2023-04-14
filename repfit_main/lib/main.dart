import 'dart:async';

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

void main() async {
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
                          fit: BoxFit.fill,
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
                    )),
                Text(
                    'Welcome to the RepFit fitness app! This page will show you exactly what your options are to navigate this app, as well as what each option means. Aside from this Tutorial page, there are 4 other pages: The Home page, the Exercise Database, the History page, and the Start Session page.')
              ],
            ))
          ],
        ));

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
                    )),
                Text(
                    'The function of the Home page is to serve as an introduction to the rest of the RepFit app. There, you will find an introduction to RepFit\'s founders, as well as our mission statement.')
              ],
            ))
          ],
        ));

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
                    )),
                Text(
                    'The Exercise Database your one-stop shop for all your exercise questions. Conatining both videos and a text description of every exercise we track in the RepFit app, the database allows you to either begin new forms of exercise, or else brush up on your existing technique.')
              ],
            ))
          ],
        ));

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
                    )),
                Text(
                    'In order to view your fitness progress, head over to the History page. As you complete more exercise sessions, the graph will increase in detail, allowing you to see your exact rate of improvement for each exercise.')
              ],
            ))
          ],
        ));

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
                    )),
                Text(
                    'Last, but certainly not least, is the Start Session page, where you\'ll actually record your progress each time you work out. After navigating to the Start Session page, you\'ll be able to select the exercise you\'d like to do. After completing the exercise, simply enter the number of repetitions, and voila! The number will be automatically stored in the History tab, to be viewed next time you\'re over there.')
              ],
            ))
          ],
        ));

    /*if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }*/

    return ListView(
      children: [
        intro,
        home,
        exercisedatabase,
        history,
        startsession,
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

/*-----------------------------------------------------------------------------------------
                            Start of StartSessionPage Class
-----------------------------------------------------------------------------------------*/
class StartSessionPage extends StatefulWidget {
  const StartSessionPage({Key? key}) : super(key: key);

  @override
  _StartSessionPageState createState() => _StartSessionPageState();
}

/*-----------------------------------------------------------------------------------------
                            Start of _StartSessionPageState Class
-----------------------------------------------------------------------------------------*/
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
                              _showStartOptions();
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
                              _showStartOptions();
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

  void _showStartOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Start manually'),
                onTap: () {
                  Navigator.pop(context);
                  _startManually();
                },
              ),
              ListTile(
                title: const Text('Activate voice start'),
                onTap: () {
                  Navigator.pop(context);
                  _activateVoiceStart();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startManually() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manual start'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _startTimer();
                  Navigator.pop(context);
                },
                child: const Text('Start exercise'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _activateVoiceStart() {
    // Code to activate voice start feature goes here
  }

  void _startTimer() {
    // Code to start timer goes here
    // After the timer is stopped, show a dialog to store how many reps were done
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Press "Start" to begin exercise timer.'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startCountdown();
                },
                child: const Text('Start'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startCountdown() {
    int _counter = 10; // initial timer value in seconds
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Countdown'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$_counter'),
            ],
          ),
        );
      },
    );
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel();
        _showRepsDialog();
      }
    });
  }

  void _showRepsDialog() {
    int _repsCount = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter reps'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter number of reps',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _repsCount = int.parse(value);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveRepsCount(_repsCount);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveRepsCount(int repsCount) {
    // code to save the reps count
  }
}
//write to file infrastructure below:

_record(String exercise, int session, int reps) async {
  var box = Hive.box(exercise);
  box.put(session, reps);
//write to file infrastructure below:

  _record(String exercise, int session, int reps) async {
    var box = Hive.box(exercise);
    box.put(session, reps);
  }
}
