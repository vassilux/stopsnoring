part of 'noiser_bloc.dart';

@immutable
abstract class NoiserEvent extends Equatable{
  const NoiserEvent();
}

class NoiserStartEvent extends NoiserEvent {
  @override
  List<Object> get props => [];
}

class NoiserStopEvent extends NoiserEvent {
  @override
  List<Object> get props => [];
}

class NoiseeNewNoiceEvent extends NoiserEvent {
  final double maxDecibel;
  final double meanDecibel;

  NoiseeNewNoiceEvent(
    this.maxDecibel,
    this.meanDecibel,
  );


  @override 
  List<Object> get props => [maxDecibel, meanDecibel];  
}
