import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:note_app/hive.helper.dart';

import 'cubit/cubit/note_cubit.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'View/note_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox(HiveHelper.noteBox);

  await HiveHelper.getNotes();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NoteCubit()..getNotes(),
        child: Scaffold(body: Center(child: NotePageState())),
      ),
    );
  }
}
