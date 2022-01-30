import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'speedometer_state.dart';

class SpeedometerCubit extends Cubit<SpeedometerState> {
  SpeedometerCubit() : super(InitState()) {
    _speed = 0;
    _gear = 0;
  }

  var increamentalValue = 1.0;

  double _speed = 0;

  double get speed => _speed;

  double _gear = 0;

  double get gear => _gear;

  Future<void> speedUp() async {
    if (_speed < 100) {
      emit(BusyState());

      _speed += increamentalValue;
      emit(SpeedUpdatedState());
      emit(IdleState());
    }
  }

  Future<void> speedDown() async {
    if (_speed > 0) {
      emit(BusyState());
      _speed -= increamentalValue;
      emit(SpeedUpdatedState());
      emit(IdleState());
    }
  }

  Future<void> gearUp() async {
    if (_gear < 5) {
      emit(BusyState());
      _gear += increamentalValue;
      emit(GearUpdatedState());
      emit(IdleState());
    }
  }

  Future<void> gearDown() async {
    if (_gear > 0) {
      emit(BusyState());
      _gear -= increamentalValue;
      emit(GearUpdatedState());
      emit(IdleState());
    }
  }
}
