import 'package:flutter/material.dart';

import 'AddGradePage.dart';

class SelectCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wybierz Przedmiot"),
      ),
      body: Center(
        // Tutaj zaimplementuj logikę wyboru przedmiotu i profesora
        // Możesz użyć np. dropdown menu lub listy
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Przejdź do ekranu dodawania oceny
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGradePage()),
          );
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
