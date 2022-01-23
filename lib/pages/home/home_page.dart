import 'package:car_dashboard_flutter_ui/common/configs/ui_configs.dart';
import 'package:car_dashboard_flutter_ui/common/cubit/speedometer/speedometer_cubit.dart';
import 'package:car_dashboard_flutter_ui/common/widgets/GradientArcPainter.dart';
import 'package:car_dashboard_flutter_ui/common/widgets/dashboard_test_button.dart';
import 'package:car_dashboard_flutter_ui/common/widgets/gauge_progress_Indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Car Dashboard',
      //         style: UiConfigs.titleTextStyle,
      //       ),
      //       Text(
      //         'UI Challenge by Abbas Ghomi',
      //         style: UiConfigs.subTitleTextStyle,
      //       ),
      //     ],
      //   ),
      // ),
      body: ListView(
        children: [

          BlocBuilder<SpeedometerCubit, SpeedometerState>(
            builder: (context, state) {
              if (state is SpeedUpdatedState) {
                return Text(
                  'updating...',
                  style: UiConfigs.normalTextStyle,
                );
              }
              return Column(
                children: [
                  // CustomPaint(
                  //   size: const Size(200.0, 200.0),
                  //   painter: GradientArcPainter(
                  //     progress:context.read<SpeedometerCubit>().speed,
                  //     startColor: Colors.green,
                  //     endColor: Colors.red,
                  //     width: 20.0,
                  //   ),
                  // ),
                  CustomPaint(
                    size: const Size(1600.0, 1600.0),
                    painter: GaugeProgressIndicator(
                      bgColor: Colors.green,
                      width: 70.0,
                      lineColor: Colors.red,
                      percent: context.read<SpeedometerCubit>().speed,
                    ),
                  ),
                  Text(
                    '${context.read<SpeedometerCubit>().speed}',
                    style: UiConfigs.normalTextStyle,
                  ),
                ],
              );
            },
          ),
          BlocBuilder<SpeedometerCubit, SpeedometerState>(
            builder: (context, state) {
              if (state is GearUpdatedState) {
                return Text(
                  'updating...',
                  style: UiConfigs.normalTextStyle,
                );
              }
              return Text(
                '${context.read<SpeedometerCubit>().gear}',
                style: UiConfigs.normalTextStyle,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardTestButton(
                buttonText: 'Speed Up',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().speedUp(),
              ),
              DashboardTestButton(
                buttonText: 'Speed Down',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().speedDown(),
              ),
              DashboardTestButton(
                buttonText: 'Gear Up',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().gearUp(),
              ),
              DashboardTestButton(
                buttonText: 'Gear Down',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().gearDown(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
