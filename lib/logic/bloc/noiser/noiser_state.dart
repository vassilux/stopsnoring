part of 'noiser_bloc.dart';

@immutable
abstract class NoiserState extends Equatable{
  const NoiserState();
}

class NoiserInitial extends NoiserState {
  @override
  List<Object> get props => [];
}

class NoiserStarted extends NoiserState {
  @override
  List<Object> get props => [];
}

class NoiserStopped extends NoiserState {
  @override
  List<Object> get props => [];
}

class NoiserDatas extends NoiserState {
  final double currentDecibel;
  final List<double> decibels;
  
  NoiserDatas({
    this.currentDecibel,
    this.decibels,
  });


  @override 
  List<Object> get props => [currentDecibel, decibels];  
}

