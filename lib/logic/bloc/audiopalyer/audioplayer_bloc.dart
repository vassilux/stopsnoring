import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:rxdart/rxdart.dart';

part 'audioplayer_event.dart';
part 'audioplayer_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvents, NoiserAudioPlayerState> {

  bool _isPlaying = false;
  AudioPlayer fixedPlayer = new AudioPlayer();  
  AudioCache _audioCache; 

  AudioPlayerBloc() : super(NoiserAudioPlayerState(AudioPlayer(), "sounds/horse-whinnies.mp3"));

  @override
  Stream<NoiserAudioPlayerState> mapEventToState(
    AudioPlayerEvents event,
  ) async* {
    if (event is InitializePlayer) {      
      _audioCache = new AudioCache(fixedPlayer: this.state.player);

      this.state.source = event.localFile;
      _audioCache.fixedPlayer.onPlayerStateChanged.listen((event) {
        if(event == AudioPlayerState.PLAYING) {
          _isPlaying = true;
          
        }else {
          _isPlaying = false;
        }
        print("_isPlayning $_isPlaying");
      });

      //this.add(PlayPlayer());
      yield this.state;
    }
    if (event is PlayPlayer) {   
      if(_isPlaying == false)  {
        _audioCache.play(this.state.source);
         _isPlaying = true;
      }
      yield this.state;
     
    }

    if (event is PlayRemote) {           

      this.state.player.play(event.remoteURL);
      yield this.state;
    }

    if (event is ShowPlayer) {
      yield this.state;
    }

    if (event is HidePlayer) {
      yield this.state;
    }

  }

  void play(String remoteURL) {
    if(_isPlaying == false){
      this.add(PlayRemote(remoteURL));
    }
    
  }

  void stop() async {
    await this.state.player.stop();
  }

  void pause() async{
    await this.state.player.pause();
  }

  void resume(){
    this.state.player.resume();
  }

   @override
  Stream<Transition<AudioPlayerEvents, NoiserAudioPlayerState>> transformEvents(
    Stream<AudioPlayerEvents> events,
    TransitionFunction<AudioPlayerEvents, NoiserAudioPlayerState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(seconds: 2)),
      transitionFn,
    );
  }

  /*@override
  void dispose() {
    this.state.player.dispose();
  }*/
}
