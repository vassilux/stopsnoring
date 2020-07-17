import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:rxdart/rxdart.dart';
part 'noiser_event.dart';
part 'noiser_state.dart';

class NoiserBloc extends Bloc<NoiserEvent, NoiserState> {

  StreamSubscription<NoiseReading> _noiseSubscription; 
  NoiseMeter _noiseMeter = new NoiseMeter(); 
  List<double> _decibels = [50];

  NoiserBloc() : super(NoiserInitial());

  @override
  Stream<NoiserState> mapEventToState(
    NoiserEvent event,
  ) async* {
    if(event is NoiserStartEvent) {

      try {
      _noiseSubscription = _noiseMeter.noiseStream.listen( (noiseReading) => add(
        NoiseeNewNoiceEvent( noiseReading.maxDecibel, noiseReading.meanDecibel)));
      
      yield NoiserStarted();
     
    } catch (err) {
      print(err);
    }

    }else if(event is NoiserStopEvent) {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      yield NoiserStopped();   

    }else if(event is NoiseeNewNoiceEvent) {
      double decibel = event.maxDecibel;
      if(decibel == double.infinity || decibel == double.negativeInfinity){
        decibel  = 0.0;
      }
      if(_decibels.length > 20 ) {
        _decibels.removeAt(0);
      }
      _decibels.add(decibel);
      
      yield NoiserDatas(currentDecibel: decibel , decibels : _decibels);
    }
  }

 /* @override
  Stream<Transition<NoiserEvent, NoiserState>> transformEvents(
    Stream<NoiserEvent> events,
    TransitionFunction<NoiserEvent, NoiserState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(seconds: 2)),
      transitionFn,
    );
  }*/

  @override
  Future<void> close() {
    _noiseSubscription?.cancel();
    return super.close();
  }

}
