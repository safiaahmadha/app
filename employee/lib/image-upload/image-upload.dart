class ImageUpload {
  String id;
  String srNo;
  String customerName;
  String customerNo;
  String customerAddress1;
  String customerAddress2;
  String city;
  String packageDetailsId;
  String promtionApplicationDetails;
  String documentUpload;
  String employeesId;
  String openDate;
  String closeDate;
  String saleStatus;
  String remarks;
  String verifiedBy;
  String verifiedDate;
  String userName;
  String packagesName;
  String promotionName;
  String verifiedName;
  String base64Encode;
  ImageUpload(
      {this.id,
      this.employeesId,
      this.srNo,
      this.customerName,
      this.customerNo,
      this.customerAddress1,
      this.customerAddress2,
      this.city,
      this.packageDetailsId,
      this.promtionApplicationDetails,
      this.documentUpload,
      this.openDate,
      this.closeDate,
      this.saleStatus,
      this.remarks,
      this.verifiedBy,
      this.verifiedDate,
      this.userName,
      this.packagesName,
      this.promotionName,
      this.verifiedName,
      this.base64Encode
      });

  factory ImageUpload.fromJson(Map<String, dynamic> json) {
    return ImageUpload(
      id: json['id'] as String,
      employeesId: json['employees_id'] as String,
      srNo: json['sr_no'] as String,
      customerName: json['customer_name'] as String,
      customerNo: json['customer_no'] as String,
      customerAddress1: json['customer_address1'] as String,
      customerAddress2: json['customer_address2'] as String,
      city: json['city'] as String,
      packageDetailsId: json['package_details_id'] as String,
      promtionApplicationDetails:
          json['promtion_application_details'] as String,
      documentUpload: json['document_upload'] as String,
      openDate: json['open_date'] as String,
      closeDate: json['close_date'] as String,
      saleStatus: json['sale_status'] as String,
      remarks: json['remarks'] as String,
      verifiedBy: json['verified_by'] as String,
      verifiedDate: json['verified_date'] as String,
      packagesName: json['packages_name'] as String,
        userName: json['user_name'] as String,
        verifiedName: json['verified_name'] as String,
      promotionName: json['promotion_name'] as String,
        base64Encode:json['base64Encode'] as String
    );
  }
}
