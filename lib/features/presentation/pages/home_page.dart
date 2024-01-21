import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';
import 'package:managment_system_project/features/presentation/pages/lists/professors_list_page.dart';
import 'package:managment_system_project/features/presentation/pages/lists/students_list_page.dart';
import 'package:managment_system_project/features/presentation/pages/timetable_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/student_model.dart';
import 'add/select_the_added_person.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("home"),
        ),
        body: StreamBuilder<Object>(
            stream: readStudents(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Something went wrong! ${snapshot.error}");
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                final List<Student> students =
                    snapshot.data as List<Student>? ?? [];
                if (students.isEmpty) {
                  return Text("No students found.");
                }
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width/2.5,
                                  child: Text(
                                    'Add person',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              kHalfSizedBox,
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber, // Kolor amber
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new SelectTheAddedPerson()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          child: ListView(
                            padding: EdgeInsets.only(top: 15),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  HomeCard(
                                    onPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TimeTablePage(),
                                        ),
                                      );
                                    },
                                    icon: 'assets/image/home_icon/timetable.svg',
                                    title: "Time table",
                                  ),

                                  HomeCard(
                                      onPress: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new ProfessorsListPage()));
                                      },
                                      icon:
                                          'assets/image/home_icon/teacher.svg',
                                      title: "Professors"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  HomeCard(
                                      onPress: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new StudentsListPage()));
                                      },
                                      icon: 'assets/image/home_icon/user.svg',
                                      title: "Students"),
                                  HomeCard(
                                      onPress: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                new StudentsListPage()));
                                      },
                                      icon: 'assets/image/home_icon/grade.svg',
                                      title: "Course/Grades"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  HomeCard(
                                      onPress: () {},
                                      icon: 'assets/image/home_icon/chat.svg',
                                      title: "Live chat"),
                                  HomeCard(
                                      onPress: () {},
                                      icon: 'assets/image/home_icon/pro.svg',
                                      title: "Assignments"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  HomeCard(
                                      onPress: () {},
                                      icon: 'assets/image/home_icon/door.svg',
                                      title: "Sign out"),
                                  HomeCard(
                                      onPress: () {},
                                      icon:
                                          'assets/image/home_icon/settings.svg',
                                      title: "Settings"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return SelectTheAddedPerson();
              }
            }));
  }

  Stream<List<Student>> readStudents() => FirebaseFirestore.instance
      .collection('students')
      .snapshots()
      .map((snapshots) =>
          snapshots.docs.map((doc) => Student.fromJson(doc.data())).toList());
}

class HomeCard extends StatelessWidget {
  const HomeCard(
      {super.key,
      required this.onPress,
      required this.icon,
      required this.title});

  final VoidCallback onPress;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 25),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 5.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 60,
              width: 60,
              color: Colors.black,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
