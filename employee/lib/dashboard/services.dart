import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import './dashboard-instance.dart';

import 'package:employee/global-variable.dart' as global;
import 'package:employee/services.dart' as loginDetails;

class Services {
  static const GET_ALL = 'GET_ALL';

  static getDashboard() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = GET_ALL;
      map['emp_id'] = loginDetails.empId;
      map['emp_role'] = loginDetails.roleName;
      final response = await http.post(global.dashboardUrl, body: map);
      print('getDashboardById Response: ${response.body}');
      if (200 == response.statusCode) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<DashboardInstance>((json) => DashboardInstance.fromJson(json))
            .toList();
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  // Method to update an Dashboard in Database...
  static Future<String> attendance(String eventType,String latitude,String longitude) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'ATTENDANCE';
      map['emp_id'] = loginDetails.empId;
      map['emp_role'] = loginDetails.roleName;
      map['event_type'] = eventType;
      map['latitude'] = latitude;
      map['longitude'] = longitude;
      final response = await http.post(global.dashboardUrl, body: map);

      print('updateDashboard Response: ${response.body}');
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
  static Future<String> getAttendance() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ATTENDANCE';
      map['emp_id'] = loginDetails.empId;
      map['emp_role'] = loginDetails.roleName;

      final response = await http.post(global.dashboardUrl, body: map);

      print('updateDashboard Response: ${response.body}');
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

}
