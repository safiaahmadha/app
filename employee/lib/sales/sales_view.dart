import 'package:flutter/material.dart';
import 'sales.dart';
import 'services.dart';

class SalesView extends StatefulWidget {
  //
  SalesView() : super();

  final String title = 'Sales View';

  @override
  SalesViewState createState() => SalesViewState();
}

class SalesViewState extends State<SalesView> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  Sales salesObj;
  Sales salesDetails;
bool isResult =false;
  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getSalessById();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _getSalessById() async {
    setState(() {
      isResult = false;
    });
    _showProgress('View Sales...');
    await salesObj;

    Services.editSales(salesObj).then((result) {

      _showProgress('View Sales');
      if (result.length > 0) {
        salesDetails = result[0];
    setState(() {
      isResult = true;
    });
      }
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    salesObj = ModalRoute.of(context).settings.arguments;
if(isResult){
  return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(_titleProgress), // we show the progress in the title...
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {}
        )
      ],
    ),
    body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text('')
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                        label: Text('')
                    ),
                    DataColumn(
                        label: Text('')
                    )
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(
                          Text('employeesId')
                      ),
                      DataCell(
                          Text(salesDetails.employeesId ?? '-' )
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('Employees Name')
                      ),
                      DataCell(
                          Text(salesDetails.userName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('srNo')
                      ),
                      DataCell(
                          Text(salesDetails.srNo?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerName')
                      ),
                      DataCell(
                          Text(salesDetails.customerName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerNo')
                      ),
                      DataCell(
                          Text(salesDetails.customerNo?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerAddress1')
                      ),
                      DataCell(
                          Text(salesDetails.customerAddress1?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerAddress2')
                      ),
                      DataCell(
                          Text(salesDetails.customerAddress2?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('city')
                      ),
                      DataCell(
                          Text(salesDetails.city?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('Package Details')
                      ),
                      DataCell(
                          Text(salesDetails.packagesName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('promtionApplicationDetails')
                      ),
                      DataCell(
                          Text(salesDetails.promotionName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('documentUpload')
                      ),
                      DataCell(
                          Text(salesDetails.documentUpload?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('openDate')
                      ),
                      DataCell(
                          Text(salesDetails.openDate ?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('closeDate')
                      ),
                      DataCell(
                          Text(salesDetails.closeDate?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                        Text('saleStatus'),
                      ),
                      DataCell(
                          Text(salesDetails.saleStatus?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                        Text('Remarks'),
                      ),
                      DataCell(
                          Text(salesDetails.remarks?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('verifiedBy')
                      ),
                      DataCell(
                          Text(salesDetails.verifiedName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('verifiedDate')
                      ),
                      DataCell(
                          Text(salesDetails.verifiedDate?? '-')
                      )
                    ])
                  ]),
            ),
          )
        ],
      ),
    ),
  );
}else{
  return CircularProgressIndicator();
}

  }
}
