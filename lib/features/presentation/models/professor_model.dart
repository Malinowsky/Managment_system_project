class Professor {
  final String id;
  final String name;
  final String surname;
  final int age;
  final String address;
  final String gender;
  final int mobile;
  final String typeClass;

  Professor({
    required this.id,
    required this.name,
    required this.surname,
    required this.age,
    required this.address,
    required this.gender,
    required this.mobile,
    required this.typeClass,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'surname': surname,
    'age': age,
    'address': address,
    'gender': gender,
    'mobile': mobile,
    'typeClass' : typeClass,
  };

  static Professor fromJson(Map<String, dynamic> json) => Professor(
      id: json['id'].toString(),
      name: json['name'].toString(),
      surname: json['surname'].toString(),
      age: json['age'],
      address: json['address'].toString(),
      gender: json['gender'].toString(),
      mobile: json['mobile'],
      typeClass: json['typeClass'],
  );
}
