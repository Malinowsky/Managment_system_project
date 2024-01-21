import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/student_model.dart';
import 'edit_student_page.dart';

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({Key? key}) : super(key: key);

  @override
  _StudentsListPageState createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  String selectedGroup = 'All Groups';
  late Future<List<Student>> studentsFuture;
  List<String> groupsList = ['All Groups'];

  @override
  void initState() {
    super.initState();
    studentsFuture = fetchData(selectedGroup);
    fetchGroups();
  }

  Future<List<Student>> fetchData(String groupName) async {
    if (groupName == 'All Groups') {
      return readAllStudents();
    } else {
      return readStudentsByGroup(groupName);
    }
  }

  Future<List<Student>> readAllStudents() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('students').get();
    return querySnapshot.docs
        .map((doc) => Student.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Student>> readStudentsByGroup(String groupName) async {
    // Pobierz dokument dla wybranej grupy na podstawie jej nazwy
    var groupQuerySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('name', isEqualTo: groupName)
        .get();

    if (groupQuerySnapshot.docs.isEmpty) {
      // Jeśli nie ma grupy o tej nazwie, zwróć pustą listę
      return [];
    }

    // Pobierz listę identyfikatorów studentów z grupy
    List<dynamic> studentIds = groupQuerySnapshot.docs.first.get('studentIds');

    // Pobierz wszystkich studentów, których identyfikatory znajdują się na liście studentIds
    List<Student> studentsInGroup = [];
    for (var studentId in studentIds) {
      var studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();
      if (studentSnapshot.exists) {
        studentsInGroup.add(
            Student.fromJson(studentSnapshot.data() as Map<String, dynamic>));
      }
    }

    return studentsInGroup;
  }

  Future fetchGroups() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('groups').get();
    List<String> fetchedGroupsList = ['All Groups'];
    for (var doc in querySnapshot.docs) {
      fetchedGroupsList.add(doc.data()['name']);
    }

    setState(() {
      groupsList = fetchedGroupsList;
    });

    print(
        groupsList); // Dodaj to, aby zobaczyć, czy grupy są poprawnie pobierane
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Students List"),
      ),
      body: Column(
        children: [
          buildFilterButton(),
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Something went wrong! ${snapshot.error}");
                } else if (snapshot.hasData) {
                  final students = snapshot.data!;
                  return ListView(
                    children: students
                        .map((student) => buildStudent(context, student))
                        .toList(),
                  );
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Filter by Group:'),
          SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedGroup,
            onChanged: (String? newValue) {
              setState(() {
                selectedGroup = newValue!;
                studentsFuture = fetchData(selectedGroup);
              });
            },
            items: groupsList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildStudent(BuildContext context, Student student) => ListTile(
        leading: Text(student.classStudent),
        title: Text(student.name),
        subtitle: Text(student.surname),
        onTap: () {
          navigateToEditPage(context, student);
        },
      );

  void navigateToEditPage(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentPage(student: student),
      ),
    );
  }
}
