import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:managment_system_project/features/presentation/constants.dart';
import 'package:managment_system_project/features/presentation/pages/info_page.dart';
import 'package:managment_system_project/features/presentation/pages/login_page.dart';
import 'package:managment_system_project/features/presentation/widgets/student_data.dart';
import 'package:managment_system_project/global/common/toast.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("home"),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StudentName(studentName: "Artur"),
                          kHalfSizedBox,
                          StudentClass(studentClass: "Class X-II A | roll no 12"),
                          kHalfSizedBox,
                          StudentClass(studentClass: "2023-2024")
                        ],
                      ),
                      kHalfSizedBox,
                      StudentPicture(onPress: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => new InfoPage())
                        );
                      },picAddress: "assets/image/student/person.jpg",)
                    ],
                  ),
                  sizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StudentDataCard(title: "Attendance", value: "90.02%", onPress: (){}),
                      StudentDataCard(title: "Fees Due", value: "600\$", onPress: (){}),
                    ],
                  )
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
                    padding: EdgeInsets.only(top:15),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/timetable.svg', title: "Time table"),
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/teacher.svg', title: "Professors"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/user.svg', title: "Students"),
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/grade.svg', title: "Course/Grades"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/chat.svg', title: "Live chat"),
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/pro.svg', title: "Assignments"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/door.svg', title: "Sign out"),
                          HomeCard(onPress: (){}, icon: 'assets/image/home_icon/settings.svg', title: "Settings"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required this.onPress, required this.icon, required this.title});
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

