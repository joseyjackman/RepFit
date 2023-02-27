//import 'dart:async';

//import 'package:flutter/widgets.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';

class Exercise {
  final String name;
  final int reps;
  final double excTime;
  final String currentTime;

  const Exercise({
    required this.name,
    required this.reps,
    required this.excTime,
    required this.currentTime,
  });
}
