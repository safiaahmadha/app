import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import './sales.dart';

import 'package:employee/global-variable.dart' as global;

import 'package:employee/services.dart' as globalServices;
class Services {
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _UPDATE_ACTION = 'UPDATE';
  static const _DELETE_ACTION = 'DELETE';
  static const _EDIT_ACTION = 'EDIT';

  static Future<List<Sales>> getSaless() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['emp_id'] = globalServices.empId;
      map['emp_role'] = globalServices.roleName;
      final response = await http.post(global.salesUrl, body: map);
      print('getSaless Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Sales> list = parseResponse(response.body);
        return list;
      } else {
        return List<Sales>();
      }
    } catch (e) {
      return List<Sales>(); // return an empty list on exception/error
    }
  }

  static List<Sales> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Sales>((json) => Sales.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addSales(String srNo,String customerName,String customerNo,String customerAddress1,
  String customerAddress2, String city, String packageDetailsId, String promtionApplicationDetails,
  String documentUpload,String openDate,String closedDate,String saleStatus,String remarks,String verifiedBy,
      String verifiedDate,String employeeId,base64Image) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ADD';
      map['sr_no'] = srNo;
      map['employee_id'] = employeeId;
      map['customerName'] = customerName;
      map['customerNo'] = customerNo ;
      map['customerAddress1'] = customerAddress1;
      map['customerAddress2'] = customerAddress2;
      map['city'] = city;
      map['packageDetails_id'] = packageDetailsId;
      map['promtionApplicationDetails'] = promtionApplicationDetails;
      map['openDate'] = openDate;
      map['saleStatus'] = saleStatus;


      if(base64Image == null){
        map['documentUpload'] = '';
        map['base64Image'] = '';
      }else{
        map['documentUpload'] = documentUpload;
        map['base64Image'] = base64Image;
      }
      if(globalServices.roleName.toUpperCase() == 'ADMIN' || globalServices.roleName.toUpperCase() == 'BACKOFFICE'){
        map['closeDate'] = closedDate;
        map['verifiedDate'] = verifiedDate;
        map['verifiedBy'] = employeeId;
        map['remarks'] = remarks;
      }else{
        map['closeDate'] = '';
        map['verifiedDate'] = '';
        map['verifiedBy'] = 'NULL';
        map['remarks'] = '';
      }
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.salesUrl, body: map);

      print('addSales Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }
  static editSales(Sales employee) async{
     try{
       var map = Map<String, dynamic>();
      map['action'] = _EDIT_ACTION;
      map['emp_id'] = employee.id;
      final response = await http.post(global.salesUrl, body: map);
      print('getSalessById Response: ${response.body}');
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<Sales>((json) => Sales.fromJson(json)).toList();
      } else {
        return 'error';
      }
     }catch(e){
       return 'error';
     }
  }
  // Method to Delete an Sales from Database...
//  static FutureOr<Sales> editSales( Sales employee) async {
//
//    try {
//      var map = Map<String, dynamic>();
//      map['action'] = _EDIT_SALES_ACTION;
//      map['emp_id'] = employee.id;
//      final response = await http.post(global.salesUrl, body: map);
//      print('getSalessById Response: ${response.body}');
//      if (200 == response.statusCode) {
//        print('getSalessById Response: ${response.body}');
//        List<Sales> x = jsonDecode(response.body);
//        return x;
//      } else {
//      }
//    } catch (e) {
//    }
//
//  }

  // Method to update an Sales in Database...
  static Future<String> updateSales(
      String salesId,String srNo,String customerName,String customerNo,String customerAddress1,
      String customerAddress2, String city, String packageDetailsId, String promtionApplicationDetails,
      String documentUpload,String openDate,String closedDate,String saleStatus,String remarks,String verifiedBy,
      String verifiedDate,String employeeId,base64Image) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_ACTION;
      map['id'] = salesId;
      map['sr_no'] = srNo;
      map['employee_id'] = employeeId;
      map['customerName'] = customerName;
      map['customerNo'] = customerNo ;
      map['customerAddress1'] = customerAddress1;
      map['customerAddress2'] = customerAddress2;
      map['city'] = city;
      map['packageDetails_id'] = packageDetailsId;
      map['promtionApplicationDetails'] = promtionApplicationDetails;
      map['documentUpload'] = documentUpload;
      map['openDate'] = openDate;
      map['saleStatus'] = saleStatus;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      if(globalServices.roleName.toUpperCase() == 'ADMIN' || globalServices.roleName.toUpperCase() == 'BACKOFFICE'){
        map['remarks'] = remarks;
        map['emp_role'] = globalServices.roleName;
        map['closeDate'] = closedDate;
        map['verifiedDate'] = verifiedDate;
        map['verifiedBy'] = employeeId;
      }
      map['base64Image'] = base64Image.toString();
     print(map);
      final response = await http.post(global.salesUrl, body: map);
      print('updateSales Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  // Method to Delete an Sales from Database...
  static Future<String> deleteSales(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_ACTION;
      map['id'] = id;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.salesUrl, body: map);
      print('deleteSales Response: ${response.body}');
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