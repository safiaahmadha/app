
import 'dart:async';
import 'package:employee/image-upload/image_upload_list.dart';
import 'package:employee/promotion-application/promotion-application_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:employee/packages/packages_list.dart';
import 'package:employee/role/role_list.dart';
import 'package:employee/sales/sales_list.dart';
import 'package:flutter/material.dart';
import 'package:employee/login/login.dart';
import 'package:employee/dashboard/dashboard.dart';
import 'package:employee/employee/employee_list.dart';

import 'package:employee/services.dart' as loginServices;

class NavDrawer extends StatelessWidget {

  Future<String> readContent() async {
    return loginServices.roleName;
  }

  @override
  Widget build(context) {
    return FutureBuilder<String>(
        future: readContent(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Drawer(
              child: new ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
//                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Text(
                        'The Thought Factory',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('images/images.jpg'))
                    ),
                  ),

                  new ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()),
                      ),
                    },
                  ),
                  new Visibility(
                    visible: snapshot.data.toUpperCase() == 'ADMIN',
                    child: new ListTile(
                        leading: Icon(Icons.border_color),
                        title: Text('Role'),
                        onTap: () => {
                              Navigator.pop(context),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RolesList()),
                              ),
                            }),
                  ),
                  new Visibility(
                    visible: snapshot.data.toUpperCase() == 'ADMIN',
                    child: new ListTile(
                      leading: Icon(Icons.supervised_user_circle),
                      title: Text('Employee'),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeList()),
                        ),
                      },
                    ),
                  ),
//          icons input,verified_user,settings
                  new Visibility(
                    visible: snapshot.data.toUpperCase() == 'ADMIN',
                    child: new ListTile(
                      leading: Icon(Icons.verified_user),
                      title: Text('Packages'),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PackagesList()),
                        ),
                      },
                    ),
                  ),

                  new Visibility(
                    visible: snapshot.data.toUpperCase() == 'ADMIN',
                    child: new ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Promotion Application'),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PromotionApplicationList()),
                        ),
                      },
                    ),
                  ),

                  new ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: Text('Sales'),
                    onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SalesList()),
                      ),
                    },
                  ),

                  new ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: Text('Image Upload'),
                    onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>new FilePickerDemo()),
                      ),
                    },
                  ),
                  new ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                    onTap: () async => {

                      await loginServices.logOut(loginServices.empId).then((res) {
                        print(res);
                        if(res=='success'){
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Login()),
                                  (Route<dynamic> route) => route is Login);
                        }

                      })
                    },
                  ),
                  Divider(
                    color: Colors.black87,
                  ),
                  new ListTile(
                    leading: Icon(Icons.supervised_user_circle),
                    title: Text(
                      'User Name : ' + loginServices.userName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => {},
                  ),
                  new ListTile(
                    leading: Icon(Icons.vpn_key),
                    title: Text(
                      'Role Type : ' + loginServices.roleName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => {},
                  ),
//                  new  Container(
//                      color: Colors.white,
//                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
//                      child:  Padding(
//                        padding: EdgeInsets.all(1.0),
//                        child: Text('User Name : ' + loginServices.userName  , textAlign: TextAlign.left,style: TextStyle( fontSize: 14,
//                            color: Colors.black,fontWeight: FontWeight.normal),),
//                      )),
//                  new  Container(
//                      color: Colors.white,
//                      padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
//                      child:  Padding(
//                        padding: EdgeInsets.all(1.0),
//                        child: Text('Role Type : ' + loginServices.roleName  , textAlign: TextAlign.left,style: TextStyle( fontSize: 14,
//                            color: Colors.black,fontWeight: FontWeight.normal),),
//                      )),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
