import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';

import '../../../../global/common/toast.dart';
import '../../models/group_model.dart';
import '../../models/student_model.dart';
import '../../widgets/info_gesture_detector.dart';

class StudentGroupPage extends StatefulWidget {
  const StudentGroupPage({super.key});

  @override
  State<StudentGroupPage> createState() => _StudentGroupPageState();
}

class _StudentGroupPageState extends State<StudentGroupPage> {
  TextEditingController nameOfGroup = TextEditingController();

  String? selectedGroupId;
  String? selectedStudentId;
  List<ClassGroup> groupsList = [];
  List<Student> studentsList = [];

  @override
  void initState() {
    super.initState();
    selectedGroupId = null; // Ustawienie początkowej wartości na null
    fetchStudents();
    fetchGroups();
  }

  Future fetchGroups() async {
    var groupsCollection = FirebaseFirestore.instance.collection('groups');
    var querySnapshot = await groupsCollection.get();
    List<ClassGroup> fetchedGroupsList = [];
    for (var doc in querySnapshot.docs) {
      var group = ClassGroup.fromJson(doc.data());
      fetchedGroupsList.add(group);
    }

    setState(() {
      groupsList = fetchedGroupsList;
      if (groupsList.isNotEmpty &&
          !groupsList.any((group) => group.id == selectedGroupId)) {
        selectedGroupId = null; // Resetuj, jeśli wybrana grupa nie istnieje
      }
    });
  }

  Future fetchStudents() async {
    var studentsCollection = FirebaseFirestore.instance.collection('students');
    var querySnapshot = await studentsCollection.get();
    for (var doc in querySnapshot.docs) {
      var student = Student.fromJson(doc.data());
      setState(() {
        studentsList.add(student);
      });
    }
  }

  List<Student> getFilteredStudents() {
    if (selectedGroupId == null) {
      return studentsList;
    } else {
      var studentsInGroup = groupsList
          .firstWhere((group) => group.id == selectedGroupId)
          .studentIds;
      return studentsList
          .where((student) => !studentsInGroup.contains(student.id))
          .toList();
    }
  }

  Future<void> addStudentToGroup(String studentId, String groupId) async {
    DocumentReference groupRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(groupRef);

      if (!snapshot.exists) {
        throw Exception("Group not found!");
      }

      List<String> students = List<String>.from(snapshot['studentIds'] ?? []);

      if (!students.contains(studentId)) {
        students.add(studentId);
        transaction.update(groupRef, {'studentIds': students});
      }
    }).then((value) {
      fetchGroups().then((_) {
        setState(() {
          // Resetuj wybrane wartości
          selectedGroupId = null;
          selectedStudentId = null;
        });
      });
    }).catchError((error) {
      print("Failed to add student to group: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Assign Student to Course"),
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
                    hintText: "Name of Group",
                    controller: nameOfGroup,
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      try {
                        createGroup(name: nameOfGroup.text);
                        showToast(message: "Data is successfully updated");
                      } catch (e) {
                        print('Error during create a profile: $e');
                        showToast(message: "Data is unsuccessfully saved");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Create a group",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  sizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      key: ValueKey(selectedGroupId),
                      value: selectedGroupId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedGroupId = newValue;
                        });
                      },
                      items: groupsList.map<DropdownMenuItem<String>>(
                          (ClassGroup classGroup) {
                        return DropdownMenuItem<String>(
                          value: classGroup.id,
                          child: Text(classGroup.name), // Wyświetl nazwę grupy
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Group',
                      ),
                    ),
                  ),
                  sizedBox,
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      key: ValueKey(selectedStudentId),
                      value: selectedStudentId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedStudentId = newValue;
                        });
                      },
                      items: getFilteredStudents()
                          .map<DropdownMenuItem<String>>((Student student) {
                        return DropdownMenuItem<String>(
                          value: student.id,
                          child: Text(student.name + " " + student.surname),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Student',
                      ),
                    ),
                  ),
                  sizedBox,
                  GestureDetector(
                    onTap: () {
                      if (selectedStudentId != null &&
                          selectedGroupId != null) {
                        try {
                          addStudentToGroup(
                              selectedStudentId!, selectedGroupId!);
                          showToast(
                              message:
                                  "Student added to the group successfully");
                        } catch (e) {
                          print('Error during adding student to group: $e');
                          showToast(
                              message: "Error adding student to the group");
                        }
                      } else {
                        showToast(
                            message:
                                "Please select both a student and a group");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Add student to group",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future createGroup({
    required String name,
  }) async {
    final docGroup = FirebaseFirestore.instance.collection('groups').doc();

    final group = ClassGroup(
      id: docGroup.id,
      name: name,
    );
    final json = group.toJson();

    await docGroup.set(json);
  }
}
