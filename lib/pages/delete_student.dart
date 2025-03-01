import 'package:flutter/material.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/home_page.dart';

void showDeleteConfirmation(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Student Record'),
          content: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                student.delete();
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
}