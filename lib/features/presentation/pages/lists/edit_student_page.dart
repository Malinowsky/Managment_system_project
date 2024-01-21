import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/student_model.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;

  const EditStudentPage({Key? key, required this.student}) : super(key: key);

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student.name);
    surnameController = TextEditingController(text: widget.student.surname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name:"),
            TextField(controller: nameController),
            SizedBox(height: 16),
            Text("Surname:"),
            TextField(controller: surnameController),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveChanges(context);
                  },
                  child: Text("Save Changes"),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteStudent(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveChanges(BuildContext context) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.student.id)
        .update({
      'name': nameController.text,
      'surname': surnameController.text,
      // Update other fields if needed
    })
        .then((_) {
      print("Document updated with ID: ${widget.student.id}");
      Navigator.pop(context);
    })
        .catchError((error) {
      print("Error updating document: $error");
    });
  }

  void deleteStudent(BuildContext context) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.student.id)
        .delete()
        .then((_) {
      print("Document deleted with ID: ${widget.student.id}");
      Navigator.pop(context);
    })
        .catchError((error) {
      print("Error deleting document: $error");
    });
  }
}
