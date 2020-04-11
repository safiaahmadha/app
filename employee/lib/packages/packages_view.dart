import 'package:flutter/material.dart';
import 'packages.dart';
import 'services.dart';

class PackagesView extends StatefulWidget {
  //
  PackagesView() : super();

  final String title = 'Packages View';

  @override
  PackagesViewState createState() => PackagesViewState();
}

class PackagesViewState extends State<PackagesView> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  Packages packagesObj;
  Packages packagesDetails;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEditId();
  }

  void dispose() {
    super.dispose();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }
  _getPackagessById(Packages packages) {
    _showProgress('View Packages...');
    Services.editPackages(packages).then((result) {
      _showProgress('View Packages');
      if (result.length > 0) {
        packagesDetails = result[0];
      }
    });
  }

  _getEditId() async {
    await packagesObj;
    if (packagesObj != null) {
      _getPackagessById(packagesObj);
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    packagesObj = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress), // we show the progress in the title...
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 110,
                    columns: [
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                            Text('Package Name'),
                          ),
                          DataCell(
                            Text(packagesObj.name),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text('Decription'),
                          ),
                          DataCell(
                            Text(packagesObj.description),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text('From Date'),
                          ),
                          DataCell(
                            Text(packagesObj.fromDate),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text('To Date'),
                          ),
                          DataCell(
                            Text(packagesObj.toDate),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
