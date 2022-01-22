import 'package:car_dashboard_flutter_ui/common/cubit/speedometer/speedometer_cubit.dart';
import 'package:car_dashboard_flutter_ui/pages/home/home_page.dart';
import 'package:car_dashboard_flutter_ui/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => SpeedometerCubit(),
        child: const HomePage(),
      ),
    );
  }
}
