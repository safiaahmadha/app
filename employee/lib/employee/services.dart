import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import './employee.dart';
import 'package:employee/global-variable.dart' as global;
import 'package:employee/services.dart' as globalServices;
class Services {
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';
  static const _EDIT_EMP_ACTION = 'EDIT_EMP';

  static Future<List<Employee>> getEmployees() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(global.employeeUrl, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Employee> list = parseResponse(response.body);
        return list;
      } else {
        return List<Employee>();
      }
    } catch (e) {
      return List<Employee>(); // return an empty list on exception/error
    }
  }

  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addEmployee(
      String userName,
      String email,
      String contactNumber,
      String address,
      String roleId,
      String password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      map['userName'] = userName;
      map['email'] = email;
      map['contactNumber'] = contactNumber;
      map['address'] = address;
      map['roleId'] = roleId;
      map['password'] = password;
      final response = await http.post(global.employeeUrl, body: map);
      print('addEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static editEmployee(Employee employee) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _EDIT_EMP_ACTION;
      map['emp_id'] = employee.id;
      final response = await http.post(global.employeeUrl, body: map);
      print('getEmployeesById Response: ${response.body}');
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateEmployee(
      String empId,
      String userName,
      String email,
      String contactNumber,
      String address,
      String roleId,
      String password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['userName'] = userName;
      map['email'] = email;
      map['contactNumber'] = contactNumber;
      map['address'] = address;
      map['roleId'] = roleId;
      map['password'] = password;

      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.employeeUrl, body: map);
      print('updateEmployee Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteEmployee(String empId) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;

      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.employeeUrl, body: map);
      print('deleteEmployee Response: ${response.body}');
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
