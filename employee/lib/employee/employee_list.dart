import 'package:flutter/material.dart';
import 'employee.dart';
import 'package:employee/employee/employee_view.dart';
import 'services.dart';
import 'package:employee/employee/employee_add.dart';

import 'package:employee/widget/menu.dart';
import 'package:employee/services.dart' as globalServices;

class EmployeeList extends StatefulWidget {
  //
  EmployeeList() : super();

  final String title = 'Employee List';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<EmployeeList> {
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEmployees();
  }

  @override
  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }
  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  _editEmployee(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeAdd(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: employee,
        ),
      ),
    );

  }

  _viewEmployee(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeView(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: employee,
        ),
      ),
    );
  }
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  showError(result){
    _showSnackBar(context,result);
  }
  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Are you sure you want to delete'),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Services.deleteEmployee(employee.id).then((result) {
                  if ('success' == result) {
                    Navigator.of(context).pop();
                    _getEmployees(); // Refresh after delete...
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

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('User Name(Employee ID)'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
            // Lets add one more column to show a delete button
          ],
          rows: _employees
              .map(
                (employee) => DataRow(cells: [
                  DataCell(
                    Text(employee.userName + '(' + employee.id + ')'),
                    // Add tap in the row and populate the
                    onTap: () {},
                  ),
                  DataCell(
                    Container(
                      child: Row(children: <Widget>[
                        Visibility(
                            visible: globalServices.rEdit == '1',
                            child:IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editEmployee(employee);
                              },
                            ),
                        ),
                        Visibility(
                            visible: globalServices.rView == '1',
                            child:IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {
                                _viewEmployee(employee);
                              },
                            ),
                        ),
                        Visibility(
                            visible: globalServices.rDelete == '1',
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteEmployee(employee);
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
              _getEmployees();
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new EmployeeAdd()));
          }
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
