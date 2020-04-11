import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import './image-upload.dart';

import 'package:employee/global-variable.dart' as global;

import 'package:employee/services.dart' as globalServices;
class Services {
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _UPDATE_ACTION = 'UPDATE';
  static const _DELETE_ACTION = 'DELETE';
  static const _EDIT_ACTION = 'EDIT';

  static Future<List<ImageUpload>> getImageUploads() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['emp_id'] = globalServices.empId;
      map['emp_role'] = globalServices.roleName;
      final response = await http.post(global.salesUrl, body: map);
      print('getImageUploads Response: ${response.body}');
      if (200 == response.statusCode) {
        List<ImageUpload> list = parseResponse(response.body);
        return list;
      } else {
        return List<ImageUpload>();
      }
    } catch (e) {
      return List<ImageUpload>(); // return an empty list on exception/error
    }
  }

  static List<ImageUpload> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ImageUpload>((json) => ImageUpload.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addImageUpload(String srNo,
  String documentUpload,base64Image) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ADD';


      if(base64Image == null){
        map['documentUpload'] = '';
        map['base64Image'] = '';
      }else{
        map['documentUpload'] = documentUpload;
        map['base64Image'] = base64Image;
      }
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.salesUrl, body: map);

      print('addImageUpload Response: ${response.body}');
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
  static editImageUpload(ImageUpload employee) async{
     try{
       var map = Map<String, dynamic>();
      map['action'] = _EDIT_ACTION;
      map['emp_id'] = employee.id;
      final response = await http.post(global.salesUrl, body: map);
      print('getImageUploadsById Response: ${response.body}');
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<ImageUpload>((json) => ImageUpload.fromJson(json)).toList();
      } else {
        return 'error';
      }
     }catch(e){
       return 'error';
     }
  }
  // Method to Delete an ImageUpload from Database...
//  static FutureOr<ImageUpload> editImageUpload( ImageUpload employee) async {
//
//    try {
//      var map = Map<String, dynamic>();
//      map['action'] = _EDIT_SALES_ACTION;
//      map['emp_id'] = employee.id;
//      final response = await http.post(global.imageUploadUrl, body: map);
//      print('getImageUploadsById Response: ${response.body}');
//      if (200 == response.statusCode) {
//        print('getImageUploadsById Response: ${response.body}');
//        List<ImageUpload> x = jsonDecode(response.body);
//        return x;
//      } else {
//      }
//    } catch (e) {
//    }
//
//  }

  // Method to update an ImageUpload in Database...
  static Future<String> updateImageUpload(
      String imageUploadId,String sr,String documentUpload,base64Image) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_ACTION;
      map['id'] = imageUploadId;

      map['base64Image'] = base64Image.toString();
     print(map);
      final response = await http.post(global.salesUrl, body: map);
      print('updateImageUpload Response: ${response.body}');
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

  // Method to Delete an ImageUpload from Database...
  static Future<String> deleteImageUpload(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_ACTION;
      map['id'] = id;
      map['login_user_id'] = globalServices.empId;
      map['login_user_role_name'] = globalServices.roleName;
      map['login_user_role_id'] = globalServices.roleId;
      final response = await http.post(global.salesUrl, body: map);
      print('deleteImageUpload Response: ${response.body}');
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