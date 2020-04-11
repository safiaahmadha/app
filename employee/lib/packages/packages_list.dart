import 'package:employee/widget/menu.dart';
import 'package:flutter/material.dart';
import 'packages.dart';
import 'package:employee/packages/packages_view.dart';
import 'services.dart';
import 'package:employee/packages/packages_add.dart';

import 'package:employee/services.dart' as globalServices;

class PackagesList extends StatefulWidget {
  //
  PackagesList() : super();

  final String title = 'Packages List';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<PackagesList> {
  List<Packages> _packagess;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _packagess = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getPackagess();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getPackagess() {
    _showProgress('Loading Packagess...');
    Services.getPackagess().then((packagess) {
      setState(() {
        _packagess = packagess;
      });
      _showProgress(widget.title); // Reset the title...
    });
  }

  _editPackages(Packages packages) {
//    Navigator.pushNamed(context,'/packages-view',arguments: packages);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackagesAdd(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: packages,
        ),
      ),
    );
  }

  _viewPackages(Packages packages) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackagesView(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: packages,
        ),
      ),
    );
  }
  _deletePackages(Packages packages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Are you sure you want to delete'),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Services.deletePackages(packages.id).then((result) {
                  if ('success' == result) {
                    Navigator.of(context).pop();
                    _getPackagess(); // Refresh after delete...
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



  // Let's create a DataTable and show the packages list in it.
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
          rows: _packagess
              .map(
                (packages) => DataRow(cells: [
                  DataCell(
                    Text(packages.name),
                    // Add tap in the row and populate the
                    // textfields with the corresponding values to update
                    onTap: () {},
                  ),
                  DataCell(
                    Container(
                      child: Row(children: <Widget>[
                        Visibility(
                          visible: globalServices.rEdit == '1',
                          child:new IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editPackages(packages);
                            },
                          ),
                        ),
                        Visibility(
                          visible: globalServices.rView == '1',
                          child:new IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              _viewPackages(packages);
                            },
                          ),
                        ),
                        Visibility(
                          visible: globalServices.rDelete == '1',
                          child:new IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deletePackages(packages);
                            },
                          ),
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
              _getPackagess();
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
          if(globalServices.rCreate == '1'){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PackagesAdd()));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}