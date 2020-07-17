part of 'audioplayer_bloc.dart';

abstract class AudioPlayerEvents extends Equatable {
  const AudioPlayerEvents();
}


class InitializePlayer extends AudioPlayerEvents {
  final String localFile;
  InitializePlayer(this.localFile);

  @override
  List<Object> get props => [this.localFile];
}

class PlayRemote extends AudioPlayerEvents {
  final String remoteURL;

  PlayRemote(this.remoteURL);

  @override
  List<Object> get props => [];
}

class PlayPlayer extends AudioPlayerEvents {
 @override
  List<Object> get props => [];
}

class ShowPlayer extends AudioPlayerEvents {
 @override
  List<Object> get props => [];
}

class HidePlayer extends AudioPlayerEvents {
  @override
  List<Object> get props => [];
}