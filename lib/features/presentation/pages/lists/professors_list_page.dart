import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/professor_model.dart';
import 'edit_professor_page.dart';

class ProfessorsListPage extends StatefulWidget {
  const ProfessorsListPage({super.key});

  @override
  State<ProfessorsListPage> createState() => _ProfessorsListPageState();
}

class _ProfessorsListPageState extends State<ProfessorsListPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Professor>> readAllProfessors() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('professors')
        .get();

    return querySnapshot.docs
        .map((doc) => Professor.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Professors List"),
      ),
      body: FutureBuilder<List<Professor>>(
        future: readAllProfessors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            final professors = snapshot.data!;
            return ListView(
              children: professors
                  .map((professor) => buildProfessor(context, professor))
                  .toList(),
            );
          } else {
            return Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }

  Widget buildProfessor(BuildContext context, Professor professor) => ListTile(
    leading: Text(professor.typeClass),
    title: Text(professor.name),
    subtitle: Text(professor.surname),
    onTap: () {
      navigateToEditPage(context, professor);
    },
  );

  navigateToEditPage(BuildContext context, Professor professor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfessorPage(professor: professor),
      ),
    );
  }
}
