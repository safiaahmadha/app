import 'package:flutter/material.dart';
import 'employee.dart';
import 'services.dart';

class EmployeeView extends StatefulWidget {
  //
  EmployeeView() : super();

  final String title = 'Employee View';

  @override
  EmployeeViewState createState() => EmployeeViewState();
}

class EmployeeViewState extends State<EmployeeView> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  Employee employeeObj;
  Employee employeeDetails;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEditId();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _getEmployeesById(Employee employee) {

    _showProgress('View Employee...');
    Services.editEmployee(employee).then((result) {

      _showProgress('View Employee');
      if (result.length > 0) {
        employeeDetails = result[0];
      }
    });
  }

  _getEditId() async {
     await employeeObj;
    if (employeeObj != null) {
      _getEmployeesById(employeeObj);
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    employeeObj = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress), // we show the progress in the title...
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
//                _getEmployees();
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('Property'),
                      ),
                      DataColumn(
                        label: Text('Value of the employee'),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          Text('User Name'),
                        ),
                        DataCell(
                          Text(employeeObj.userName),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Email'),
                        ),
                        DataCell(
                          Text(employeeObj.email),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Contact Number'),
                        ),
                        DataCell(
                          Text(employeeObj.contactNumber),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Address'),
                        ),
                        DataCell(
                          Text(employeeObj.address),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('Role'),
                        ),
                        DataCell(
                          Text(employeeDetails != null
                              ? employeeDetails.roleName
                              : employeeObj.role),
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
