import 'package:flutter/material.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/delete_student.dart';
import 'package:student_record_web/pages/edit_student_page.dart';
import 'package:student_record_web/pages/student_details_page.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.greenAccent,
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: student.imageBytes != null
              ? MemoryImage(student.imageBytes!)
              : null,
          child: student.imageBytes == null ? const Icon(Icons.person) : null,
        ),
        title: Text(
          student.name,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        subtitle: Text('Age: ${student.age}\nEmail: ${student.email}'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentDetailPage(student: student)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black, size: 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditStudentPage(student: student),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 40),
              onPressed: () {
                showDeleteConfirmation(context, student);
              },
            ),
          ],
        ),
      ),
    );
  }
}
