import 'package:flutter/material.dart';

class StudentName extends StatelessWidget {
  const StudentName({super.key, required this.studentName});

  final String studentName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Hi",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w200,
              ),
        ),
        Text(
          studentName,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class StudentClass extends StatelessWidget {
  const StudentClass({super.key, required this.studentClass});

  final String studentClass;

  @override
  Widget build(BuildContext context) {
    return Text(
      studentClass,
      style: Theme.of(context).textTheme.subtitle2!.copyWith(
            fontSize: 12.0,
          ),
    );
  }
}

class StudentYear extends StatelessWidget {
  const StudentYear({super.key, required this.studentYear});

  final String studentYear;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(
          studentYear,
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w200),
        ),
      ),
    );
  }
}

class StudentPicture extends StatelessWidget {
  const StudentPicture({super.key, required this.picAddress, required this.onPress});

  final String picAddress;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: CircleAvatar(
        maxRadius: 50,
        minRadius: 50,
        backgroundColor: Colors.amber,
        backgroundImage:
        AssetImage(picAddress),
      ),
    );
  }
}

class StudentDataCard extends StatelessWidget {
  const StudentDataCard({super.key, required this.title, required this.value, required this.onPress});

  final String title;
  final String value;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 6,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}


