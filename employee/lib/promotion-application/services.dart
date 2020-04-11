import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import './promotion-application.dart';
import 'package:employee/global-variable.dart' as global;
import 'package:employee/services.dart' as globalServices;

class Services {
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _UPDATE_ACTION = 'UPDATE';
  static const _DELETE_ACTION = 'DELETE';
  static const _EDIT_ACTION = 'EDIT';

  static Future<List<PromotionApplication>> getPromotionApplications() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(global.promotionApplicationUrl, body: map);
      print('getPromotionApplications Response: ${response.body}');
      if (200 == response.statusCode) {
        List<PromotionApplication> list = parseResponse(response.body);
        return list;
      } else {
        return List<PromotionApplication>();
      }
    } catch (e) {
      return List<PromotionApplication>(); // return an empty list on exception/error
    }
  }

  static List<PromotionApplication> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PromotionApplication>((json) => PromotionApplication.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addPromotionApplication(String employId,String name,String description,String fromDate,String toDate) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ADD';
      map['empId'] = employId;
      map['name'] = name;
      map['description'] = description;
      map['fromDate'] = fromDate;
      map['toDate'] = toDate;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.promotionApplicationUrl, body: map);
      print('addPromotionApplication Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static editPromotionApplication(PromotionApplication employee) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _EDIT_ACTION;
      map['emp_id'] = employee.id;
      final response = await http.post(global.promotionApplicationUrl, body: map);
      print('getPromotionApplicationsById Response: ${response.body}');
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<PromotionApplication>((json) => PromotionApplication.fromJson(json)).toList();
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  // Method to update an PromotionApplication in Database...
  static Future<String> updatePromotionApplication(String promotionApplicationId, String employId,String name,String description,String fromDate,String toDate) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_ACTION;
      map['id'] = promotionApplicationId;
      map['empId'] = employId;
      map['name'] = name;
      map['description'] = description;
      map['fromDate'] = fromDate;
      map['toDate'] = toDate;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.promotionApplicationUrl, body: map);
      print('updatePromotionApplication Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an PromotionApplication from Database...
  static Future<String> deletePromotionApplication(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_ACTION;
      map['id'] = id;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.promotionApplicationUrl, body: map);
      print('deletePromotionApplication Response: ${response.body}');
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
