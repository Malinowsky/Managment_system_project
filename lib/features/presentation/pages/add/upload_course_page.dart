import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managment_system_project/features/presentation/models/course_model.dart'; // Adjust the import based on your project structure
import 'package:managment_system_project/features/presentation/widgets/info_gesture_detector.dart';
import 'package:managment_system_project/features/presentation/constants.dart'; // If you have common constants
import '../../../../global/common/toast.dart';
import '../../models/professor_model.dart'; // Adjust the import based on your project structure

class UploadCoursePage extends StatefulWidget {
  const UploadCoursePage({super.key});

  @override
  State<UploadCoursePage> createState() => _UploadCoursePageState();
}

class _UploadCoursePageState extends State<UploadCoursePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController creditsController = TextEditingController();
  TextEditingController professorIdController = TextEditingController();

  late String selectedProfessorId = 'placeholder';
  List<Professor> professorsList = [];
  bool hasDropdownBeenTouched = false;


  @override
  void initState() {
    super.initState();
    fetchProfessors();
  }

  Future fetchProfessors() async {
    var professorsCollection = FirebaseFirestore.instance.collection('professors');
    var querySnapshot = await professorsCollection.get();
    for (var doc in querySnapshot.docs) {
      var professor = Professor.fromJson(doc.data());
      setState(() {
        professorsList.add(professor);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create a Course"),
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
                    hintText: "Course Name",
                    controller: nameController,
                  ),
                  kHalfSizedBox,
                  InfoGestureDetector(
                    hintText: "Course Description",
                    controller: descriptionController,
                  ),
                  kHalfSizedBox,
                  InfoGestureDetector(
                    hintText: "Credits",
                    controller: creditsController,
                  ),
                  kHalfSizedBox,
                  // DropdownButtonFormField dla profesorów
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 9,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedProfessorId,
                      onChanged: (newValue) {
                        if (newValue != null && newValue != 'placeholder') {
                          setState(() {
                            selectedProfessorId = newValue;
                            hasDropdownBeenTouched = true; // Ustawienie, że dropdown został dotknięty
                          });
                        }
                      },
                      items: getDropdownItems(),
                      decoration: InputDecoration(
                        labelText: 'Select Professor',
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  GestureDetector(
                    onTap: () {
                      try {
                        if (selectedProfessorId != null && selectedProfessorId != 'placeholder') {
                          createCourse(
                            name: nameController.text,
                            description: descriptionController.text,
                            credits: int.parse(creditsController.text),
                            selectedProfessorId: selectedProfessorId, // Przekaż selectedProfessorId
                          );
                          showToast(message: "Course data successfully saved");
                        } else {
                          showToast(message: "Please select a professor");
                        }
                      } catch (e) {
                        print('Error during course creation: $e');
                        showToast(message: "Error saving course data");
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
                          "Save Course",
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

  List<DropdownMenuItem<String>> getDropdownItems() {
    List<DropdownMenuItem<String>> items = [];

    // Jeśli dropdown nie został dotknięty, dodaj opcję placeholder
    if (!hasDropdownBeenTouched) {
      items.add(
        DropdownMenuItem(
          value: 'placeholder',
          child: Text('Select a professor'),
        ),
      );
    }
    // Dodaj profesorów do listy
    items.addAll(professorsList.map<DropdownMenuItem<String>>((Professor professor) {
      return DropdownMenuItem<String>(
        value: professor.id,
        child: Text(professor.name + " " + professor.surname),
      );
    }).toList());

    return items;
  }

  Future createCourse({
    required String name,
    required String description,
    required int credits,
    required String selectedProfessorId,
  }) async {
    final docCourse = FirebaseFirestore.instance.collection('courses').doc();

    final course = Course(
      id: docCourse.id,
      name: name,
      description: description,
      credits: credits,
      professorId: selectedProfessorId,
    );
    final json = course.toJson();

    await docCourse.set(json);
  }
}
