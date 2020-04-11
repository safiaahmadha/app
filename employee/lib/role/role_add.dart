import 'package:employee/role/role_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'role.dart';
import 'services.dart';

class RolesAdd extends StatefulWidget {
  //
  RolesAdd() : super();

  @override
  RolesAddState createState() => RolesAddState();
}

class RolesAddState extends State<RolesAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool visible = false;

  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController;
  TextEditingController _rCreateController;
  TextEditingController _rEditController;
  TextEditingController _rViewController;
  TextEditingController _rDeleteController;
  String _titleProgress;
  Roles rolesObj;
  String nameExit;
  bool _craete = false;
  bool _edit = false;
  bool _view = false;
  bool _delete = false;
  @override
  void initState() {
    super.initState();
    _titleProgress = 'Create Roles';
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _nameController = TextEditingController();
    _rCreateController = TextEditingController();
    _rEditController = TextEditingController();
    _rViewController = TextEditingController();
    _rDeleteController = TextEditingController();
    _getRolessById();
  }

// Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _clearValues() {
    _nameController.text = '';
    _rCreateController.text = '';
    _rEditController.text = '';
    _rViewController.text = '';
    _rDeleteController.text = '';
  }

  _showValues(Roles roles) {
    _nameController.text = roles.name;

    if(roles.rCreate == '1'){
      setState(() {
        _craete = true;
      });
    }else{
      setState(() {
        _craete = false;
      });
    }
    if(roles.rEdit == '1'){
      setState(() {
        _edit = true;
      });
    }else{
      setState(() {
        _edit = false;
      });
    }
    if(roles.rView == '1'){
      setState(() {
        _view = true;
      });
    }else{
      setState(() {
        _view = false;
      });
    }
    if(roles.rDelete == '1'){
      setState(() {
        _delete = true;
      });
    }else{
      setState(() {
        _delete = false;
      });
    }
    _rCreateController.text = roles.rCreate;
    _rEditController.text = roles.rEdit;
    _rViewController.text = roles.rView;
    _rDeleteController.text = roles.rDelete;
  }
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
// Now lets add an Roles
  _addRoles() {
    if (_formKey.currentState.validate()) {
      Services.addRoles(
              _nameController.text,
              _rCreateController.text,
              _rEditController.text,
              _rViewController.text,
              _rDeleteController.text)
          .then((result) {
        _showProgress('Adding Roles');

        if ('Success' == result) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new RolesList()));
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

  _updateRoles() {
    if (_formKey.currentState.validate()) {
      Services.updateRoles(
              rolesObj.id,
              _nameController.text,
              _rCreateController.text,
              _rEditController.text,
              _rViewController.text,
              _rDeleteController.text)
          .then((result) {
        _showProgress('Update Roles');

        if ('Success' == result) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>new RolesList()));
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

  _getRolessById() async {
    await rolesObj;
    if (rolesObj != null) {
      Services.editRoles(rolesObj).then((result) {
        if (result.length > 0) {
          _clearValues();
          _showValues(result[0]);
        }
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    rolesObj = ModalRoute.of(context).settings.arguments;


//    _getRolessById(rolesObj);
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
            }
          ));
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress), // we show the progress in the title...
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _clearValues();
//                _addRoles();
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

              Container(
                  width: 280,
                  padding: EdgeInsets.only(left: 40.0, bottom: 10.0, right: 10.0),
                  child:  CheckboxListTile(
                    title: Text('Create'),
                    value: _craete,
                    secondary:  Icon( FontAwesomeIcons.plusCircle , color: Color(0xff11b719)),

                    onChanged: (bool newValue) {
                      setState(() {
                        _craete = newValue;
                        _rCreateController.text = newValue ? '1' : '0';
                      });
                    },
//        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.only(left: 40.0, bottom: 10.0, right: 10.0),
                  child:  CheckboxListTile(
                    title: Text('Edit'),
                    value: _edit,
                    secondary:  Icon( FontAwesomeIcons.edit , color: Color(0xff11b719)),

                    onChanged: (bool newValue) {
                      setState(() {
                        _edit = newValue;
                        _rEditController.text = newValue ? '1' : '0';
                      });
                    },
//        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.only(left: 40.0, bottom: 10.0, right: 10.0),
                  child:  CheckboxListTile(
                    title: Text('View'),
                    value: _view,
                    secondary:  Icon( FontAwesomeIcons.eye , color: Color(0xff11b719)),

                    onChanged: (bool newValue) {
                      setState(() {
                        _view = newValue;
                        _rViewController.text = newValue ? '1' : '0';
                      });
                    },
//        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.only(left: 40.0, bottom: 10.0, right: 10.0),
                  child:  CheckboxListTile(
                    title: Text('Delete'),
                    value: _delete,
                    secondary:  Icon( FontAwesomeIcons.trash , color: Color(0xff11b719)),

                    onChanged: (bool newValue) {
                      setState(() {
                        _delete = newValue;
                        _rDeleteController.text = newValue ? '1' : '0';
                      });
                    },
//        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )),
              rolesObj == null
                  ? ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: _addRoles,
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
                          onPressed: _updateRoles,
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
  }
}
