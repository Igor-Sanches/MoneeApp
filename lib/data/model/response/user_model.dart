class UserModel{
  int totalSize;
  String limit;
  int offset;
  List<User> users;

  UserModel({
    this.totalSize ,
    this.limit ,
    this.offset ,
    this.users
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(User.fromJson(v));
      });
    }
  }
}

class User{
  String name;
  String phone;
  String cpf;
  String email;
  String password;
  String image;
  String zipcode;
  String city;
  String uf;
  String lastSession;
  String balance;
  String refCode;
  String balanceWithdrawn;
  String balanceReceived;
  bool onlineRanking;

  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'phone':phone,
      'cpf':cpf,
      'email':email,
      'image':image,
      'zipcode':zipcode,
      'city':city,
      'uf':uf,
      'last_session':lastSession,
      'balance':balance,
      'ref_code':refCode,
      'balance_withdrawn':balanceWithdrawn,
      'balance_received':balanceReceived,
      'online_ranking':onlineRanking,
    };
  }

  User.fromJson(json) {
    name = json['name'];
    phone = json['phone'];
    cpf = json['cpf'];
    email = json['email'];
    image = json['image'];
    zipcode = json['zipcode'];
    city = json['city'];
    uf = json['uf'];
    lastSession = json['last_session'];
    balance = json['balance'].toString();
    refCode = json['ref_code'];
    balanceWithdrawn = json['balance_withdrawn'].toString();
    balanceReceived = json['balance_received'].toString();
    onlineRanking = json['online_ranking'];
  }

}