import 'package:flutter/material.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/delete_student.dart';
import 'package:student_record_web/pages/edit_student_page.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;
  const StudentDetailPage({required this.student, super.key});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  late Student student;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  void deleteStudent(BuildContext context) {
    student.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (student.imageBytes != null && student.imageBytes!.isNotEmpty) {
      imageProvider = MemoryImage(student.imageBytes!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 215, 17),
        title: const Text('Student Details'),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 40),
              onPressed: () {
                showDeleteConfirmation(context, student);
              },
            ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedStudent = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditStudentPage(student: student)),
              );

              if (updatedStudent != null) {
                setState(() {
                  student = updatedStudent;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 11, 134, 234), const Color.fromARGB(255, 11, 215, 17)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: imageProvider,
                  child: imageProvider == null ? const Icon(Icons.person, size: 60) : null,
                ),
                const SizedBox(height: 16),
                Text('Name: ${student.name}', style: const TextStyle(fontSize: 20)),
                Text('Age: ${student.age}', style: const TextStyle(fontSize: 20)),
                Text('Email: ${student.email}', style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
