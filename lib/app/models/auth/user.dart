class User {
  String? id;
  String? name;
  String? email;
  //String? password;
  String? phone;
  String? avatar;
  String? shortBio;
  bool? isDeleted;
  String? createdAt;
  int? postCount;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    //this.password,
    this.phone,
    this.avatar,
    this.shortBio,
    this.isDeleted,
    this.createdAt,
    this.postCount,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    var user = json['user'];

    id = user['_id'];
    name = user['name'] ?? "";
    email = user['email'] ?? "";
    phone = user['phone'] ?? "";
    avatar = user['avatar'] ?? "";
    shortBio = user['shortBio'] ?? "";
    isDeleted = user['isDeleted'] ?? false;
    createdAt = user['createdAt'] ?? "";
    postCount = user['postCount'] ?? 0;

    token = json['token'] ?? "";
  }
}
//_id name email password phone avatar shortBio isDeleted createdAt