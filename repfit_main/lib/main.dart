/*-----------------------------------------------------------------------------------------
                                Imports
-----------------------------------------------------------------------------------------*/
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
  //await Hive.initFlutter();
  runApp(MyApp());
}

/*-----------------------------------------------------------------------------------------
                            Start of MyApp Class
-----------------------------------------------------------------------------------------*/
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

/*-----------------------------------------------------------------------------------------
                            Start of MyAppState Class
-----------------------------------------------------------------------------------------*/
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var backgroundColors = {
    'Generator': Color.fromARGB(255, 192, 255, 216),
    'Tutorial': Color.fromARGB(255, 163, 214, 255),
    'Exercise Database': Color.fromARGB(255, 236, 192, 255),
    'History': Color.fromARGB(255, 255, 244, 193),
    'Start Session': Color.fromARGB(255, 255, 192, 192),
  };

  Color backgroundColor =
      Color.fromARGB(255, 163, 214, 255); // default background color

  void changeBackgroundColor(Color color) {
    backgroundColor = color;
    notifyListeners();
  }
}

/*-----------------------------------------------------------------------------------------
                            Start of MyHomePage Class
-----------------------------------------------------------------------------------------*/
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/*-----------------------------------------------------------------------------------------
                            Start of _MyHomePageState Class
-----------------------------------------------------------------------------------------*/
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
                padding: const EdgeInsets.all(10),
                color: appState.backgroundColor,
                child: Column(
                  children: [
                    if (selectedIndex == 0)
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 200,
                              fit: BoxFit.fitHeight,
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 40),
                                child: const Text(
                                  'MISSION STATEMENT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Text(
                              'Our mission is to allow users to develop a synergy with our app, creating a positive feedback loop in which the user will calendarise progress via gamification, leading to a more robust lifestyle.',
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              'assets/images/whiteboys.png',
                              height: 200,
                              fit: BoxFit.fitHeight,
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 40),
                                child: const Text(
                                  'ABOUT THE FOUNDERS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Text(
                                'RepFit was founded by Hunter Odom, Austin Jackman, and Raymond Riddell, three young Computer Science majors with a passion for both exercise and helping others. Filler text filler text filler text filler text.')
                          ],
                        ),
                      ),
                    if (selectedIndex == 0) SizedBox(height: 1),
                    Expanded(child: page),
                    Text('TEST')
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

/*-----------------------------------------------------------------------------------------
                            Start of GeneratorPage Class
-----------------------------------------------------------------------------------------*/
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

/*-----------------------------------------------------------------------------------------
                            Start of TutorialPage Class
-----------------------------------------------------------------------------------------*/
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

/*-----------------------------------------------------------------------------------------
                            Start of ExerciseDatabase Class
-----------------------------------------------------------------------------------------*/
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

/*-----------------------------------------------------------------------------------------
                            Start of History Page Class
-----------------------------------------------------------------------------------------*/
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
  String _selectedExercise = 'Select an exercise'; // Default exercise selection
  Color _buttonColor = Colors.blue; // Default button color
  bool _exerciseEnded =
      false; // Boolean flag to indicate if the exercise has ended
  bool _timerStarted =
      false; // Boolean flag to indicate if the exercise has ended
  int _timeElapsed = 0; // Time elapsed in seconds
  int _completedReps = 0; // Number of completed repetitions
  Duration _timerDuration =
      Duration(hours: 24); // Maximum duration for the timer
  bool _timerExpired =
      false; // Boolean flag to indicate if the timer has expired
  bool _exerciseInProgress =
      false; // Boolean flag to indicate if the exercise is in progress
  int _repetitionsCompleted = 0; // Number of repetitions completed
  Timer? _timer; // Timer instance, nullable because it may be null

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
                                _stopTimer();
                                _timerStarted = false;
                                _timeElapsed = 0; // Reset the timer to 0
                              });
                              Navigator.pop(context);
                              _showStartOptions();
                            },
                          ),
                          ListTile(
                            title: const Text('Situps'),
                            onTap: () {
                              setState(() {
                                _selectedExercise = 'Situps';
                                _buttonColor = Colors.green;
                                _stopTimer();
                                _timerStarted = false;
                                _timeElapsed = 0; // Reset the timer to 0
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
                                _stopTimer();
                                _timerStarted = false;
                                _timeElapsed = 0; // Reset the timer to 0
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
            const SizedBox(height: 16),
            Text(
              _formatTime(_timeElapsed),
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _timerStarted = !_timerStarted;
                });
                _timerStarted ? _startTimer() : _stopTimer();
              },
              child: Text(
                _timerStarted ? 'Stop' : 'Start',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
            // Button to end exercise and save repetitions completed
            if (_exerciseInProgress)
              ElevatedButton(
                onPressed: () {
                  _stopExercise();
                  _showRepetitionsDialog();
                },
                child: const Text('End Exercise'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(253, 243, 242, 0.738),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _formatTime Method
  -----------------------------------------------------------------------------------------*/

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds ~/ 60) % 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$remainingSeconds';
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _startTimer Method
  -----------------------------------------------------------------------------------------*/
  void _startTimer() {
    _timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  /*-----------------------------------------------------------------------------------------
                              Start of _stopTimer Method
  -----------------------------------------------------------------------------------------*/
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _ShowStartOptions Method
  -----------------------------------------------------------------------------------------*/
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

  /*-----------------------------------------------------------------------------------------
                            Start of _startManually Method
  -----------------------------------------------------------------------------------------*/
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
                  setState(() {
                    _exerciseInProgress = true;
                    _timerStarted;
                  });
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

  /*-----------------------------------------------------------------------------------------
                              Start of _StopExercise Method
  -----------------------------------------------------------------------------------------*/
  void _stopExercise() {
    _stopTimer();
    setState(() {
      _exerciseInProgress = false;
    });
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _showRepetitionDialog Method
  -----------------------------------------------------------------------------------------*/
  void _showRepetitionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Repetitions Completed'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _repetitionsCompleted = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startTimer();
                setState(() {
                  _timerStarted = true;
                  _exerciseInProgress = true;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _repetitionsCompleted += _completedReps;
                  _exerciseInProgress = false;
                  _timerStarted = false;
                  _timeElapsed = 0; // Reset the timer to 0
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _saveRepetitions Method
  -----------------------------------------------------------------------------------------*/
  void _saveRepetitions() {
    // TODO: save the repetitions completed
    print('Repetitions Completed: $_repetitionsCompleted');
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _activateVoiceStart Method
  -----------------------------------------------------------------------------------------*/
  void _activateVoiceStart() {
    // Code to activate voice start feature goes here
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

//write to file infrastructure below:

_record(String exercise, int session, int reps) async {
  var box = Hive.box(exercise);
  box.put(session, reps);
}
