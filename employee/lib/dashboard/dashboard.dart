import 'package:employee/dashboard/dashboard-instance.dart';
import 'package:employee/dashboard/services.dart';
import 'package:flutter/material.dart';
import 'package:employee/widget/menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DashboardState(),
    );
  }

}

class DashboardState extends StatefulWidget {
//  UpdateTextState createState() => UpdateTextState();
  @override
  UpdateTextState createState() {
    return new UpdateTextState();
  }
}


class UpdateTextState extends State  {


  dynamic fSTextSm  = 14.0 ;
  dynamic fSIconSm  = 14.0 ;
  dynamic fSNumberSm  = 14.0 ;
  dynamic fSTextMd  = 25.0 ;
  dynamic fSIconMd  = 20.0 ;
  dynamic fSNumberMd  = 20.0;
  dynamic fSTextLg  = 40.0 ;
  dynamic fSIconLg  = 40.0 ;
  dynamic fSNumberLg  = 40.0;
  dynamic colorWhite = Colors.white;
  dynamic colorGreen = Colors.green;
  dynamic bgBox = Colors.green;
  dynamic bgBox1 = const Color.fromRGBO(255, 255, 255, 1);
  dynamic bgBox2 = const Color.fromRGBO(152, 83, 255, 1);
  dynamic bgBox3 = const Color.fromRGBO(255, 148, 0, 1);
  dynamic bgBox4 = const Color.fromRGBO(254, 86, 86, 1);
  DateTime  _currentTime;
  Position _currentPosition;
  String totalSales = '0';
  String completed = '0';
  String inProgress = '0';
  String canceledSales = '0';
  String closed = '0';

  String lat;
  String long;
  String eventType = 'Checkin';
  String eventLabel= 'Checkout';
  DashboardInstance dashboardDetails;
  void initState() {
    super.initState();
    _getDashboardDetails();
  }
  _getDashboardDetails() {
    Services.getDashboard()
        .then((result) {
      if (result.length > 0) {
        dashboardDetails = result[0];
        setState(() {
          totalSales = dashboardDetails.totalSales;
          completed = dashboardDetails.completed;
          inProgress = dashboardDetails.inProgress;
          canceledSales = dashboardDetails.canceled;
          closed = dashboardDetails.closed;
          if(eventType == null){
            eventLabel = 'checkOut';
            eventType = 'checkIn';
          }else{
            eventLabel = dashboardDetails.eventType == 'CheckIn' ? 'CheckIn':'CheckOut';
            eventType = dashboardDetails.eventType  == 'CheckIn' ? 'CheckOut':'CheckIn';
          }
          if(dashboardDetails.dateTime != null){
            _currentTime = DateTime.parse(dashboardDetails.dateTime);
          }else{
            _currentTime = null;
          }
//
          lat = dashboardDetails.lat;
          long = dashboardDetails.long;
        });

      }
    });
  }
   _getCurrentLocation()  {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

     geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat = position.latitude.toString();
        long = position.longitude.toString();

      });
          setAttendance();
    }).catchError((e) {
      print(e);
    });
  }

  setAttendance() async{

     lat = _currentPosition.latitude.toString();
     long = _currentPosition.longitude.toString();
    _currentTime = new DateTime.now();

    Services.attendance(eventType,lat,long).then((result){
     _getDashboardDetails();

      return;
    }).catchError((onError){
      print(onError);
      return;
    });

  setState(() {
    eventType = eventType;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
        backgroundColor:Colors.white,
      body:SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget>[
             SizedBox(
               height: 20,
             ),
                Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0,0,0,0.2),
                                      blurRadius: 25.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        1.0, // Move to right 10  horizontally
                                        1.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                  color: bgBox1,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0)
                                  )
                              ),
                              padding: EdgeInsets.all(30.0),
                              margin: EdgeInsets.all(10.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:<Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0),

                                      child: Text('Total Sales',  style: new TextStyle(
                                        fontSize: fSTextMd,
                                        color: colorGreen,
                                      ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children:<Widget>[
                                          Expanded(
                                            child:Text(
                                              '$totalSales',
                                              style: new TextStyle(
                                                fontSize: fSNumberLg,
                                                color: colorGreen,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child:
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(
                                                    FontAwesomeIcons.chartArea,
                                                    color: colorGreen,
                                                    size: fSIconLg,
                                                  ),

                                              )

                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ]
                  ),
                ),

              Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[

                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: bgBox,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0)
                                  )
                              ),
                              padding: EdgeInsets.all(20.0),
                              margin: EdgeInsets.all(10.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:<Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0),

                                      child: Text('Completed',  style: new TextStyle(
                                        fontSize: fSTextMd,
                                        color: colorWhite,
                                      ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children:<Widget>[
                                          Expanded(
                                            child:Text(
                                              completed,
                                              style: new TextStyle(
                                                fontSize: fSNumberLg,
                                                color: colorWhite,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child:Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  FontAwesomeIcons.solidCheckCircle,
                                                  color: colorWhite,
                                                  size: fSIconLg,
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: bgBox,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0)
                                  )
                              ),
                              padding: EdgeInsets.all(20.0),
                              margin: EdgeInsets.all(10.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:<Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0),

                                      child: Text('Inprogress ',  style: new TextStyle(
                                        fontSize: fSTextMd,
                                        color: colorWhite,
                                      ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children:<Widget>[
                                          Expanded(
                                            child:Text(
                                              inProgress,
                                              style: new TextStyle(
                                                fontSize: fSNumberLg,
                                                color: colorWhite,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child:Icon(
                                                FontAwesomeIcons.ticketAlt,
                                                color: colorWhite,
                                                size: fSIconLg,
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ]
                  ),
              ),
                Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[

                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: bgBox,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0)
                                  )
                              ),
                              padding: EdgeInsets.all(20.0),
                              margin: EdgeInsets.all(10.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:<Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0),

                                      child: Text('Canceled',  style: new TextStyle(
                                        fontSize: fSTextMd,
                                        color: colorWhite,
                                      ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children:<Widget>[
                                          Expanded(
                                            child:Text(
                                              canceledSales,
                                              style: new TextStyle(
                                                fontSize: fSNumberLg,
                                                color: colorWhite,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child:Align(
                                                alignment: Alignment.topRight,
                                                child: Icon(
                                                  FontAwesomeIcons.exclamationTriangle ,
                                                  color: colorWhite,
                                                  size: fSIconLg,
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: bgBox,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0)
                                  )
                              ),
                              padding: EdgeInsets.all(20.0),
                              margin: EdgeInsets.all(10.0),
                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:<Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10.0),

                                      child: Text('Closed ',  style: new TextStyle(
                                        fontSize: fSTextMd,
                                        color: colorWhite,
                                      ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children:<Widget>[
                                          Expanded(
                                            child:Text(
                                             closed,
                                              style: new TextStyle(
                                                fontSize: fSNumberLg,
                                                color: colorWhite,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child:Icon(
                                                Icons.cancel,
                                                color: colorWhite,
                                                size: fSIconLg,
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child:  RaisedButton(
                    onPressed: (){
                      _getCurrentLocation();
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    child: Text(
                      '$eventType',
                      style: new TextStyle(
                        fontSize: fSNumberMd,
                        color: colorWhite
                      )
                    )
                  )
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.map, size: 72.0,color: Colors.green,),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Location:', style: const TextStyle(
//                                    fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                )
                                ),
                                Text(
                                  '$lat , $long'
                                  , style: const TextStyle(
//                                    fontWeight: FontWeight.bold,
                                  fontSize: 14.0
                                )
                                ),
                                Text('$eventLabel', style: const TextStyle(
//                                    fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                )
                                ),
                                Text(
                                  '$_currentTime',
                                  style: const TextStyle(
//                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0
                                  )
                                )
                              ]
                            )
                          )

                        ]
                      )
                    ]
                  )
                )
            ]
          )

      )

//        child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Flexible(
//                    flex: 2,
//                    child: Container(color: Colors.cyan,),
//                  ),
//                  Flexible(
//                    flex: 3,
//                    child: Container(color: Colors.teal,),
//                  ),
//                  Flexible(
//                    flex: 1,
//                    child: Container(color: Colors.indigo,),
//                  ),
//                ],
//              ),
//              Expanded(
//                flex: 3, // takes 30% of available width
//                child: Container(color: Colors.red),
//              ),
//
//
////              Column(
////                children: [
////                  Icon(Icons.kitchen, color: Colors.green[500]),
////                  Text('PREP:'),
////                  Text('25 min'),
////                ],
////              ),
//            ]
//        )
//      )
    );
  }


}
