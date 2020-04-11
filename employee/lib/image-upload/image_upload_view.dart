import 'package:flutter/material.dart';
import 'image-upload.dart';
import 'services.dart';

class ImageUploadView extends StatefulWidget {
  //
  ImageUploadView() : super();

  final String title = 'ImageUpload View';

  @override
  ImageUploadViewState createState() => ImageUploadViewState();
}

class ImageUploadViewState extends State<ImageUploadView> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  ImageUpload imageUploadObj;
  ImageUpload imageUploadDetails;
bool isResult =false;
  @override
  void initState() {
    super.initState();
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getImageUploadsById();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _getImageUploadsById() async {
    setState(() {
      isResult = false;
    });
    _showProgress('View ImageUpload...');
    await imageUploadObj;

    Services.editImageUpload(imageUploadObj).then((result) {

      _showProgress('View ImageUpload');
      if (result.length > 0) {
        imageUploadDetails = result[0];
    setState(() {
      isResult = true;
    });
      }
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    imageUploadObj = ModalRoute.of(context).settings.arguments;
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
                          Text(imageUploadDetails.employeesId ?? '-' )
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('Employees Name')
                      ),
                      DataCell(
                          Text(imageUploadDetails.userName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('srNo')
                      ),
                      DataCell(
                          Text(imageUploadDetails.srNo?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerName')
                      ),
                      DataCell(
                          Text(imageUploadDetails.customerName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerNo')
                      ),
                      DataCell(
                          Text(imageUploadDetails.customerNo?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerAddress1')
                      ),
                      DataCell(
                          Text(imageUploadDetails.customerAddress1?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('customerAddress2')
                      ),
                      DataCell(
                          Text(imageUploadDetails.customerAddress2?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('city')
                      ),
                      DataCell(
                          Text(imageUploadDetails.city?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('Package Details')
                      ),
                      DataCell(
                          Text(imageUploadDetails.packagesName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('promtionApplicationDetails')
                      ),
                      DataCell(
                          Text(imageUploadDetails.promotionName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('documentUpload')
                      ),
                      DataCell(
                          Text(imageUploadDetails.documentUpload?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('openDate')
                      ),
                      DataCell(
                          Text(imageUploadDetails.openDate ?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('closeDate')
                      ),
                      DataCell(
                          Text(imageUploadDetails.closeDate?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                        Text('saleStatus'),
                      ),
                      DataCell(
                          Text(imageUploadDetails.saleStatus?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                        Text('Remarks'),
                      ),
                      DataCell(
                          Text(imageUploadDetails.remarks?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('verifiedBy')
                      ),
                      DataCell(
                          Text(imageUploadDetails.verifiedName?? '-')
                      )
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text('verifiedDate')
                      ),
                      DataCell(
                          Text(imageUploadDetails.verifiedDate?? '-')
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
