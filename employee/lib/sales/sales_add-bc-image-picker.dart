import 'dart:typed_data';
import 'package:employee/sales/sales_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'sales.dart';
import 'services.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:employee/global-variable.dart' as global;
//import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:employee/services.dart' as globalServices;
class PackagesList {
  String name;
  String id;

  PackagesList({this.id, this.name});

  factory PackagesList.formJson(Map<String, dynamic> json) {
    return PackagesList(id: json['id'], name: json['name']);
  }
}

class SalesAdd extends StatefulWidget {
  //
  SalesAdd() : super();

  @override
  SalesAddState createState() => SalesAddState();
}

class SalesAddState extends State<SalesAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool visible = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _srNoController;
  TextEditingController _customerNameController;
  TextEditingController _customerNoController;
  TextEditingController _customerAddress1Controller;
  TextEditingController _customerAddress2Controller;
  TextEditingController _cityController;
  TextEditingController _packageDetailsIdController;
  TextEditingController _promtionApplicationDetailsController;
  TextEditingController _promotionApplicationIdController;
  TextEditingController _documentUploadController;
  TextEditingController _openDateController;
  TextEditingController _closedDateController;
  TextEditingController _saleStatusController;
  TextEditingController _remarksController;
  TextEditingController _verifiedByController;
  TextEditingController _verifiedDateController;
  TextEditingController _packagesIdController;
  String _titleProgress;
  Sales salesObj;
  String employeeId;
  List<PackagesList> _packages = [];
  List<PackagesList> _promotionApplication = [];
  String _selectedUser;
  String _selectedPromotion;
  String salesStatus = 'Open';
  String isChooseImage = 'yes';
  DateTime _openDateTime = DateTime.now();
  DateTime _closeDateTime;
  DateTime _verifiedDateTime;
  List<String> listStatus;

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
      return role;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

  @override
  void initState() {
    super.initState();
    _titleProgress = 'Create Sales';
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _srNoController = TextEditingController();
    _customerNameController = TextEditingController();
    _customerNoController = TextEditingController();
    _customerAddress1Controller = TextEditingController();
    _customerAddress2Controller = TextEditingController();
    _cityController = TextEditingController();
    _packageDetailsIdController = TextEditingController();
    _promtionApplicationDetailsController = TextEditingController();
    _promotionApplicationIdController = TextEditingController();
    _documentUploadController = TextEditingController();
    _openDateController = TextEditingController();
    _closedDateController = TextEditingController();
    _saleStatusController = TextEditingController();
    _remarksController = TextEditingController();
    _verifiedByController = TextEditingController();
    _verifiedDateController = TextEditingController();
    _packagesIdController = TextEditingController();


    _saleStatusController.text = 'Open';

    awaitCall();
  }
awaitCall() async {
    await salesObj;
  await getPackagesList();
  await getPromotionApplicationList();
  await  _getEditId();
}
  //  roleList selectedUser;
  getPackagesList() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'PACKAGE_LIST';
      await salesObj;
      if (salesObj == null) {
        map['list_type'] = 'ACTIVE_LIST';
      }else{
        map['edit_id'] = salesObj.id;
        map['list_type'] = 'ALL';
      }
      final response = await http.post(global.packagesUrl, body: map);
      print('getpackagesList: ${response.statusCode}');
      if (200 == response.statusCode) {
        print('getpackagesList: ${response.body}');
        var json = JsonDecoder().convert(response.body);
        _packages = (json).map<PackagesList>((data) {
          return PackagesList.formJson(data);
        }).toList();
        setState(() {
          _packages = (json).map<PackagesList>((data) {
            return PackagesList.formJson(data);
          }).toList();
          _selectedUser = _packages[0].id;
          _packagesIdController.text = _packages[0].id;
        });
        _packagesIdController.text = _packages[0].id;
        _selectedUser = _packages[0].id;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  getPromotionApplicationList() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'PROMOTION_APPLICATION_LIST';
      await salesObj;
      if (salesObj == null) {
        map['list_type'] = 'ACTIVE_LIST';
      }else{
        map['edit_id'] = salesObj.id;
        map['list_type'] = 'ALL';
      }
      final response =
          await http.post(global.promotionApplicationUrl, body: map);
      print('getpackagesList: ${response.statusCode}');
      if (200 == response.statusCode) {
        print('getpackagesList: ${response.body}');
        var json = JsonDecoder().convert(response.body);
        _promotionApplication = (json).map<PackagesList>((data) {
          return PackagesList.formJson(data);
        }).toList();
        setState(() {
          _promotionApplication = (json).map<PackagesList>((data) {
            return PackagesList.formJson(data);
          }).toList();
          _selectedPromotion = _promotionApplication[0].id;
          _promotionApplicationIdController.text = _promotionApplication[0].id;
        });
        _promotionApplicationIdController.text = _promotionApplication[0].id;
        _selectedPromotion = _promotionApplication[0].id;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

// Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _clearValues() {
    _srNoController.text = '';
    _customerNameController.text = '';
    _customerNoController.text = '';
    _customerAddress1Controller.text = '';
    _customerAddress2Controller.text = '';
    _cityController.text = '';
    _packagesIdController.text = _packages[0].id;
    _selectedUser = _packages[0].id;
    _selectedPromotion = _promotionApplication[0].id;
    _promtionApplicationDetailsController.text = _promotionApplication[0].id;
    _documentUploadController.text = '';
    _openDateController.text = DateTime.now().toString();
    _closedDateController.text = DateTime.now().toString();
    _saleStatusController.text = 'Open';
    _remarksController.text = '';
    salesStatus = 'Open';
    _verifiedByController.text = '';
    _verifiedDateController.text = '';
  }

  _showValues(Sales sales) {
    _srNoController.text = sales.srNo;
    _customerNameController.text = sales.customerName;
    _customerNoController.text = sales.customerNo;
    _customerAddress1Controller.text = sales.customerAddress1;
    _customerAddress2Controller.text = sales.customerAddress2;
    _cityController.text = sales.city;
    _packageDetailsIdController.text = sales.packageDetailsId;
    _promtionApplicationDetailsController.text =
        sales.promtionApplicationDetails;
//
    base64Image = sales.base64Encode;
    isChooseImage = 'no';
    base64ImageDecode = base64Decode(sales.base64Encode);
    _documentUploadController.text = sales.documentUpload;
    _openDateController.text = sales.openDate;
    _closeDateTime = DateTime.parse(sales.closeDate);
    _closeDateTime = null;
    _openDateTime = DateTime.parse(sales.openDate);
    _closedDateController.text = sales.closeDate;
    _saleStatusController.text = sales.saleStatus;
    _remarksController.text = sales.remarks;
    _verifiedByController.text = sales.verifiedBy;
    _verifiedDateController.text = sales.verifiedDate;
    _verifiedDateTime = DateTime.parse(sales.verifiedDate);
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

// Now lets add an Sales
  _addSales() {
    uploadImage();
    _formKey.currentState.save();

    _openDateController.text = _openDateTime.toString();
    _closedDateController.text = _closeDateTime.toString();
//if(globalServices.roleName == 'ADMIN' || globalServices.roleName == 'BACKOFFICE'){
//  if (_openDateTime.isAfter(_closeDateTime)) {
//    _showSnackBar(context, 'From Date should be greater then To Date');
//    return;
//  }
//}

    if (_formKey.currentState.validate()) {
      Services.addSales(
              _srNoController.text,
              _customerNameController.text,
              _customerNoController.text,
              _customerAddress1Controller.text,
              _customerAddress2Controller.text,
              _cityController.text,
              _packagesIdController.text,
              _promotionApplicationIdController.text,
              _documentUploadController.text,
              _openDateController.text,
              _closedDateController.text,
              _saleStatusController.text,
              _remarksController.text,
              _verifiedByController.text,
              _verifiedDateController.text,
              employeeId,
              base64Image)
          .then((result) {
        _showProgress('Adding Sales');

        if ('Success' == result) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new SalesList()));
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

  _updateSales() {

//    if(globalServices.roleName == 'ADMIN' || globalServices.roleName == 'BACKOFFICE'){
//
//      _formKey.currentState.save();
//      if (_openDateTime.isAfter(_closeDateTime)) {
//        _showSnackBar(context, 'From Date should be greater then To Date');
//        return;
//      }
//    }
    if (_formKey.currentState.validate()) {
      Services.updateSales(
              salesObj.id,
              _srNoController.text,
              _customerNameController.text,
              _customerNoController.text,
              _customerAddress1Controller.text,
              _customerAddress2Controller.text,
              _cityController.text,
              _packagesIdController.text,
              _promotionApplicationIdController.text,
              _documentUploadController.text,
              _openDateController.text,
              _closedDateController.text,
              _saleStatusController.text,
          _remarksController.text,
              _verifiedByController.text,
              _verifiedDateController.text,
              employeeId,
              base64Image)
          .then((result) {
        _showProgress('Update Sales');

        if ('Success' == result) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new SalesList()));
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

  _getSalessById(Sales sales) {
    _showProgress('Edit Sales...');
    Services.editSales(sales).then((result) {
      if (result.length > 0) {
        _clearValues();
        _showValues(result[0]);
      }
    });
  }

  static final String uploadEndPoint = '';
  Future<File> file;
  String status;
  String base64Image;
  File tempFile;
  String errMessage = 'Error Uploding Image';
  Uint8List base64ImageDecode;

  chooseImage() async {
    setState(() {
//      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    uploadImage();
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  uploadImage() {
    setStatus('Uploading Image');
    if (null == tempFile) {
      setStatus(errMessage);
      return;
    }

    String fileName = tempFile.path.split('/').last;
    print(fileName);
    _documentUploadController.text = fileName;
  }

  upload(String fileName) {
//    print(uploadEndPoint);
  }

  _getEditId() async {
    await salesObj;

    if (salesObj != null) {
      _getSalessById(salesObj);
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tempFile = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());

            return  Container(
              child: Image.file(snapshot.data,
//                base64Decode(base64Image),

                  height: 50,
                  width:50
              )
            );
          } else if (null != snapshot.error) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center
            );
          } else {
            return const Text(
              ' No Image Selected',
              textAlign: TextAlign.center
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    salesObj = ModalRoute.of(context).settings.arguments;

    if(globalServices.roleName.toUpperCase() == 'ADMIN' || globalServices.roleName.toUpperCase() == 'BACKOFFICE'){
      setState(() {
        listStatus =<String>[
          'Open',
          'Closed',
          'Completed',
          'Canceled',
        ];
      });
    }else{
      setState(() {
        listStatus  =<String>[
          'Open',
        ];
      });
    }
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
              labelText: isReq ? '$_labelText *' : _labelText
            ),
            validator: (value) {
              return value.isEmpty ? 'Required' : null;
            }
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
                        getPackagesList();
                        getPromotionApplicationList();
                        _clearValues();
//                _addSales();
                      }
                    )
                  ]
                ),
                body: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            getContainer(_srNoController, TextInputType.text,
                                'SR No', true, FontAwesomeIcons.safari),
                            getContainer(
                                _customerNameController,
                                TextInputType.text,
                                'Customer Name',
                                true,
                                FontAwesomeIcons.userCircle),
                            getContainer(
                                _customerAddress1Controller,
                                TextInputType.text,
                                'CustomerAddress 1',
                                true,
                                FontAwesomeIcons.addressBook),
                            getContainer(
                                _customerAddress2Controller,
                                TextInputType.text,
                                'CustomerAddress 2',
                                true,
                                FontAwesomeIcons.addressBook),
                            getContainer(_cityController, TextInputType.text,
                                'City', true, FontAwesomeIcons.city),
                            getContainer(
                                _customerNoController,
                                TextInputType.phone,
                                'Customer Number',
                                true,
                                FontAwesomeIcons.phone),
                            Container(
                              width: 280,
                              padding: EdgeInsets.only(
                                  left: 40.0,
                                  bottom: 0.0,
                                  right: 40.0,
                                  top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.criticalRole,
                                    color: Color(0xff11b719)
                                  ),
                                  SizedBox(
                                    width: 15.0
                                  ),
                                  Text('Promotion Applicable:')
                                ]
                              )
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20.0
                                  ),
                                  Container(
                                      width: 340.0,
                                      padding: EdgeInsets.only(
                                          right: 10, bottom: 10, top: 10),
                                      child: DropdownButton<String>(
                                        value: _selectedPromotion,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _selectedPromotion = newValue;
                                            _promtionApplicationDetailsController
                                                .text = newValue;

                                            _promotionApplicationIdController
                                                .text = newValue;
                                          });
                                        },
                                        isExpanded: true,
                                        hint: Text('Select'),
                                        items: _promotionApplication
                                            .map((PackagesList data) {
                                          return DropdownMenuItem<String>(
                                              value: data.id,
                                              child: Text(data.name));
                                        }).toList()
                                      ))
                                ]),
                            Container(
                              width: 280,
                              padding: EdgeInsets.only(
                                  left: 40.0,
                                  bottom: 0.0,
                                  right: 40.0,
                                  top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.criticalRole,
                                    color: Color(0xff11b719)
                                  ),
                                  SizedBox(
                                    width: 15.0
                                  ),
                                  Text('Package Details :')
                                ],
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20.0
                                  ),
                                  Container(
                                      width: 340.0,
                                      padding: EdgeInsets.only(
                                          right: 10, bottom: 10, top: 10),
                                      child: DropdownButton<String>(
                                        value: _selectedUser,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _selectedUser = newValue;
                                            _packagesIdController.text =
                                                newValue;
                                          });
                                        },
                                        isExpanded: true,
                                        hint: Text('Select'),
                                        items:
                                            _packages.map((PackagesList data) {
                                          return DropdownMenuItem<String>(
                                              value: data.id,
                                              child: Text(data.name));
                                        }).toList()
                                      ))
                                ]),
                            Container(
                              width: 280,
                              padding: EdgeInsets.only(
                                  left: 40.0,
                                  bottom: 0.0,
                                  right: 40.0,
                                  top: 0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.upload,
                                    color: Color(0xff11b719)
                                  ),
                                  SizedBox(
                                    width: 15.0
                                  ),
                                  OutlineButton(
                                    onPressed: chooseImage,
                                    child: Text('Document Upload')
                                  ),
//                            showImage(),
                                  SizedBox(
                                    width: 20.0
                                  ),
                                  isChooseImage == 'yes'
                                      ? showImage()
                                      : Container(
                                          child: Image.memory(
                                            base64ImageDecode,
                                            height: 50,
                                            width: 90
                                          )
                                        )

                                ]
                              )
                            ),
                            Container(
                              width: 280,
                              padding: EdgeInsets.only(
                                  left: 40.0,
                                  bottom: 0.0,
                                  right: 40.0,
                                  top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.criticalRole,
                                    color: Color(0xff11b719)
                                  ),
                                  SizedBox(
                                    width: 15.0
                                  ),
                                  Text('Sales Status:')
                                ]
                              )
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20.0
                                  ),
                                  Container(
                                      width: 340.0,
                                      padding: EdgeInsets.only(
                                          right: 10, bottom: 0, top: 0),

                                      child: DropdownButton<String>(
                                        value: salesStatus,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            salesStatus = newValue;
                                            _saleStatusController.text =
                                                newValue;
                                          });
                                          return null;
                                        },
                                        isExpanded: true,
                                        hint: Text('Select'),
                                        items: listStatus.map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value)
                                              );
                                            }).toList(),
                                      ))
                                ]),

                            Container(
                              width: 280,
                              padding: EdgeInsets.only(
                                  left: 40.0,
                                  bottom: 0.0,
                                  right: 40.0,
                                  top: 10),
                              child:(globalServices.roleName.toUpperCase() == 'ADMIN' || globalServices.roleName.toUpperCase() == 'BACKOFFICE') ? Column(
                                children: <Widget>[


                                  DateTimeFormField(
                                    initialValue: _openDateTime == null
                                        ? DateTime.now()
                                        : _openDateTime,
                                    label: "Open Date Time",
                                    formatter: DateFormat("yyyy-MM-dd HH:mm"),
                                    validator: (DateTime dateTime) {
                                      if (dateTime == null) {
                                        return "Required";
                                      }
                                      return null;
                                    },

                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(9999),
                                    enabled: false,
                                    onSaved: (DateTime date) {
                                      setState(() {
                                        _openDateTime = date == null
                                            ? DateTime.now()
                                            : date;
                                        _openDateController.text = date == null
                                            ? DateTime.now()
                                            : date.toString();
                                      });
                                    }
                                  ),
                                  Container(
                                      child: TextFormField(
                                          controller: _remarksController,
                                          autocorrect: true,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                              icon: Icon(FontAwesomeIcons.file, color: Color(0xff11b719)),
                                              hintText: 'Enter Your remarks Here',
                                              labelText: globalServices.roleName.toUpperCase() == 'BACKOFFICE' ? 'Remarks *' : 'Remarks'
                                          ),
                                          validator: (value) {
                                            return value.isEmpty ? 'Required' : null;
                                          }
                                      )),

//                                  DateTimeFormField(
//                                    initialValue: _closeDateTime == null
//                                        ? DateTime.now()
//                                        : _closeDateTime,
//                                    firstDate: DateTime(2001),
//                                    lastDate: DateTime(9999),
//                                    label: "Close Date Time",
//                                    formatter: DateFormat("yyyy-MM-dd HH:mm"),
//                                    validator: (DateTime dateTime) {
//                                      if (dateTime == null) {
//                                        return "Required";
//                                      }
//                                      return null;
//                                    },
//                                    onSaved: (DateTime dateTime) {
//                                      setState(() {
//                                        _closeDateTime = dateTime == null
//                                            ? DateTime.now()
//                                            : dateTime;
//                                        _closedDateController.text =
//                                            dateTime == null
//                                                ? DateTime.now()
//                                                : dateTime.toString();
//                                      });
//                                    },
//                                  ),

//                                  DateTimeFormField(
//                                    initialValue: _verifiedDateTime == null
//                                        ? DateTime.now()
//                                        : _verifiedDateTime,
//                                    firstDate: DateTime(2001),
//                                    lastDate: DateTime(9999),
//                                    label: "Verified Date",
//                                    formatter: DateFormat("yyyy-MM-dd HH:mm"),
//                                    validator: (DateTime dateTime) {
////                                if (dateTime == null) {
////                                  return "Required";
////                                }
//                                      return null;
//                                    },
//                                    onSaved: (DateTime dateTime) {
//                                      setState(() {
//                                        _verifiedDateTime = dateTime == null
//                                            ? DateTime.now()
//                                            : dateTime;
//                                        _verifiedDateController.text =
//                                        dateTime == null
//                                            ? DateTime.now()
//                                            : dateTime.toString();
//                                      });
//                                    },
//                                  ),

                                  DateTimeField(
//                                    keyboardType: TextInputType.multiline,
                                    initialValue: _closeDateTime,

                                    format: DateFormat("yyyy-MM-dd HH:mm"),
                                    decoration: InputDecoration(
                                        icon: Icon(FontAwesomeIcons.calendarAlt, color: Color(0xff11b719)),
                                        hintText: 'Enter Close Date Time Here',
                                        labelText: 'Close date Time'
                                    ),
                                    onShowPicker: (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));

                                      if (date != null) {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime:
                                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                        );
                                        setState(() {
                                          _closeDateTime = DateTimeField.combine(date, time);
                                          _closedDateController.text = DateTimeField.combine(date, time).toString();
                                        });
                                        return DateTimeField.combine(date, time);
                                      } else {
                                        setState(() {
                                          _closeDateTime = currentValue;
                                          _closedDateController.text = currentValue.toString();
                                        });
                                        return currentValue;
                                      }
                                    },
                                  ),


                                  DateTimeField(
//                                    keyboardType: TextInputType.multiline,
                                  initialValue: _verifiedDateTime ,
                                    format: DateFormat("yyyy-MM-dd HH:mm"),
                                    decoration: InputDecoration(
                                        icon: Icon(FontAwesomeIcons.calendarAlt, color: Color(0xff11b719)),
                                        hintText: 'Enter Close Date Here',
                                        labelText: 'Verified  Date Time'
                                    ),
                                    onShowPicker: (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));

                                      if (date != null) {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime:
                                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                        );
                                        setState(() {
                                          _verifiedDateTime = DateTimeField.combine(date, time);
                                          _verifiedDateController.text = DateTimeField.combine(date, time).toString();
                                        });
                                        return DateTimeField.combine(date, time);
                                      } else {
                                        setState(() {
                                          _verifiedDateTime = currentValue;
                                          _verifiedDateController.text = currentValue.toString();
                                        });
                                        print(this);
                                        return currentValue;
                                      }
                                    },
                                  )
//                                  CheckboxListTile(
//                                    title: Text("isVerified"),
//                                    value: _value,
//                                    onChanged: (bool newValue) {
//                                      setState(() {
//                                        _value = newValue;
//                                      });
//                                    },
//                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                                  ),
                                ]
                              ):Text('Open Date : $_openDateTime' )
                            ),


                            Container(
                              width: 280,
                              padding: EdgeInsets.only(
                                  left: 40.0,
                                  bottom: 0.0,
                                  right: 40.0,
                                  top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  salesObj == null
                                      ? RaisedButton(
                                          onPressed: _addSales,
                                          color: Colors.green,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: new Text('submit'))
                                      : RaisedButton(
                                          onPressed: _updateSales,
                                          color: Colors.green,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: new Text('update')
                                        ),
                                  SizedBox(
                                      width: 15.0
                                  ),
                                  Visibility(
                                      visible: visible,
                                      child: Container(
                                          margin: EdgeInsets.only(bottom: 30),
                                          child: CircularProgressIndicator()))
                                ]
                              )
                            )
                          ]
                        ))));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
