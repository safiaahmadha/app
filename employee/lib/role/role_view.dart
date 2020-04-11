import 'package:flutter/material.dart';
import 'role.dart';
import 'services.dart';

class RolesView extends StatefulWidget {
  //
  RolesView() : super();

  final String title = 'Roles View';

  @override
  RolesViewState createState() => RolesViewState();
}

class RolesViewState extends State<RolesView> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  Roles rolesObj;
  Roles rolesDetails;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getRolessById();
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

  _getRolessById() async {
    await rolesObj ;
    _showProgress('View Roles...');
    Services.editRoles(rolesObj).then((result) {
      _showProgress('View Roles');
      if (result.length > 0) {
        rolesDetails = result[0];
      }
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    rolesObj = ModalRoute.of(context).settings.arguments;

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
                    columnSpacing: 250,
                    columns: [
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          Text('Name'),
                        ),
                        DataCell(
                          Text(rolesObj.name),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Creaet'),
                        ),
                        DataCell(
                          Text(rolesObj.rCreate == '1' ? 'yes' : 'No'),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Edit'),
                        ),
                        DataCell(
                          Text(rolesObj.rEdit == '1' ? 'yes' : 'No'),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('View'),
                        ),
                        DataCell(
                          Text(rolesObj.rView == '1' ? 'yes' : 'No'),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Delete'),
                        ),
                        DataCell(
                          Text(rolesObj.rDelete == '1' ? 'yes' : 'No'),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
