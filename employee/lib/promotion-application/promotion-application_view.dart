import 'package:flutter/material.dart';
import 'promotion-application.dart';
import 'services.dart';

class PromotionApplicationView extends StatefulWidget {
  //
  PromotionApplicationView() : super();

  final String title = 'PromotionApplication View';

  @override
  PromotionApplicationViewState createState() =>
      PromotionApplicationViewState();
}

class PromotionApplicationViewState extends State<PromotionApplicationView> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  PromotionApplication promotionApplicationObj;
  PromotionApplication promotionApplicationDetails;

  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getEditId();
  }

  void dispose() {
    super.dispose();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _getPromotionApplicationsById(PromotionApplication promotionApplication) {
    _showProgress('View PromotionApplication...');
    Services.editPromotionApplication(promotionApplication).then((result) {
      _showProgress('View PromotionApplication');
      if (result.length > 0) {
        promotionApplicationDetails = result[0];
      }
    });
  }

  _getEditId() async {
 await promotionApplicationObj;
    if (promotionApplicationObj != null) {
      _getPromotionApplicationsById(promotionApplicationObj);
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    promotionApplicationObj = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress), // we show the progress in the title...
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(''),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 110,
                    columns: [
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                            Text('Package Name'),
                          ),
                          DataCell(
                            Text(promotionApplicationObj.name),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text('Decription'),
                          ),
                          DataCell(
                            Text(promotionApplicationObj.description),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text('From Date'),
                          ),
                          DataCell(
                            Text(promotionApplicationObj.fromDate),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                            Text('To Date'),
                          ),
                          DataCell(
                            Text(promotionApplicationObj.toDate),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
