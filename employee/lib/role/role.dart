class Roles {
  String id;
  String name;
  String rCreate;
  String rDelete;
  String rView;
  String rEdit;

  Roles({
    this.id,
    this.name,
    this.rCreate,
    this.rDelete,
    this.rEdit,
    this.rView,
  });

  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(
      id: json['id'] as String,
      name: json['name'] as String,
      rCreate: json['r_create'] as String,
      rDelete: json['r_delete'] as String,
      rEdit: json['r_edit'] as String,
      rView: json['r_view'] as String,
    );
  }
}
