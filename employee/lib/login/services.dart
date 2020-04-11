import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import './employee.dart';
import 'package:employee/global-variable.dart' as global;

class Services {
  static List<Employee> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
  }

  static login(String email, String password) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'LOGIN';
      map['email'] = email;
      map['password'] = password;
      final response = await http.post(global.loginUrl, body: map);
      print('Login Response: ${response.body}');
      if (200 == response.statusCode) {
        print(response.body);
        if ("invalid" == response.body) {
          return response.body;
        } else {
          final parsed =
              json.decode(response.body).cast<Map<String, dynamic>>();
          return parsed
              .map<Employee>((json) => Employee.fromJson(json))
              .toList();
        }
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
    }
  }
}
