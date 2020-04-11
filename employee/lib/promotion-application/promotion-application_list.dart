import 'package:employee/widget/menu.dart';
import 'package:flutter/material.dart';
import 'promotion-application.dart';
import 'package:employee/promotion-application/promotion-application_view.dart';
import 'services.dart';
import 'package:employee/promotion-application/promotion-application_add.dart';

import 'package:employee/services.dart' as globalServices;
class PromotionApplicationList extends StatefulWidget {
  //
  PromotionApplicationList() : super();

  final String title = 'PromotionApplication List';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<PromotionApplicationList> {
  List<PromotionApplication> _promotionApplications;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _promotionApplications = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getPromotionApplications();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _getPromotionApplications() {
    _showProgress('Loading PromotionApplications...');
    Services.getPromotionApplications().then((promotionApplications) {
      setState(() {
        _promotionApplications = promotionApplications;
      });
      _showProgress(widget.title); // Reset the title...
    });
  }

  _editPromotionApplication(PromotionApplication promotionApplication) {
//    Navigator.pushNamed(context,'/promotionApplication-view',arguments: promotionApplication);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromotionApplicationAdd(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: promotionApplication,
        ),
      ),
    );

  }

  _viewPromotionApplication(PromotionApplication promotionApplication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromotionApplicationView(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: promotionApplication,
        ),
      ),
    );
  }
  _deletePromotionApplication(PromotionApplication promotionApplication) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Are you sure you want to delete'),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Services.deletePromotionApplication(promotionApplication.id).then((result) {
                  if ('success' == result) {
                    Navigator.of(context).pop();
                    _getPromotionApplications(); // Refresh after delete...
                  }else{
                    Navigator.of(context).pop();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(result),
                      ),
                    );
                  }
                });
                _showProgress('Employee List');
              },
            ),
            FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }



  // Let's create a DataTable and show the promotionApplication list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 150,
          columns: [
            DataColumn(
              label: Text('List'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
            // Lets add one more column to show a delete button
          ],
          rows: _promotionApplications
              .map(
                (promotionApplication) => DataRow(cells: [
                  DataCell(
                    Text(promotionApplication.name),
                    // Add tap in the row and populate the
                    // textfields with the corresponding values to update
                    onTap: () {},
                  ),
                  DataCell(
                    Container(
                      child: Row(children: <Widget>[
                        Visibility(
                          visible: globalServices.rEdit == '1',
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editPromotionApplication(promotionApplication);
                            },
                          ),
                        ),
                        Visibility(
                          visible: globalServices.rView == '1',
                          child:IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              _viewPromotionApplication(promotionApplication);
                            },
                          ),
                        ),
                        Visibility(
                          visible: globalServices.rDelete == '1',
                          child:IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deletePromotionApplication(promotionApplication);
                            },
                          )
                        ),

                      ]),
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getPromotionApplications();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(''),
            ),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(globalServices.rCreate == '1') {
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => PromotionApplicationAdd()));
          }
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
