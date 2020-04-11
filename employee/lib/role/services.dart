import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import './role.dart';
import 'package:employee/global-variable.dart' as global;
import 'package:employee/services.dart' as globalServices;
class Services {
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _UPDATE_ACTION = 'UPDATE';
  static const _DELETE_ACTION = 'DELETE';
  static const _EDIT_ACTION = 'EDIT';

  static Future<List<Roles>> getRoless() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(global.roleUrl, body: map);
      print('getRoless Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Roles> list = parseResponse(response.body);
        return list;
      } else {
        return List<Roles>();
      }
    } catch (e) {
      return List<Roles>(); // return an empty list on exception/error
    }
  }

  static List<Roles> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Roles>((json) => Roles.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addRoles(String name, String rCreate, String rEdit,
      String rView, String rDelete) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ADD';
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      map['name'] = name;
      map['rCreate'] = rCreate;
      map['rEdit'] = rEdit;
      map['rView'] = rView;
      map['rDelete'] = rDelete;
      final response = await http.post(global.roleUrl, body: map);
      print('addRoles Response: ${response.statusCode}');

      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static editRoles(Roles employee) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _EDIT_ACTION;
      map['emp_id'] = employee.id;
      final response = await http.post(global.roleUrl, body: map);
      print('getRolessById Response: ${response.body}');
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<Roles>((json) => Roles.fromJson(json)).toList();
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }
  // Method to update an Roles in Database...
  static Future<String> updateRoles(String rolesId, String name, String rCreate,
      String rEdit, String rView, String rDelete) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_ACTION;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      map['id'] = rolesId;
      map['name'] = name;
      map['rCreate'] = rCreate;
      map['rEdit'] = rEdit;
      map['rView'] = rView;
      map['rDelete'] = rDelete;
      final response = await http.post(global.roleUrl, body: map);
      print('updateRoles Response: ${response.body}');
      if (200 == response.statusCode) {
        if(rolesId == globalServices.roleId){
          globalServices.setRDelete = rDelete;
          globalServices.setRCreate = rCreate;
          globalServices.setRView = rView;
          globalServices.setREdit = rEdit;
        }
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Roles from Database...
  static Future<String> deleteRoles(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_ACTION;
      map['id'] = id;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.roleUrl, body: map);
      print('deleteRoles Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
