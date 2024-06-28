import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theate/buisness_logic/authbloc/bloc/authbloc_bloc.dart';
import 'package:theate/firebase_options.dart';

import 'package:theate/presentation/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp( MultiBlocProvider(
    providers: [
      BlocProvider<AuthblocBloc>(create:(context)=> AuthblocBloc()..add(CheckLoginStatuesEvent()))
    ],
    child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}