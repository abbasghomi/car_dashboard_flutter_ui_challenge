import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'speedometer_state.dart';

class SpeedometerCubit extends Cubit<SpeedometerState> {
  SpeedometerCubit() : super(InitState()){
    _speed = 0;
    _gear = 0;
  }

  double _speed = 0;
  double get speed => _speed;

  double _gear = 0;
  double get gear => _gear;

  Future<void> speedUp() async {
    emit(BusyState());
    _speed+=0.01;
    emit(SpeedUpdatedState());
    emit(IdleState());
  }

  Future<void> speedDown() async {
    emit(BusyState());
    _speed-=0.01;
    emit(SpeedUpdatedState());
    emit(IdleState());
  }

  Future<void> gearUp() async {
    emit(BusyState());
    _gear+=0.01;
    emit(GearUpdatedState());
    emit(IdleState());
  }

  Future<void> gearDown() async {
    emit(BusyState());
    _gear-=0.01;
    emit(GearUpdatedState());
    emit(IdleState());
  }

}
