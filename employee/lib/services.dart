//
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:employee/global-variable.dart' as global;
//import 'dart:io';
//import 'package:path_provider/path_provider.dart';
//String  employeeId;
//String roleName;
//class ServicesGB {
//  static Future<File> get _localFile async {
//    final directory = await getApplicationDocumentsDirectory();
//    final path = await directory.path;
//    return File('$path/loginDetails.json');
//  }
//
//  static Future<String> readContent() async {
//    try {
//      final file = await _localFile;
//      // Read the file
//      String contents = await file.readAsString();
//      var responseJSON = json.decode(contents);
//      employeeId = responseJSON['id'];
//      roleName = responseJSON['role'];
//      var role = responseJSON['role'];
//      return role;
//    } catch (e) {
//      // If there is an error reading, return a default String
//      return 'Error';
//    }
//  }
//
//
//}

import 'dart:io';

import 'package:path_provider/path_provider.dart';

String setEmpId;
String setUserName;
String setEmail;
String setCurrentStatus;
String setContactNumber;
String setAddress;
String setRoleId;
String setRDelete;
String setRCreate;
String setRView;
String setREdit;    // To ensure readonly
String setRoleName;    // To ensure readonly
String get empId=> setEmpId;
String get userName => setUserName;
String get email => setEmail;
String get currentStatus => setCurrentStatus;
String get contactNumber => setContactNumber;
String get address => setAddress;
String get roleId => setRoleId;
String get rDelete => setRDelete;
String get rCreate => setRCreate;
String get rView => setRView;
String get rEdit => setREdit;
String get roleName => setRoleName;
reset(){
  setEmpId = setUserName = setEmail = setCurrentStatus =setContactNumber =
  setAddress = setRCreate = setREdit =setRDelete =setRView=setRoleName
  =setRoleId='';

}
logOut(id) async{
  var map = Map<String, dynamic>();
  map['action'] = 'LOGOUT';
  print(id);
  map['emp_id'] = id;
  final response = await http.post(global.loginUrl, body: map);
  if (200 == response.statusCode) {
    reset();
    return response.body;
  } else {
    return "error";
  }
}
//String get token1 => _token ;    // To ensure readonly
//String get token2 => call() ;    // To ensure readonly
  // To ensure readonly

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
//  final path = await directory.path;
  final path = directory.path;
  return File('$path/loginDetails.json');
}

Future<String> readContent() async {
  try {
    final file = await _localFile;
    // Read the file
    String contents = await file.readAsString();
    var responseJSON = json.decode(contents);
    setEmpId = responseJSON['id'];
    setUserName  = responseJSON['userName'];
    setEmail = responseJSON['email'];
    setContactNumber = responseJSON['contactNumber'];
    setAddress = responseJSON['address'];
    setRoleId = responseJSON['roleId'];
    setRDelete = responseJSON['rDelete'];
    setRCreate = responseJSON['rCreate'];
    setRView = responseJSON['rView'];
    setREdit = responseJSON['rEdit'];    // To ensure readonly
    setRoleName = responseJSON['role'];
    var roleName = responseJSON['role'];
    return roleName;
  } catch (e) {
    // If there is an error reading, return a default String
    return 'Error';
  }
}

