import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/edit_student_page.dart';


class StudentDetailPage extends StatelessWidget {
  final Student student;
  const StudentDetailPage({required this.student, super.key});

  void _deleteStudent(BuildContext context) {
    student.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteStudent(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditStudentPage(student: student)),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: student.imagePath.isNotEmpty ? FileImage(File(student.imagePath)) : null,
                child: student.imagePath.isEmpty ? const Icon(Icons.person, size: 60) : null,
              ),
              const SizedBox(height: 16),
              Text('Name: ${student.name}', style: const TextStyle(fontSize: 20)),
              Text('Age: ${student.age}', style: const TextStyle(fontSize: 20)),
              Text('Email: ${student.email}', style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
