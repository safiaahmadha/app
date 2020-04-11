import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:employee/promotion-application/promotion-application_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'promotion-application.dart';
import 'services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';

class PromotionApplicationAdd extends StatefulWidget {
  //
  PromotionApplicationAdd() : super();

  @override
  PromotionApplicationAddState createState() => PromotionApplicationAddState();
}

class PromotionApplicationAddState extends State<PromotionApplicationAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool visible = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _fromDateController;
  TextEditingController _toDateController;
  String _titleProgress;
  PromotionApplication promotionApplicationObj;
  String employeeId;
  DateTime _openDateTime= DateTime.now();
  DateTime _closeDateTime= DateTime.now();
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/loginDetails.json');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      var responseJSON = json.decode(contents);
      employeeId = responseJSON['id'];
      var role = responseJSON['role'];
      print(role);
      return role;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

  @override
  void initState() {
    super.initState();
    _titleProgress = 'Create PromotionApplication';
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

  _showValues(PromotionApplication promotionApplication) {
    _nameController.text = promotionApplication.name;
    _descriptionController.text = promotionApplication.description;
    _fromDateController.text = promotionApplication.fromDate;
    _toDateController.text = promotionApplication.toDate;
    _openDateTime = DateTime.parse(promotionApplication.fromDate);
    _closeDateTime = DateTime.parse(promotionApplication.toDate);
  }

// Now lets add an PromotionApplication
  _addPromotionApplication() {
    _formKey.currentState.save();
    if (_openDateTime.isAfter(_closeDateTime)) {
      _showSnackBar(context, 'From Date should be greater then To Date');
      return;
    }
    if (_formKey.currentState.validate()) {
      Services.addPromotionApplication(employeeId ,_nameController.text,_descriptionController.text,_fromDateController.text,_toDateController.text).then((result) {
        _showProgress('Adding PromotionApplication');
        if ('Success' == result) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new PromotionApplicationList()));
          _clearValues();
        }else{
          _showSnackBar(context, result);
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  _updatePromotionApplication() {
    _formKey.currentState.save();
    if (_openDateTime.isAfter(_closeDateTime)) {
      _showSnackBar(context, 'From Date should be greater then To Date');
      return;
    }
    if (_formKey.currentState.validate()) {
      Services.updatePromotionApplication(promotionApplicationObj.id,employeeId,_nameController.text,_descriptionController.text,_fromDateController.text,_toDateController.text)
          .then((result) {
        _showProgress('Update PromotionApplication');
        if ('Success' == result) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new PromotionApplicationList()));
          _clearValues();
        }else{
          _showSnackBar(context, result);
        }
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _getPromotionApplicationsById(PromotionApplication promotionApplication) {
    _showProgress('Edit PromotionApplication...');
    Services.editPromotionApplication(promotionApplication).then((result) {
      if (result.length > 0) {
        _clearValues();
        _showValues(result[0]);
      }
    });
  }
  _getEditId() async {
   await promotionApplicationObj;
    if (promotionApplicationObj != null) {
      _getPromotionApplicationsById(promotionApplicationObj);
    }

  }

  @override
  Widget build(BuildContext context) {
    promotionApplicationObj = ModalRoute.of(context).settings.arguments;


//    _getPromotionApplicationsById(promotionApplicationObj);
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
              title: Text(_titleProgress), // we show the progress in the title...
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _clearValues();
//                _addPromotionApplication();
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
                      getContainer(_nameController, TextInputType.text, 'Name', true,
                          FontAwesomeIcons.user),
                      getContainer(_descriptionController, TextInputType.text, 'Description', true,
                          FontAwesomeIcons.pencilAlt),
                      Container(
                        width: 280,
                        padding: EdgeInsets.only(
                            left: 40.0, bottom: 0.0, right: 40.0, top: 10),
                        child: Column(
                          children: <Widget>[
                            DateTimeFormField(
                              initialValue: _openDateTime == null
                                  ? DateTime.now()
                                  : _openDateTime,
                              label: "From Date Time",
                              formatter: DateFormat("yyyy-MM-dd HH:mm"),
                              validator: (DateTime dateTime) {
                                if (dateTime == null) {
                                  return "Required";
                                }
                                return null;
                              },
                              onSaved: (DateTime dateTime) {
                                setState(() {
                                  _openDateTime = dateTime;
                                  _fromDateController.text = dateTime.toString();
                                });
                              },
                            ),
                            DateTimeFormField(
                              initialValue: _closeDateTime == null
                                  ? DateTime.now()
                                  : _closeDateTime,
                              firstDate: DateTime(2001),
                              lastDate: DateTime(9999),
                              label: "To Date Time",
                              formatter: DateFormat("yyyy-MM-dd HH:mm"),
                              validator: (DateTime dateTime) {
                                if (dateTime == null) {
                                  return "Required";
                                }
                                return null;
                              },
                              onSaved: (DateTime dateTime) {
                                setState(() {
                                  _closeDateTime = dateTime;
                                  _toDateController.text = dateTime.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      promotionApplicationObj == null
                          ? ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: _addPromotionApplication,
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
                            onPressed: _updatePromotionApplication,
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
      }else {
        return CircularProgressIndicator();
      }
    });

  }
}
