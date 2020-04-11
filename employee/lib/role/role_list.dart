import 'package:employee/widget/menu.dart';
import 'package:flutter/material.dart';
import 'role.dart';
import 'package:employee/role/role_view.dart';
import 'services.dart';
import 'package:employee/role/role_add.dart';
import 'package:employee/services.dart' as globalServices;
class RolesList extends StatefulWidget {
  //
  RolesList() : super();

  final String title = 'Roles List';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<RolesList> {
  List<Roles> _roless;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _roless = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getRoless();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getRoless() {
    _showProgress('Loading Roless...');
    Services.getRoless().then((roless) {
      setState(() {
        _roless = roless;
      });
      _showProgress(widget.title); // Reset the title...
    });
  }

  _editRoles(Roles roles) {
//    Navigator.pushNamed(context,'/roles-view',arguments: roles);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>new RolesAdd(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: roles,
        ),
      ),
    );

  }

  _viewRoles(Roles roles) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RolesView(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: roles,
        ),
      ),
    );
  }
  _deleteRoles(Roles roles) {
   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Are you sure you want to delete'),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Services.deleteRoles(roles.id).then((result) {
                  if ('success' == result) {
                    Navigator.of(context).pop();
                    _getRoless(); // Refresh after delete...
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


  // Let's create a DataTable and show the roles list in it.
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
              label: Text('SR No'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
            // Lets add one more column to show a delete button
          ],
          rows: _roless
              .map(
                (roles) => DataRow(cells: [
                  DataCell(
                    Text(roles.name),
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
                              _editRoles(roles);
                            },
                          ),
                        ),
                        Visibility(
                          visible: globalServices.rView == '1',
                          child:new IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              _viewRoles(roles);
                            },
                          ),
                        ),
                        Visibility(
                            visible: globalServices.rDelete == '1',
                            child:IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteRoles(roles);
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
              _getRoless();
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
                context, MaterialPageRoute(builder: (context) =>new RolesAdd()));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
