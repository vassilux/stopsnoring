import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:flutter/material.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'dart:async';

import 'package:start_chart/chart/line_chart.dart';

import 'logic/bloc/audiopalyer/audioplayer_bloc.dart';
import 'logic/bloc/noiser/noiser_bloc.dart';
import 'my_bloc_observer.dart';



void main() {
  Bloc.observer = MyBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NoiserBloc>(
          create: (context) => NoiserBloc(),
        ),
        BlocProvider<AudioPlayerBloc>(
          create: (context) => AudioPlayerBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AudioPlayerBloc>(context).add(InitializePlayer("sounds/horse-whinnies.mp3"));
  }


  /*_streamSnoring(BuildContext context, AsyncSnapshot<NoiseReading> snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      var currentValue = snapshot.data;
      dBAValue = currentValue.meanDecibel ?? 0;
      _decibels.add(currentValue.meanDecibel);

      dBAStringValue = currentValue.maxDecibel.toStringAsFixed(1).toString();
      //currentValue.meanDecibel > 100 ? '' + currentValue.meanDecibel.toString() : '0' + currentValue.meanDecibel.toString();

      if (_decibels.length > 20) {
        _decibels.removeAt(0);
      }

      final Function wp = Screen(context).wp;
      final Function hp = Screen(context).hp;

      return Container(
          color: Colors.black,
          height: hp(85),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '$dBAStringValue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  // fontFamily: 'DSEG7 Modern',
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'dBA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                // fontFamily: 'DSEG7 Modern',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              color: Colors.blueAccent,
                              child: FAProgressBar(
                                backgroundColor: Colors.transparent,
                                borderRadius: 0,
                                size: MediaQuery.of(context).size.width,
                                animatedDuration: Duration(milliseconds: 500),
                                maxValue: 140,
                                direction: Axis.vertical,
                                verticalDirection: VerticalDirection.up,
                                currentValue: dBAValue.toInt(),
                                displayText: ' dBA',
                                changeColorValue: 90,
                                changeProgressColor: Colors.red,
                                progressColor: Colors.black,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              child: Center(
                                child: LineChart(
                                  data: _decibels,
                                  size: Size(wp(100), hp(30)),
                                  lineWidth: 5,
                                  lineColor: Colors.white,
                                  pointSize: 10,
                                  pointColor: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ));
    } else {
      return Center(
        child: Text(
          'ConnectionState is not active',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
    }
  }*/

  Widget _buldCommand(BuildContext context) {
    return BlocBuilder<NoiserBloc, NoiserState>(
        bloc: BlocProvider.of<NoiserBloc>(context),
        builder: (context, state) {
          var isRecording = true;
          if ((state is NoiserStopped) || (state is NoiserInitial)) {
            isRecording = false;
          } else {
            isRecording = true;
          }
          //
          return FloatingActionButton(
              backgroundColor: isRecording ? Colors.red : Colors.blue,
              onPressed: () {
                if (isRecording == true) {
                  BlocProvider.of<NoiserBloc>(context)
                      .add(new NoiserStopEvent());
                } else {
                  BlocProvider.of<NoiserBloc>(context)
                      .add(new NoiserStartEvent());
                }
              }, //_isRecording ? stop : start,
              child: isRecording ? Icon(Icons.stop) : Icon(Icons.play_arrow));
        }); //FlatButton.icon(onPressed: null, icon: null, label: null);
  }
  

  Widget _buildBody(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return BlocBuilder<NoiserBloc, NoiserState>(
        bloc: BlocProvider.of<NoiserBloc>(context),
        builder: (context, state) {
          List<double> decibels = [50];
          String dBAStringValue = "0";
          double dBAValue = 0;

          if (state is NoiserDatas) {
            dBAValue = state.currentDecibel;
            decibels = state.decibels;
            dBAStringValue = dBAValue.toStringAsFixed(1).toString();
          } else if(state is NoiserStopped){
            decibels = [];
          }

          if(dBAValue > 66) {
            BlocProvider.of<AudioPlayerBloc>(context).add(PlayPlayer());
          }

        return Container(
        color: Colors.black,
        height: hp(85),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Center(child: this._buldCommand(context)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '$dBAStringValue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 50,
                                color: Colors.white,
                                // fontFamily: 'DSEG7 Modern',
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'dBA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              // fontFamily: 'DSEG7 Modern',
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.red,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            color: Colors.blueAccent,
                            child: FAProgressBar(
                              backgroundColor: Colors.transparent,
                              borderRadius: 0,
                              size: wp(100),
                              animatedDuration: Duration(milliseconds: 500),
                              maxValue: 140,
                              direction: Axis.vertical,
                              verticalDirection: VerticalDirection.up,
                              currentValue: dBAValue.toInt(),
                              displayText: ' dBA',
                              changeColorValue: 90,
                              changeProgressColor: Colors.red,
                              progressColor: Colors.red,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(                           
                            child: Center(
                              child: LineChart(
                                data: decibels,
                                size: Size(wp(100), hp(20)),
                                lineWidth: 5,
                                lineColor: Colors.white,
                                pointSize: 10,
                                pointColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));

        });
  
  }

  List<Widget> getContent() => <Widget>[
        Container(
            margin: EdgeInsets.all(0),
            child: Column(children: [
              /* Container(
                child: Text(_isRecording ? "Snoring: ON" : "Snoring: OFF",
                    style: TextStyle(fontSize: 25, color: Colors.blue)),
                margin: EdgeInsets.only(top: 20),
              ),*/
              BlocBuilder<NoiserBloc, NoiserState>(
                  bloc: BlocProvider.of<NoiserBloc>(context),
                  builder: (context, state) {
                    return _buildBody(context);
                  }),
              /*Container(
                  child: StreamBuilder<NoiseReading>(
                      stream: _noiseMeter.noiseStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<NoiseReading> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return _streamSnoring(context,snapshot);
                      }))*/
            ])),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: new Text("Stop Snoring with Poney"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: getContent())), 
      ),
    );
  }
}