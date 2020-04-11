import 'package:employee/role/role_add.dart';
import 'package:employee/role/role_list.dart';
import 'package:employee/role/role_view.dart';
import 'package:employee/sales/sales_add.dart';
import 'package:employee/sales/sales_list.dart';
import 'package:employee/sales/sales_view.dart';
import 'package:flutter/material.dart';
import 'package:employee/login/login.dart';
import 'package:employee/dashboard/dashboard.dart';
import 'package:employee/employee/employee_list.dart';
import 'package:employee/employee/employee_add.dart';
import 'package:employee/employee/employee_view.dart';

final routes = {
  '/login': (BuildContext context) => new Login(),
  '/dashboard': (BuildContext context) => new DashboardScreen(),
  '/employee-list': (BuildContext context) => new EmployeeList(),
  '/employee-view/:id': (params) => new EmployeeView(),
  '/employee-add': (BuildContext context) => new EmployeeAdd(),
  '/sales-list': (BuildContext context) => new SalesList(),
  '/sales-view/:id': (params) => new SalesView(),
  '/sales-add': (BuildContext context) => new SalesAdd(),
  '/sales-edit/:id': (params) => new RolesAdd(),
  '/roles-list': (BuildContext context) => new RolesList(),
  '/roles-view/:id': (params) => new RolesView(),
  '/roles-add': (BuildContext context) => new RolesAdd(),
  '/roles-edit/:id': (params) => new RolesAdd(),
  '/': (BuildContext context) => new Login(),
};
