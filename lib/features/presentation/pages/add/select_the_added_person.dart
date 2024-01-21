import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';
import 'package:managment_system_project/features/presentation/pages/add/student_course_page.dart';
import 'package:managment_system_project/features/presentation/pages/add/student_group_page.dart';
import 'package:managment_system_project/features/presentation/pages/add/upload_course_page.dart';
import 'package:managment_system_project/features/presentation/pages/add/upload_professor_page.dart';
import 'package:managment_system_project/features/presentation/pages/add/upload_student_page.dart';

class SelectTheAddedPerson extends StatefulWidget {
  const SelectTheAddedPerson({super.key});

  @override
  State<SelectTheAddedPerson> createState() => _SelectTheAddedPersonState();
}

class _SelectTheAddedPersonState extends State<SelectTheAddedPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAddButton(context, UploadProfessorPage(), "Add professor"),
            sizedBox,
            buildAddButton(context, UploadStudentPage(), "Add student"),
            sizedBox,
            buildAddButton(context, UploadCoursePage(), "Add course"),
            sizedBox,
            buildAddButton(context, StudentGroupPage(), "Add student to the group"),
            sizedBox,
            buildAddButton(context, StudentCoursesPage(), "Add group to the course"),
          ],
        ),
      ),);
  }

  GestureDetector buildAddButton(BuildContext context, Widget page, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                page));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.width / 5.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

}
