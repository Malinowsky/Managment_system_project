import 'package:flutter/material.dart';

class AddGradePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj Ocenę"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Ocena',
                // Dodaj więcej dekoracji i walidacji
              ),
            ),
            // Dodaj więcej pól formularza
            ElevatedButton(
              onPressed: () {
                // Logika przesyłania oceny
              },
              child: Text('Zapisz Ocenę'),
            ),
          ],
        ),
      ),
    );
  }
}
