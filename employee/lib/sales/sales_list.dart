import 'package:flutter/material.dart';
import 'sales.dart';
import 'package:employee/sales/sales_view.dart';
import 'services.dart';
import 'package:employee/sales/sales_add.dart';
import 'package:employee/widget/menu.dart';

import 'package:employee/services.dart' as globalServices;

class SalesList extends StatefulWidget {
  //
  SalesList() : super();

  final String title = 'Sales List';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<SalesList> {
  List<Sales> _saless;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _saless = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getSaless();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getSaless() {
    _showProgress('Loading Saless...');
    Services.getSaless().then((saless) {
      setState(() {
        _saless = saless;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${saless.length}");
    });
  }

  _editSales(Sales sales) {
//    Navigator.pushNamed(context,'/sales-view',arguments: sales);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesAdd(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: sales,
        ),
      ),
    );
  }

  _viewSales(Sales sales) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesView(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: sales,
        ),
      ),
    );
  }

  _deleteSales(Sales sales) {
    _showProgress('Deleting Sales...');
    Services.deleteSales(sales.id).then((result) {
      if ('success' == result) {
        _getSaless(); // Refresh after delete...
      }
    });
  }

  // Let's create a DataTable and show the sales list in it.
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
            DataColumn(label: Text('SR No')),
            DataColumn(label: Text('Action')),
            // Lets add one more column to show a delete button
          ],
          rows: _saless
              .map(
                (sales) => DataRow(cells: [
                  DataCell(Text(sales.srNo),
                      // Add tap in the row and populate the
                      // textfields with the corresponding values to update
                      onTap: () {}),
                  DataCell(Container(
                      child: Row(children: <Widget>[
                    Visibility(
                      visible: globalServices.rEdit == '1',
                      child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editSales(sales);
                          }),
                    ),
                    Visibility(
                      visible: globalServices.rView == '1',
                      child: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            _viewSales(sales);
                          }),
                    ),
                    Visibility(
                        visible: globalServices.rDelete == '1',
                        child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteSales(sales);
                            })),
                  ])))
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
                  _getSaless();
                })
          ],
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Center(child: Text('')),
              Expanded(child: _dataBody())
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (globalServices.rCreate == '1') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SalesAdd()));
              }
            },
            child: Icon(Icons.add)));
  }
}
