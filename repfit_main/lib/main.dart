// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:hive_flutter/hive_flutter.dart';

var Pushups = Hive.box('Pushups');
var Situps = Hive.box('Situps');
var Squats = Hive.box('Squats');
//data storage
//write to file infrastructure below:

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

Future main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //initialize boxes

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
  }) : super(key: key);

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
      ),
    );
  }
}

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

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

//this future makes an empty list of chartdata objects, assigns the now opened box of selected exercise to "box",
//loops through all non-null elements of the list, and returns the list once it reaches a null element.
Future<List<ChartData>> makeList(String input) async {
  List<ChartData> chartData = [];

  var box = await Hive.openBox(input);
  int j = 1;
  //establish length of box
  while (box.get(j.toInt()) != null) {
    chartData.add(ChartData(j, box.get(j).toInt()));
    j = j + 1;
  }
  return chartData;
}

//converted to stateful to allow a call of "setstate()" within the elevatedbutton refresh in bottom of column.
class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String exercise = 'PushUps';

  //declare box vars to avoid annoying errors and provide access
  var Pushups = Hive.openBox('Pushups');
  var Situps = Hive.openBox('Situps');
  var Squats = Hive.openBox('Squats');

  //end
  //future simply declares that there will be a list of chartdata objects and returns it when available.
  Future<List<ChartData>> _fetchChartData() async {
    final data = await makeList(exercise);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pushups History'),
        //title: Text(Hive.openBox('Pushups').get(1).toString()),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: FutureBuilder<List<ChartData>>(
              //establishes use of the chartdata type
              future: _fetchChartData(),
              builder: (coCategoryAxisntext, snapshot) {
                //through snapshot, each element returned from the list of chartdata elemenets is referenced sequentially.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  //each data point from the snapshot is referenced and saved into the variable "Data"
                  final data = snapshot.data!;
                  return SfCartesianChart(
                    //originally category based but didnt work right(BELOW) (updated: it does work and eliminated the decimals from sessions)
                    primaryXAxis: CategoryAxis(),
                    //lineseries establishes the line graph format and the subsequent int declarations declare the awaited data types.
                    series: <LineSeries<ChartData, int>>[
                      LineSeries<ChartData, int>(
                        dataSource: data,
                        //from each ChartData object, the separate session and rep integers are pulled for display
                        xValueMapper: (ChartData data, _) => data.session,
                        yValueMapper: (ChartData data, _) => data.reps,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.5);
                  }
                  return null; // Use the component's default.
                },
              ),
            ),
            child: const Text('Refresh'),
            onPressed: () {
              //sets state back to default.
              setState(() {});
            },
          ),
        ],
      ),
    );
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
  bool _exerciseEnded = false;
  bool _timerStarted = false;
  int _timeElapsed = 0;
  int _completedReps = 0;
  Timer? _timer;

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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _exerciseEnded ? null : _endExercise,
              child: const Text('End Exercise'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  void _startTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _timeElapsed++;
        });
      });
    }
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
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
                  setState(() {
                    _timerStarted;
                  });
                },
                child: const Text('Start exercise'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _endExercise() {
    int finalreps = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter the number of reps completed"),
          content: TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number';
              }
              final reps = int.tryParse(value);
              if (reps == null || reps <= 0) {
                return 'Please enter a positive number';
              }
              finalreps = reps;
              return null;
            },
            onSaved: (value) {
              setState(() {
                _exerciseEnded = true;
                _completedReps = int.parse(value!);
                //finalreps = _completedReps;
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Exit the alert box
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Exit the alert box
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _record(_selectedExercise, 1, finalreps);
                _record(_selectedExercise, 2, finalreps);
                _record(_selectedExercise, 3, finalreps);
                final form = Form.of(context);
                if (form != null && form.validate()) {
                  form.save();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _activateVoiceStart() {
    // Code to activate voice start feature goes here
  }
  //checks the entered exercise against a predefined list, as flutter/dart is annoying i have to use these...
  //if the entered exc is matched, the respective box is opened then the data is added to it through ".put()"
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

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
