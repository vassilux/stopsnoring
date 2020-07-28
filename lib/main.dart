import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:responsive_screen/responsive_screen.dart';
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

  int _targetDecibel;

  @override
  void initState() {
    super.initState();
    this._targetDecibel = 50;
    BlocProvider.of<AudioPlayerBloc>(context).add(InitializePlayer("sounds/horse-whinnies.mp3"));
  }

  Widget _buldCommand(BuildContext context) {
    return BlocBuilder<NoiserBloc, NoiserState>(        
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
              }, 
              child: isRecording ? Icon(Icons.stop) : Icon(Icons.play_arrow));
        }); 
  }

  Widget _buildNoiserSlide(BuildContext context){
    return Column(
      children: [
        Center(
          child: Text("Target ${_targetDecibel.toInt()} dBA",
              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,                               
                                fontWeight: FontWeight.w700),),
        ),
        Slider(
          value: _targetDecibel.toDouble(),
          min: 20,
          max: 180,
          divisions: 10,
          label: '${_targetDecibel.toInt()}',
          onChangeStart: (double value) {
            
          },
          onChangeEnd: (double value) {
            
          },
          onChanged: (double newValue) {            
            setState(() {
              _targetDecibel = newValue.round();
              print('onChanged value is ' + newValue.toString());
              /**/
            });
          },
          activeColor: Colors.red,
          inactiveColor: Colors.blue,
        )
      ],
    );
  }
  

  Widget _buildBody(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return BlocBuilder<NoiserBloc, NoiserState>(       
        builder: (context, state) {
          List<double> decibels = [];
          String dBAStringValue = "0";
          double dBAValue = 0;

          if (state is NoiserDatas) {
            dBAValue = state.currentDecibel;
            decibels = state.decibels;
            dBAStringValue = dBAValue.toStringAsFixed(1).toString();
          } else if(state is NoiserStopped){
            decibels = [];
          }

          if(dBAValue > _targetDecibel.toDouble()) {
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
                    child: Center(child: _buildNoiserSlide(context)),
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
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'dBA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,                            
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
                                size: Size(wp(100), 100),
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
              BlocBuilder<NoiserBloc, NoiserState>(                 
                  builder: (context, state) {
                    return _buildBody(context);
                  }),             
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
