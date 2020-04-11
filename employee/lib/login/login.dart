import 'package:employee/login/services.dart';
import 'package:flutter/material.dart';
import 'package:employee/dashboard/dashboard.dart';

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'employee.dart';

import 'package:employee/services.dart' as token_manager;
class Login extends StatefulWidget {
  LoginUserState createState() => LoginUserState();
}

class LoginUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path =  directory.path;
    return File('$path/loginDetails.json');
  }

  Future<File> writeContent(Employee x) async {
    final file = await _localFile;
    var id = x.id;
    var userName = x.userName;
    var contactNumber = x.contactNumber;
    var address = x.address;
    var roleId = x.role;
    var roleName = x.roleName;
    var roleCreate = x.r_create;
    var roleEdit = x.r_edit;
    var roleView = x.r_view;
    var roleDelete = x.r_delete;
    var loginDetails =
        '{"id":"$id","userName":"$userName","contactNumber":"$contactNumber","address":"$address","roleId":"$roleId","role":"$roleName","rDelete":"$roleDelete","rCreate":"$roleCreate","rView":"$roleView","rEdit":"$roleEdit"}';
    token_manager.setEmpId = x.id;
    token_manager.setUserName = x.userName;
    token_manager.setEmail = x.email;
    token_manager.setRoleName = x.roleName;
    token_manager.setContactNumber = x.contactNumber;
    token_manager.setAddress = x.address;
    token_manager.setRoleId = x.role;
    token_manager.setRDelete = x.r_delete;
    token_manager.setRCreate = x.r_create;
    token_manager.setRView = x.r_view;
    token_manager.setREdit = x.r_edit;

    return file.writeAsString(loginDetails);
  }

  userLogin() {
//    getStringValuesSF();
    if (_formKey.currentState.validate()) {
      Services.login(emailController.text, passwordController.text)
          .then((result) async {
            print(result);
        if ('invalid' != result && 'error' != result) {
          // Hiding the CircularProgressIndicator.
          setState(() {
            visible = false;
          });
          await writeContent(result[0]);
          token_manager.readContent();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
              // Pass the arguments as part of the RouteSettings. The
              // DetailScreen reads the arguments from these settings.
              settings: RouteSettings(
                arguments: result[0]
              )
            )
          );
        }
        else  {
          setState(() {
            visible = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text('Invalid Email / Password'),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text('Login Form'), backgroundColor: Colors.green),
        body: SingleChildScrollView(
            child: Center(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: CircleAvatar(
                      backgroundColor: Color(0xF81F7F3),
                      child: Image(
                        image: AssetImage('images/logo.png')
                      )),
                  width: 135,
                  height: 135
                ),

//                  Divider(),

                Container(
                    width: 280,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email Here',
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.green
                        )
                      ),
                      validator: (value) {
                        return value.isEmpty ? 'Email is required' : null;
                      }
                    )),

                Container(
                    width: 280,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      autocorrect: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password Here',
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.green
                        )
                      ),
                      validator: (value) {
                        return value.isEmpty ? 'Password is required' : null;
                      }
                    )),

                RaisedButton(
                  onPressed: userLogin,
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                  child: Text('Login')
                ),

                Visibility(
                    visible: visible,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: CircularProgressIndicator()))
              ]
            )
          )
        )));
  }
}
