import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:employee/packages/packages_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'packages.dart';
import 'services.dart';

class PackagesAdd extends StatefulWidget {
  //
  PackagesAdd() : super();

  @override
  PackagesAddState createState() => PackagesAddState();
}

class PackagesAddState extends State<PackagesAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool visible = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _fromDateController;
  TextEditingController _toDateController;
  String _titleProgress;
  Packages packagesObj;
  String employeeId;
  DateTime _openDateTime;
  DateTime _closeDateTime;


  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/loginDetails.json');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var responseJSON = json.decode(contents);
      employeeId = responseJSON['id'];
      var role = responseJSON['role'];
      return role;
    } catch (e) {
      return 'Error';
    }
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleProgress = 'Create Packages';
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _fromDateController = TextEditingController();
    _toDateController = TextEditingController();
    _getEditId();
  }

// Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _clearValues() {
    _nameController.text = '';
    _descriptionController.text = '';
    _fromDateController.text = '';
    _toDateController.text = '';
  }

  _showValues(Packages packages) {
    _nameController.text = packages.name;
    _descriptionController.text = packages.description;
    _fromDateController.text = packages.fromDate;
    _toDateController.text = packages.toDate;
    _openDateTime = DateTime.parse(packages.fromDate);
    _closeDateTime = DateTime.parse(packages.toDate);
  }

// Now lets add an Packages
  _addPackages() {
    if (_formKey.currentState.validate()) {
      Services.addPackages(
              employeeId,
              _nameController.text,
              _descriptionController.text,
              _fromDateController.text,
              _toDateController.text)
          .then((result) {
        _showProgress('Adding Packages');

        if ('Success' == result) {
          Navigator.pop(
              context, MaterialPageRoute(builder: (context) => PackagesList()));
          _clearValues();
        } else {
          _showSnackBar(context, result);
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _updatePackages() {
    print(_toDateController.text);
    if (_formKey.currentState.validate()) {
      Services.updatePackages(
              packagesObj.id,
              employeeId,
              _nameController.text,
              _descriptionController.text,
              _fromDateController.text,
              _toDateController.text)
          .then((result) {
        _showProgress('Update Packages');

        if ('Success' == result) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PackagesList()));
          _clearValues();
        } else {
          _showSnackBar(context, result);
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _getPackagessById(Packages packages) {
    _showProgress('Edit Packages...');
    Services.editPackages(packages).then((result) {
      if (result.length > 0) {
        _clearValues();
        _showValues(result[0]);
      }
    });
  }

  _getEditId() async {
  await packagesObj;
    if (packagesObj != null) {
      _getPackagessById(packagesObj);
    }
  }

  @override
  Widget build(BuildContext context) {
    packagesObj = ModalRoute.of(context).settings.arguments;
    getContainer(_controllerName, _keybordType, _labelText, isReq, fontIcon) {
      return Container(
          width: 280,
          padding: EdgeInsets.only(left: 40.0, bottom: 10.0, right: 40.0),
          child: TextFormField(
            controller: _controllerName,
            autocorrect: true,
            keyboardType: _keybordType,
            decoration: InputDecoration(
              icon: Icon(fontIcon, color: Color(0xff11b719)),
              hintText: 'Enter Your $_labelText Here',
              labelText: isReq ? '$_labelText *' : _labelText,
            ),
            validator: (value) {
              return value.isEmpty ? 'Required' : null;
            },
          ));
    }


    return FutureBuilder<String>(
        future: readContent(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text(_titleProgress),
                  // we show the progress in the title...
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        _clearValues();
//                _addPackages();
                      },
                    )
                  ],
                ),
                body: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      getContainer(_nameController, TextInputType.text, 'Name',
                          true, FontAwesomeIcons.user),
                      getContainer(_descriptionController, TextInputType.text,
                          'Description', true, FontAwesomeIcons.pencilAlt),

                      Container(
                        width: 280,
                        padding: EdgeInsets.only(
                            left: 40.0, bottom: 0.0, right: 40.0, top: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.calendarAlt,
                              color: Color(0xff11b719),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            OutlineButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: _openDateTime == null
                                            ? DateTime.now()
                                            : _openDateTime,
                                        firstDate: DateTime(2001),
                                        lastDate: DateTime(2222))
                                    .then((date) {
                                  setState(() {
                                    _openDateTime = date == null ? DateTime.now() : date;
                                    _fromDateController.text = date == null ? DateTime.now() : date.toString();
                                  });
                                });
                              },
                              child: Text('From Date'),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text('$_openDateTime'),
//                            OutlineButton(
//                              onPressed: uploadImage,
//                              child: Text('Upload Image'),
//                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 280,
                        padding: EdgeInsets.only(
                            left: 40.0, bottom: 0.0, right: 40.0, top: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.calendarAlt,
                              color: Color(0xff11b719),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            OutlineButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: _closeDateTime == null
                                            ? DateTime.now()
                                            : _closeDateTime,
                                        firstDate: DateTime(2001),
                                        lastDate: DateTime(2222))
                                    .then((date) {
                                  setState(() {
                                    _closeDateTime =
                                        date == null ? DateTime.now() : date;
                                    _toDateController.text = date == null
                                        ? DateTime.now()
                                        : date.toString();
                                  });
                                });
                              },
                              child: Text('To Date'),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text('$_closeDateTime'),
//                            OutlineButton(
//                              onPressed: uploadImage,
//                              child: Text('Upload Image'),
//                            )
                          ],
                        ),
                      ),
                      packagesObj == null
                          ? ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: _addPackages,
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text('submit'),
                                ),
                              ],
                            )
                          : ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: _updatePackages,
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                  child: Text('update'),
                                ),
                              ],
                            ),
                      Visibility(
                          visible: visible,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: CircularProgressIndicator())),
                    ],
                  ),
                )));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
