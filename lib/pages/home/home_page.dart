import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:car_dashboard_flutter_ui/common/configs/ui_configs.dart';
import 'package:car_dashboard_flutter_ui/common/cubit/speedometer/speedometer_cubit.dart';
import 'package:car_dashboard_flutter_ui/common/widgets/dashboard_test_button.dart';
import 'package:car_dashboard_flutter_ui/common/widgets/gauge_progress_Indicator.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: UiConfigs.pageBackColor,
      body: ListView(
        children: [

          BlocBuilder<SpeedometerCubit, SpeedometerState>(
            builder: (context, state) {
              if (state is SpeedUpdatedState || state is GearUpdatedState) {
                return Text(
                  'updating...',
                  style: UiConfigs.normalTextStyle,
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 50.0,),
                  FutureBuilder<ui.Image>(
                    future: loadImage(),
                    builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot){
                      return !snapshot.hasData
                          ? const CircularProgressIndicator()
                          :
                       CustomPaint(
                        size: const Size(400.0, 400.0),
                        painter: GaugeProgressIndicator(
                          bgColor: UiConfigs.speedOMeterTextColorInActive,
                          lineColor: UiConfigs.speedOMeterSpeedIndicatorColor,
                          textColor: UiConfigs.speedOMeterSpeedTextColor,
                          width: 15.0,
                          currentSpeed: context.read<SpeedometerCubit>().speed,
                          currentGear: context.read<SpeedometerCubit>().gear,
                          startValue: 0.0,
                          endValue: 100.0,
                          startAngle: -225,
                          endAngle: 45,
                          gapsValues: [65.0],
                          fillColorValues:[UiConfigs.speedOMeterCircleColorActive, Colors.yellow],
                          partsCount : 2,//context.read<SpeedometerCubit>().speed.toInt()+2,
                          gapArrangement: GapArrangement.valueList,
                          image: snapshot.data,
                        ),
                      );
                    },
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
                enableContinuousTap: true,
                buttonText: 'Speed Up',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().speedUp(),
              ),
              DashboardTestButton(
                enableContinuousTap: true,
                buttonText: 'Speed Down',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().speedDown(),
              ),
              DashboardTestButton(
                enableContinuousTap: false,
                buttonText: 'Gear Up',
                backgroundColor: UiConfigs.indicatorTextColor,
                onTapDown: () => context.read<SpeedometerCubit>().gearUp(),
              ),
              DashboardTestButton(
                enableContinuousTap: false,
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

  Future<ui.Image> loadImage() async {
    ByteData bd = await rootBundle.load("assets/images/fuel_efficiency.png");
    final Uint8List bytes = Uint8List.view(bd.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }
}
