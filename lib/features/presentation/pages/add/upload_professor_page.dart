import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';
import 'package:managment_system_project/features/presentation/models/professor_model.dart';
import 'package:managment_system_project/features/presentation/widgets/info_gesture_detector.dart';

import '../../../../global/common/toast.dart';
import '../../models/student_model.dart';

class UploadProfessorPage extends StatefulWidget {
  const UploadProfessorPage({super.key});

  @override
  State<UploadProfessorPage> createState() => _UploadProfessorPageState();
}

class _UploadProfessorPageState extends State<UploadProfessorPage> {
  String selectedValue = 'Class A';
  String selectedValuev2 = 'Female';
  String selectedValuev3 = 'Student';
  String selectedValuev4 = 'Noun';

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController typeClass = TextEditingController();


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
        title: const Text("Create a professor"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
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
                  // GENDER
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
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
                  //MOBILE
                  InfoGestureDetector(
                    hintText: "Mobile ID",
                    controller: mobileController,
                  ),
                  kHalfSizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        value: selectedValuev4,
                        items: <String>[
                          'Noun',
                          'Math',
                          'Biology',
                          'English',
                          'Mobile processing',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String valuev3) {
                          return DropdownMenuItem<String>(
                            value: valuev3,
                            child: Text(valuev3,
                                style: TextStyle(fontSize: 15)),
                          );
                        }).toList(),
                        onChanged: (String? newValuev3) {
                          if (newValuev3 != null) {
                            setState(() {
                              selectedValuev3 = newValuev3;
                              typeClass.text = newValuev3;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Select type of class',
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  GestureDetector(
                    onTap: () {
                      try {
                        createProfessor(
                          name: nameController.text,
                          surname: surnameController.text,
                          age: int.parse(ageController.text),
                          address: addressController.text,
                          typeClass: typeClass.text,
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
                        updateProfessor(
                          name: nameController.text,
                          surname: surnameController.text,
                          age: int.parse(ageController.text),
                          address: addressController.text,
                          typeClass: typeClass.text,
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

  Future createProfessor({
    required String name,
    required String surname,
    required int age,
    required String address,
    required String typeClass,
    required String gender,
    required int mobile,
  }) async {
    final docProfessor = FirebaseFirestore.instance.collection('professors').doc();

    final student = Professor(
      id: docProfessor.id,
      name: name,
      surname: surname,
      age: age,
      address: address,
      typeClass: typeClass,
      gender: gender,
      mobile: mobile,
    );
    final json = student.toJson();

    await docProfessor.set(json);
  }

  Future updateProfessor({
    required String name,
    required String surname,
    required int age,
    required String address,
    required String typeClass,
    required String gender,
    required int mobile,
  }) async {
    final docStudent = FirebaseFirestore.instance.collection('students').doc();

    final professor = Professor(
      id: docStudent.id,
      name: name,
      surname: surname,
      age: age,
      address: address,
      typeClass: typeClass,
      gender: gender,
      mobile: mobile,
    );
    final json = professor.toJson();

    await docStudent.update(json);
  }
}
