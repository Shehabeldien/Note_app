import 'package:flutter/material.dart';
import 'package:note_app/hive.helper.dart';
import 'package:note_app/note_page.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('note1');
  Hive.box('note1').put('key1', []);
  await Hive.openBox(HiveHelper.noteBox);
  await HiveHelper.getNotes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: NotePage());
  }
}
