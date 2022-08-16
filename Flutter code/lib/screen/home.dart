import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gas_leakage/screen/login.dart';
import 'package:gas_leakage/services/auth.dart';
import 'package:gas_leakage/shared/decorations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<readings> chartData;
  late TooltipBehavior tooltipBehavior;
  late ChartSeriesController _chartSeriesController;

  String reading = "no reading";
  DateTime date = DateTime.now();

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  //Listening to stream
  @override
  void initState() {
    chartData = getChartData();
    tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x,point.y ');
    super.initState();
    _activeListner();
  }

  void _activeListner() {
    final String uid = getUid();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("UsersData/${uid}/readings/");
    Stream<DatabaseEvent> stream = ref.onChildAdded;
    stream.listen((DatabaseEvent event) {
      dynamic value = {};
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      value = event.snapshot.value;
      if (value != null) {
        setState(() {
          if (value["timestamp"] != null) {
            date = DateTime.fromMillisecondsSinceEpoch(
                int.parse(value["timestamp"].toString()) * 1000);
          }
          reading = value["temperature"].toString();
          chartData.add(readings(time: date, leakage: double.parse(reading)));
          if (chartData.length == 15) {
            chartData.removeAt(0);
          }
        });
        // chartData.add(readings(time: date, leakage: double.parse(reading)));
        // if (chartData.length == 10) {
        //   chartData.removeAt(0);
        // }
        // _chartSeriesController.updateDataSource(
        //   addedDataIndexes: <int>[chartData.length - 1],
        //   removedDataIndexes: <int>[0],
        // );
      } // DataSnapshot
    });
  }

  String getUid() {
    final User? user1 = auth.currentUser;
    final String uid;
    if (user1 != null) {
      uid = user1.uid.toString();
    } else {
      uid = "FEDJ225S8FfqZDTHntX3tMWQo7Y2";
    }
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              dynamic result = await SignOut();
              //   if (result == null) {
              //     print("logout not succesful");
              //   } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
              // }
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label:const  Text("SignOut",
            style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: boxDecoration1,
            constraints: BoxConstraints(  
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0,vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text("Gas readings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                      ),
                      ),
                    ],
                  ),
                ),
                ) ,   
              Expanded(
                flex: 14,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Colors.blue,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2)
                    )],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0), 
                        topRight: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfCartesianChart(
                      enableAxisAnimation: true,
                      tooltipBehavior: tooltipBehavior,
                      primaryYAxis: NumericAxis(
                        minimum: 60.0,
                        maximum: 700.0,
                      ),
                      primaryXAxis: DateTimeAxis(
                        title: AxisTitle(text: "Time(HH:mm:ss)"),
                        dateFormat: DateFormat.Hms(),
                        labelFormat: '{value}s',
                        intervalType: DateTimeIntervalType.seconds,
                        interval: 2.0,
                      ),
                      series: <ChartSeries<readings, DateTime>>[
                        LineSeries<readings, DateTime>(
                          onRendererCreated: (ChartSeriesController controller) {
                            _chartSeriesController = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (readings read, _) => read.time,
                          yValueMapper: (readings read, _) => read.leakage,
                          enableTooltip: true,
                          name: "readings",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

List<readings> getChartData() {
  List<readings> chartdata = [
    readings(time: DateTime(2022, 4, 12, 6, 30, 55, 10), leakage: 72.0),
    readings(time: DateTime(2022, 4, 12, 6, 30, 57, 20), leakage: 73.0),
    readings(time: DateTime(2022, 4, 12, 6, 30, 59, 30), leakage: 74.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 01, 40), leakage: 71.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 03, 50), leakage: 79.0),
    readings(time: DateTime(2022, 4, 12, 6, 31, 05, 60), leakage: 70.0),
  ];
  return chartdata;
}

class readings {
  readings({required this.time, required this.leakage});
  final DateTime time;
  final double leakage;
}
