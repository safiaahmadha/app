import 'dart:convert';
import 'package:employee/employee/employee_list.dart';
import 'package:employee/employee/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'employee.dart';
import 'services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.

import 'package:employee/global-variable.dart' as global;

class RoleList {
  String name;
  String id;

  RoleList({this.id, this.name});

  factory RoleList.formJson(Map<String, dynamic> json) {
    return RoleList(id: json['id'], name: json['name']);
  }
}

class EmployeeAdd extends StatefulWidget {
  //
  EmployeeAdd() : super();
  final String title = 'Create Employee';

  @override
  EmployeeAddState createState() => new EmployeeAddState();
}

class EmployeeAddState extends State<EmployeeAdd> {
  bool visible = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _userNameController;
  TextEditingController _emailController;
  TextEditingController _contactNumberController;
  TextEditingController _addressController;
  TextEditingController _roleIdController;
  TextEditingController _passwordController;
  Employee employeeObj;
  Employee employeeDetails;
  String _titleProgress;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<RoleList> _roles = [];
  String _selectedUser;
  bool isInitialized;

  @override
  void initState() {
    super.initState();
    _titleProgress = 'Create Employee';
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _contactNumberController = TextEditingController();
    _addressController = TextEditingController();
    _roleIdController = TextEditingController();
    _passwordController = TextEditingController();
    getRoleList();
    _getEditId();
  }

//  roleList selectedUser;
  getRoleList() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ROLE_LIST';

      await employeeObj;

      if (employeeObj == null) {
        map['list_type'] = 'ACTIVE_LIST';
      }else{
        print(employeeObj.role);
        map['edit_id'] = employeeObj.role;
        map['list_type'] = 'ALL';
      }
      final response = await http.post(global.employeeUrl, body: map);
      print('getRoleList: ${response.body}');
      if (200 == response.statusCode) {
        var json = JsonDecoder().convert(response.body);
        _roles = (json).map<RoleList>((data) {
          return RoleList.formJson(data);
        }).toList();
        setState(() {
          _roles = (json).map<RoleList>((data) {
            return RoleList.formJson(data);
          }).toList();
          _selectedUser = _roles[0].id;
          _roleIdController.text = _roles[0].id;
        });
        _roleIdController.text = _roles[0].id;
        _selectedUser = _roles[0].id;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

// Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _clearValues() {
    _userNameController.text = '';
    _emailController.text = '';
    _contactNumberController.text = '';
    _addressController.text = '';
    _userNameController.text = '';
    _emailController.text = '';
    _roleIdController.text = '';
    _passwordController.text = '';
  }

  _updateEmployee(Employee employee) {
    if (_formKey.currentState.validate()) {
      _showProgress('Updating Employee...');
      Services.updateEmployee(
              employee.id,
              _userNameController.text,
              _emailController.text,
              _contactNumberController.text,
              _addressController.text,
              _roleIdController.text,
              _passwordController.text)
          .then((result) {
        if ('Success' == result) {
          _clearValues();
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new EmployeeList()));
        }else{
          _showSnackBar(context, result);
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _showValues(Employee employee) {
    employeeDetails = employee;
    _userNameController.text = employee.userName;
    _emailController.text = employee.email;
    _contactNumberController.text = employee.contactNumber;
    _addressController.text = employee.address;
    _roleIdController.text = employee.role;
    setState(() {
      _selectedUser = employee.role;
    });
    _passwordController.text = employee.password;
  }

  _getEmployeesById(Employee employee) {
    Services.editEmployee(employee).then((result) {
      _showProgress('Edit Employee');
      if (result.length > 0) {
        _clearValues();
        _showValues(result[0]);
      }
    });
  }

// Now lets add an Employee
  _addEmployee() {
    if (_roleIdController.text.isEmpty) {
      _showSnackBar(context, 'role is required');
    }
    if (_formKey.currentState.validate()) {
      _showProgress('Adding Employee...');
      Services.addEmployee(
              _userNameController.text,
              _emailController.text,
              _contactNumberController.text,
              _addressController.text,
              _roleIdController.text,
              _passwordController.text
      ).then((result) {
        if ('Success' == result) {
          _showSnackBar(context, 'Employee added Successfully');
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new EmployeeList()));
//          Navigator.pop(context,
//              MaterialPageRoute(builder: (context) => new EmployeeList()));
          _clearValues();
        }else{
          _showSnackBar(context, result);
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _getEditId() async {
    await employeeObj;
    if (employeeObj != null) {
      _getEmployeesById(employeeObj);
    }

  }

  var selectedState;

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
                _clearValues();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _userNameController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.userCircle,
                          color: Color(0xff11b719)),
                      hintText: 'Enter Your Name Here',
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'Required' : null;
                    },
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.envelope,
                          color: Color(0xff11b719)),
                      hintText: 'Enter Your Email Here',
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'Required' : null;
                    },
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      controller: _passwordController,
                      autocorrect: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.key,
                            color: Color(0xff11b719)),
                        hintText: 'Enter Your Password Here',
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        return value.isEmpty ? 'Required' : null;
                      },
                      keyboardType: TextInputType.visiblePassword)),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                      controller: _contactNumberController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.phone,
                            color: Color(0xff11b719)),
                        hintText: 'Enter Your Contact Number Here',
                        labelText: 'Contact Number',
                      ),
                      validator: (value) {
                        return value.isEmpty ? 'Required' : null;
                      },
                      keyboardType: TextInputType.number)),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _addressController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.addressBook,
                          color: Color(0xff11b719)),
                      hintText: 'Enter Your Address Here',
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'Required' : null;
                    },
                  )),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.moneyBill,
                      color: Color(0xff11b719),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                        width: 340.0,
                        padding: EdgeInsets.all(10.0),
                        child: DropdownButton<String>(
                          value: _selectedUser,
                          onChanged: (String newValue) {
                            setState(() {
                              print(newValue);
                              _selectedUser = newValue;
                              _roleIdController.text = newValue;
                            });
                          },
                          isExpanded: true,
                          hint: Text('Select'),
                          items: _roles.map((RoleList data) {
                            return DropdownMenuItem<String>(
                                value: data.id, child: Text(data.name));
                          }).toList(),
                        )),
                  ]),
              employeeObj == null
                  ? RaisedButton(
                      onPressed: () {
                        _addEmployee();
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text('Submit'),
                    )
                  : RaisedButton(
                      onPressed: () {
                        _updateEmployee(employeeObj);
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text('Submit'),
                    ),
              Visibility(
                  visible: visible,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator())),
            ],
          ),
        )));
  }
}
