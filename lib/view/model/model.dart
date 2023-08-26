
class UserModel{
  String? name;
  String? email;
  String? password;
  String? postcode;
  String? image;
  String? uid;

  UserModel({this.uid, this.name,this.email,this.password,this.postcode,this.image});

  factory UserModel.fromMap(map){
    return UserModel(
        name: map['name'],
        uid: map['uid'],
        email: map['email'],
        password: map['password'],
        postcode: map['postcode'],
        image: map['image']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'password':password,
      'postcode':postcode,
      'image':image,
      'uid':uid
    };
  }
}

