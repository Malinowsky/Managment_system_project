import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';
import 'package:managment_system_project/features/presentation/widgets/info_gesture_detector.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../global/common/toast.dart';
import '../../models/student_model.dart';

class UploadStudentPage extends StatefulWidget {
  const UploadStudentPage({super.key});

  @override
  State<UploadStudentPage> createState() => _UploadStudentPageState();
}

class _UploadStudentPageState extends State<UploadStudentPage> {
  String selectedValue = 'Class A';
  String selectedValuev2 = 'Female';
  String selectedValuev3 = 'Student';
  String selectedValuev4 = 'Noun';

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  late String generatedStudentID;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create a student"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoGestureDetector(
                    hintText: "Name",
                    controller: nameController,
                  ),
                  kHalfSizedBox,
                  InfoGestureDetector(
                    hintText: "Surname",
                    controller: surnameController,
                  ),
                  kHalfSizedBox,
                  InfoGestureDetector(
                    hintText: "Age",
                    controller: ageController,
                  ),
                  kHalfSizedBox,
                  InfoGestureDetector(
                    hintText: "Address",
                    controller: addressController,
                  ),
                  kHalfSizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        value: selectedValue,
                        items: <String>[
                          'Class A',
                          'Class B',
                          'Class C',
                          'Class D'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:
                            Text(value, style: TextStyle(fontSize: 18)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedValue = newValue;
                              classController.text = newValue;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Class',
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        value: selectedValuev2,
                        items: <String>[
                          'Female',
                          'Male',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:
                            Text(value, style: TextStyle(fontSize: 18)),
                          );
                        }).toList(),
                        onChanged: (String? newValuev2) {
                          if (newValuev2 != null) {
                            setState(() {
                              selectedValuev2 = newValuev2;
                              genderController.text = newValuev2;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Select gender',
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  InfoGestureDetector(
                    hintText: "Mobile ID",
                    controller: mobileController,
                  ),
                  kHalfSizedBox,
                  GestureDetector(
                    onTap: () {
                      try {
                        createStudent(
                          name: nameController.text,
                          surname: surnameController.text,
                          age: int.parse(ageController.text),
                          address: addressController.text,
                          classStudent: classController.text,
                          gender: genderController.text,
                          mobile: int.parse(mobileController.text),
                        );
                        showToast(message: "Data is successfully saved");
                      } catch (e) {
                        print('Error during create a profile: $e');
                        showToast(message: "Data is unsuccessfully saved");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Sava data",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  GestureDetector(
                    onTap: () {
                      try {
                        updateStudent(
                          name: nameController.text,
                          surname: surnameController.text,
                          age: int.parse(ageController.text),
                          address: addressController.text,
                          classStudent: classController.text,
                          gender: genderController.text,
                          mobile: int.parse(mobileController.text),
                        );
                        showToast(message: "Data is successfully updated");
                      } catch (e) {
                        print('Error during create a profile: $e');
                        showToast(message: "Data is unsuccessfully saved");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Update data",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future createStudent({
    required String name,
    required String surname,
    required int age,
    required String address,
    required String classStudent,
    required String gender,
    required int mobile,
  }) async {
    final docStudent = FirebaseFirestore.instance.collection('students').doc();

    final student = Student(
      id: docStudent.id,
      name: name,
      surname: surname,
      age: age,
      address: address,
      classStudent: classStudent,
      gender: gender,
      mobile: mobile,
    );
    final json = student.toJson();

    await docStudent.set(json);
  }

  Future updateStudent({
    required String name,
    required String surname,
    required int age,
    required String address,
    required String classStudent,
    required String gender,
    required int mobile,
  }) async {
    final docStudent = FirebaseFirestore.instance.collection('students').doc();

    final student = Student(
      id: docStudent.id,
      name: name,
      surname: surname,
      age: age,
      address: address,
      classStudent: classStudent,
      gender: gender,
      mobile: mobile,
    );
    final json = student.toJson();

    await docStudent.update(json);
  }
}
