
part of 'speedometer_cubit.dart';

abstract class SpeedometerState extends Equatable{
  const SpeedometerState();

  @override
  List<Object> get props => [];
}

class InitState extends SpeedometerState{}

class SpeedUpdatedState extends SpeedometerState{}

class GearUpdatedState extends SpeedometerState{}


class BusyState extends SpeedometerState{}
class IdleState extends SpeedometerState{}