/*-----------------------------------------------------------------------------------------
                                Imports
-----------------------------------------------------------------------------------------*/
// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//charts package:
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

//import 'package:path_provider/path_provider.dart';

import 'package:hive_flutter/hive_flutter.dart';

// Create variables for the three exercises
var Pushups = Hive.box('Pushups');
var Situps = Hive.box('Situps');
var Squats = Hive.box('Squats');

//data storage

//write to file infrastructure below:

//checks the entered exercise against a predefined list, as flutter/dart is annoying i have to use these...
//if the entered exc is matched, the respective box is opened then the data is added to it through ".put()"

Future main() async {
  //await Hive.initFlutter();
  await Hive.initFlutter();
  runApp(MyApp());
}

/*-----------------------------------------------------------------------------------------
                            Start of MyApp Class
-----------------------------------------------------------------------------------------*/
class MyApp extends StatelessWidget {
  //initialize boxes
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RepFit',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 79, 195, 237)),
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
    'Generator': Color.fromARGB(255, 188, 228, 242),
    'Tutorial': Color.fromARGB(255, 225, 239, 249),
    'Exercise Database': Color.fromARGB(255, 176, 230, 255),
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
  const MyHomePage({super.key});

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
            /*-------------------------------------------------------------------------------------------------------*/
            /*                 The following NavigationRails are what make up the page sidebar                       */
            /*-------------------------------------------------------------------------------------------------------*/
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,

                /* Home Navigation Page */
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),

                  /* Tutorial Navigation Page */
                  NavigationRailDestination(
                    icon: Icon(Icons.lightbulb),
                    label: Text('Tutorial'),
                  ),

                  /* Exercise Database Navigation Page */
                  NavigationRailDestination(
                      icon: Icon(Icons.library_books),
                      label: Text('Exercise Database')),

                  /* History Navigation Page */
                  NavigationRailDestination(
                      icon: Icon(Icons.auto_graph), label: Text('History')),

                  /* StartSession Navigation Page */
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

            /*-------------------------------------------------------------------------------------------------------*/
            /*                 End of NavigationRails that make up the page sidebar                                  */
            /*-------------------------------------------------------------------------------------------------------*/

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
                                    const EdgeInsets.only(top: 40, bottom: 10),
                                child: const Text(
                                  'ABOUT THE FOUNDERS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Text(
                                'RepFit was founded by Hunter Odom, Austin Jackman, and Raymond Riddell, three young Computer Science majors with a passion for both exercise and helping others.')
                          ],
                        ),
                      ),
                    Visibility(
                      visible: selectedIndex != 0,
                      child: Expanded(child: page),
                    ),
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
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
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
  const TutorialPage({super.key});

  //begin modifications to add a youtube player:
  //video ids below:

  @override
  Widget build(BuildContext context) {
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
  const ExerciseDatabase({super.key});

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
                  '   1)Start at in a plank position with knees and elbows straight at about a 30 degree angle. \n2) Lower yourself down until the elbows form approximately a right angle without allowing the waist to bend \n3) Repeat',
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
}

/*-----------------------------------------------------------------------------------------
                            Start of History Page Class
-----------------------------------------------------------------------------------------*/
/* this future makes an empty list of chartdata objects and assigns the now opened box of 
   selected exercise to "box", loops through all non-null elements of the list, and returns 
                the list once it reaches a null element. */

void _record(String exercise, int session, int reps) {
  if (exercise == 'Pushups') {
    Hive.openBox(exercise);
    Pushups.put(session, reps);
  } else if (exercise == 'Situps') {
    Hive.openBox(exercise);
    Situps.put(session, reps);
  } else if (exercise == 'Squats') {
    Hive.openBox(exercise);
    Squats.put(session, reps);
  }
}

//converted to stateful to allow a call of "setstate()" within the elevatedbutton refresh in bottom of column.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String exercise = 'Pushups';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$exercise History'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: FutureBuilder<List<ChartData>>(
              future: _fetchChartData(exercise),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!;
                  return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<ChartData, int>>[
                      LineSeries<ChartData, int>(
                        dataSource: data,
                        xValueMapper: (ChartData data, _) => data.session,
                        yValueMapper: (ChartData data, _) => data.reps,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    exercise = 'Pushups';
                  });
                },
                child: Text('Pushups'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    exercise = 'Situps';
                  });
                },
                child: Text('Situps'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    exercise = 'Squats';
                  });
                },
                child: Text('Squats'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 50, left: 22),
            child: ElevatedButton(
              child: const Text('Refresh'),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ChartData>> makeList(String input) async {
    List<ChartData> chartData = [];

    var box = await Hive.openBox(input);
    int j = 0;
    //changed to 0 from 1
    //establish length of box
    while (box.get(j.toInt()) != null) {
      chartData.add(ChartData(j, box.get(j).toInt()));
      j = j + 1;
    }
    return chartData;
  }

//future simply declares that there will be a list of chartdata objects and returns it when available.
  Future<List<ChartData>> _fetchChartData(exercise) async {
    return await makeList(exercise);
    //return data;
  }
}

class ChartData {
  int session;
  int reps;

  ChartData(this.session, this.reps);

  void add(int sessionIn, int repsIn) {
    reps = repsIn;
    session = sessionIn; //.toString();
  }
}

/*-----------------------------------------------------------------------------------------
                            Start of StartSessionPage Class
-----------------------------------------------------------------------------------------*/
class StartSessionPage extends StatefulWidget {
  const StartSessionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StartSessionPageState createState() => _StartSessionPageState();
}

/*-----------------------------------------------------------------------------------------
                            Start of _StartSessionPageState Class
-----------------------------------------------------------------------------------------*/
class _StartSessionPageState extends State<StartSessionPage> {
  String _selectedExercise = 'Select an exercise'; // Default exercise selection
  Color _buttonColor = Colors.blue; // Default button color
  late bool _timerStarted =
      false; // Boolean flag to indicate if the exercise has ended
  int _timeElapsed = 0; // Time elapsed in seconds
  final int _completedReps = 0; // Number of completed repetitions
  late bool _exerciseInProgress =
      false; // Boolean flag to indicate if the exercise is in progress
  int _repetitionsCompleted = 0; // Number of repetitions completed
  Timer? _timer; // Timer instance, nullable because it may be null
  int session = 0;

  @override
  Widget build(BuildContext context) {
    // Returns a Scaffold widget that has an AppBar and a body.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Start Session'), // Sets the title of the AppBar to 'Start Session'.
      ),
      body: Center(
        // The body contains a Column widget with centered children.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Displays a dialog when the button is pressed.
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                          'Select an exercise'), // Sets the title of the dialog.
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text(
                                'Pushups'), // The text for the first option.
                            onTap: () {
                              setState(() {
                                // Sets the selected exercise to 'Pushups' and the button color to red.
                                //_record('Pushups', session, _completedReps);
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
                            title: const Text(
                                'Situps'), // The text for the second option.
                            onTap: () {
                              setState(() {
                                // Sets the selected exercise to 'Situps' and the button color to green.
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
                            title: const Text(
                                'Squats'), // The text for the third option.
                            onTap: () {
                              setState(() {
                                _selectedExercise = 'Squats';
                                _buttonColor = Colors
                                    .orange; // Sets the selected exercise to 'Squats' and the button color to orange.
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
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _buttonColor, // Sets the background color of the button to the selected exercises's color.
              ),
              child: Text(
                _selectedExercise, // The text for the button, which displays the currently selected exercise.
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16), // Adds some spacing below the button.
            Text(
              _formatTime(
                  _timeElapsed), // Formats the time elapsed and displays it as text.
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(
                height: 16), // Adds some spacing below the time text.
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _timerStarted = !_timerStarted;
                });
                _timerStarted
                    ? _startTimer()
                    : _stopTimer(); // Starts or stops the timer when the button is pressed.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text(
                _timerStarted
                    ? 'Stop'
                    : 'Start', // The text for the button changes between 'Start' and 'Stop' depending on wheather the timer is currently counting or not.
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Button to end exercise and save repetitions completed
            if (_exerciseInProgress)
              ElevatedButton(
                onPressed: () {
                  _stopExercise();
                  _showRepetitionsDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(253, 243, 242, 0.738),
                ),
                child: const Text('End Exercise'),
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
    // Initializes the _timer object with a periodic timer that executes every second
    // and increments the _timeElapsed variable by 1.
    _timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timerStarted = true;
        _timeElapsed++;
      });
    });
  }

  /*-----------------------------------------------------------------------------------------
                              Start of _stopTimer Method
  -----------------------------------------------------------------------------------------*/
  void _stopTimer() {
    //check if timer object is not null
    if (_timer != null) {
      // If the timer is not null then cancel the timer
      _timer!.cancel();
      // set the timer to null
      _timer = null;
    }
  }

  /*-----------------------------------------------------------------------------------------
                            Start of _ShowStartOptions Method
  -----------------------------------------------------------------------------------------*/
  // Defines a private function called _showStartOptions()
  void _showStartOptions() {
    // Shows an AlertDialog with a "Start options" title and two options: "Start manually" and "Activate voice start"
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
                  // When the "Start manually" option is tapped, it invokes the _startManually() function and closes the dialog window by calling Navigator.pop(context).
                  Navigator.pop(context);
                  _startManually();
                },
              ),
              ListTile(
                title: const Text('Activate voice start'),
                onTap: () {
                  // When the "Activate voice start" option is tapped, it invokes the _activateVoiceStart() function and closes the dialog window by calling Navigator.pop(context).
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
  /* The following method when called shows an AlertDialog with a "Manual start" tile and
  a single ElevatedButton labeled "Start exercise." When the button is pressed, it calls the
  private function _startTimer() and sets the boolean _exerciseInProgress to true and the
  _timerStarted variable. Finally it then closes the dialog window called by Naviagtor.pop(context) */

  // Defines a private function called _startManually()
  void _startManually() {
    // Shows an AlertDialog with a "Manual start" title and a single ElevatedButton labeled "Start exercise"
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manual start'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                // When the button is pressed, it calls the private function _startTimer() and sets the boolean _exerciseInProgress to true and the _timerStarted variable.
                onPressed: () {
                  _startTimer();
                  setState(() {
                    _exerciseInProgress = true;
                    _timerStarted; // This should be _timerStarted = true;
                  });
                  // Finally, it closes the dialog window by calling Navigator.pop(context).
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
  /* The following method stops the timer and sets _exerciseInProgress to false and indicates
                                the end of an exercise                                     */
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
    Hive.openBox(_selectedExercise);
    showDialog(
      // Use the showDialog method to display the AlertDialog
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Return the AlertDialog with given properties
          title: const Text('Repetitions Completed'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                // Update _repetitionsCompleted with the value from the TextField
                _repetitionsCompleted = int.tryParse(value) ?? 0;
              });
            },
          ),
          actions: [
            TextButton(
              // Create Cancel Button
              onPressed: () {
                Navigator.pop(
                    context); // Close dialog box, and set timerStarted and exerciseInProgress to true
                _startTimer();
                setState(() {
                  _timerStarted = true;
                  _exerciseInProgress = true;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              // Create Save Button
              onPressed: () async {
                // add here _record
                //changed _completedreps to repetitionscompleted
                _record(_selectedExercise, session, _repetitionsCompleted);
                session++;
                _repetitionsCompleted += _completedReps;
                setState(() {
                  // Update  exerciseInProgress, timerStarted, timeElapsed
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