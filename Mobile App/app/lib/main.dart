import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

bool mode=false; 
int replayData=0;
late Timer timer;
int pointColor = 0xFFF;
int data = 1;   //for data to be saved in 
List<int>previousPoits=[]; // to save previous points
void main() {
  runApp(const MyApp());
}

Future<int> getData() async { // return json obj
    var res = await http.get(Uri.parse("***********":80/Readings'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    
    var jasonObj = json.decode(res.body);
    return jasonObj['label'];
  }

  void updateData() async{
    data = await getData();
  }


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState()=> _MyAppState();
}
  @override
  void initState() async {
  data = await getData();
  initState();
}
  // This widget is the root of your application.
  class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      Scaffold(
      appBar: AppBar(
        title: Text("Localization"),
      ),
      body: 
      Stack(children: [
        Center(
          child: Image.asset('lib/img/floor.jpeg'),
        ),
        Center(
            child: Container(
              width: 400,
              height: 640,
                child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return CustomPaint(
                        painter: MyPainter(),
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                     );
                },
            )
            )
        ),
      ]),
          
   
       floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                child: Icon(Icons.stars_outlined),
                label: 'Start',
                onTap: (){
                  mode= false;
                  
                    // int data1=await predict(); 
                    timer=Timer.periodic(Duration(seconds: 2),(timer) { 
                     setState(() {
                       updateData();
                      pointColor = 0xFF0F07FF;
                      // print("data");
                      // print(data);
                      // print(previousPoits.length);
                      if (previousPoits.length==0)
                      {
                       
                          previousPoits.add(data);
                      }
                      else{
                    
                      if(data!=previousPoits[previousPoits.length-1])
                      {
                      previousPoits.add(data);
                      
                      }
                      }
                      ///////////////////////////
                      print(previousPoits);
                      });
                    });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.replay),
                label: 'Replay',
                onTap: () async {
                  mode = true;
                  timer.cancel();
                 
                  if (previousPoits.length >= 3) {
                    // int i = previousPoits.length-4;
                    if(mode){
                    for (int i = previousPoits.length-1;i > 0;i--) {
                      print("i=");
                      await Future.delayed(const Duration(seconds: 2), () {
                        print(i);
                        setState(() {
                          pointColor = 0xFFE6FF07;
                          data = previousPoits[i];
                          print("data = " + data.toString());
                        });
                      });
                      // i++;
                    }
                    }
                  }
                },
              )
            ],
          ),
        ));
  }
}


replay(List<int> data){
  for(int i=(data.length-1);i>=0;i--)
  { 
  
    print("replay");
    print(previousPoits[i]);
 
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    
    Paint circlePaint = Paint()..color = Color.fromRGBO(216, 28, 159, 1);
    switch (data) {
      case 1: // lab electronics 
        {
          canvas.drawCircle(Offset(150, 400), 5, circlePaint);
          break;
        }

      case 3: // hallway labs
        {
          canvas.drawCircle(Offset(210, 450), 5, circlePaint);
          break;
        }

      case 4: //stairs toilet
        {
          canvas.drawCircle(Offset(210, 230), 5, circlePaint);
          break;
        }


      case 2: // rehab
        {
          canvas.drawCircle(Offset(150, 525), 5, circlePaint);
          break;
        }

      case 6: //TA
        {
          canvas.drawCircle(Offset(210, 40), 5, circlePaint);
          break;
        }
      case 7: //corridor 3201
        {
          canvas.drawCircle(Offset(210, 130), 5, circlePaint);
          break;
        }

      default:
        {
          break;
        }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}


