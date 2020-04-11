class Employee {
  String id;
  String userName;
  String email;
  String contactNumber;
  String address;
  String role;
  String roleName;
  String password;
  String status;
  String r_create;// ignore: non_constant_identifier_names
  String r_edit; // ignore: non_constant_identifier_names
  String r_delete;// ignore: non_constant_identifier_names
  String r_view;// ignore: non_constant_identifier_names

  Employee({
    this.id,
    this.userName,
    this.email,
    this.contactNumber,
    this.address,
    this.role,
    this.roleName,
    this.r_create,// ignore: non_constant_identifier_names
    this.r_edit, // ignore: non_constant_identifier_names
    this.r_delete,// ignore: non_constant_identifier_names
    this.r_view,// ignore: non_constant_identifier_names
    this.password,
    this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      email: json['email'] as String,
      contactNumber: json['contact_number'] as String,
      address: json['address'] as String,
      role: json['role_id'] as String,
      roleName: json['role'] as String,
      r_create: json['r_edit'] as String,
      r_delete: json['r_delete'] as String,
      r_view: json['r_view'] as String,
      r_edit: json['r_edit'] as String,
      status: json['current_status'] as String,
      password: json['password'] as String,
    );
  }
}
