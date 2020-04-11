
class Employee {
  String id;
  String roleName;
  String userName;
  String email;
  String contactNumber;
  String address;
  String role;
  String password;
  String status;

  Employee({
    this.id,
    this.userName,
    this.email,
    this.contactNumber,
    this.address,
    this.role,
    this.password,
    this.status,
    this.roleName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      email: json['email'] as String,
      contactNumber: json['contact_number'] as String,
      address: json['address'] as String,
      role: json['role_id'] as String,
      roleName: json['role_name'] as String,
      status: json['current_status'] as String,
      password: json['password'] as String,
    );
  }
}

//
//class RolesList {
//  final List<Role> roles;
//
//  RolesList({
//    this.roles,
//  });
//
//  factory RolesList.fromJson(List<dynamic> parsedJson) {
//
//    List<Role> roles = new List<Role>();
//    roles = parsedJson.map((i)=>Role.fromJson(i)).toList();
//
//    return new RolesList(
//        roles: roles
//    );
//  }
//}
//
//
//
//class Role{
//  final String id;
//  final String name;
//  final String title;
//
//  Role({
//    this.id,
//    this.name,
//    this.title
//  }) ;
//
//  factory Role.fromJson(Map<String, dynamic> json){
//    return new Role(
//      id: json['id'].toString(),
//      name: json['name'],
//      title: json['title'],
//    );
//  }
//  Map<String, dynamic> toJson() => {
//    "id": id,
//    "title": title,
//    "name": name,
//  };
//
//}
//Role postFromJson(String str) {
//  final jsonData = json.decode(str);
//  return Role.fromJson(jsonData);
//}
//
//String postToJson(Role data) {
//  final dyn = data.toJson();
//  return json.encode(dyn);
//}
//
//
//List<Role> allPostsFromJson(String str) {
//  final jsonData = json.decode(str);
//  return new List<Role>.from(jsonData.map((x) => Role.fromJson(x)));
//}
//
//String allPostsToJson(List<Role> data) {
//  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
//  return json.encode(dyn);
//}
class RoleList {
  String name;
  String id;

  RoleList({this.id, this.name});

  factory RoleList.formJson(Map<String, dynamic> json) {
    return RoleList(id: json['id'], name: json['name']);
  }
}
