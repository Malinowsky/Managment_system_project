import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';
import 'package:managment_system_project/features/presentation/resources/add_data.dart';
import 'package:managment_system_project/features/presentation/widgets/form_container_widgets.dart';
import 'package:managment_system_project/features/presentation/widgets/info_gesture_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managment_system_project/features/presentation/widgets/utils.dart';
import 'package:managment_system_project/global/common/toast.dart';

class InfoPage extends StatefulWidget {
  InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String selectedValue = 'Class A';
  String selectedValuev2 = 'Female';
  String selectedValuev3 = 'Student';

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController studentIDController = TextEditingController();
  TextEditingController typeEmployeesController = TextEditingController();

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    String name = nameController.text;
    String surname = surnameController.text;
    String age = ageController.text;
    String address = addressController.text;
    String classStudent = classController.text;
    String gender = genderController.text;
    String mobile = mobileController.text;
    String studentID = studentIDController.text;
    String typeEmployee = typeEmployeesController.text;
    String resp = await StoreData().saveData(
        file: _image!,
        name: name,
        surname: surname,
        age: age,
        address: address,
        classStudent: classStudent,
        gender: gender,
        mobile: mobile,
        studentID: studentID,
        typeEmployee: typeEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("about you"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
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
                        width: MediaQuery.of(context).size.width / 2.5,
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
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedValuev2 = newValue;
                                  genderController.text = newValue;
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
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 88,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/image/info/usr.png"),
                                  radius: 88,
                                ),
                          Positioned(
                            child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(Icons.add_a_photo),
                            ),
                            bottom: -10,
                            left: 140,
                          ),
                        ],
                      ),
                      kHalfSizedBox,
                      Text(
                        "Student ID",
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.width / 9,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("32133213")),
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
                            value: selectedValuev3,
                            items: <String>[
                              'Student',
                              'Teacher',
                              'Other',
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
                                  selectedValuev3 = newValue;
                                  genderController.text = newValue;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Select type of employee',
                            ),
                          ),
                        ),
                      ),
                      kHalfSizedBox,
                      GestureDetector(
                        onTap: saveProfile,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.width / 9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Center(
                              child: Text(
                            "Upload",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
