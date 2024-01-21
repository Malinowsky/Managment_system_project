class Student {
  final String id;
  final String name;
  final String surname;
  final int age;
  final String address;
  final String classStudent;
  final String gender;
  final int mobile;

  Student({
    required this.id,
    required this.name,
    required this.surname,
    required this.age,
    required this.address,
    required this.classStudent,
    required this.gender,
    required this.mobile,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
        'age': age,
        'address': address,
        'classStudent': classStudent,
        'gender': gender,
        'mobile': mobile,
      };

  static Student fromJson(Map<String, dynamic> json) => Student(
        id: json['id'].toString(),
        name: json['name'].toString(),
        surname: json['surname'].toString(),
        age: json['age'],
        address: json['address'].toString(),
        classStudent: json['classStudent'].toString(),
        gender: json['gender'].toString(),
        mobile: json['mobile'],
      );
}
