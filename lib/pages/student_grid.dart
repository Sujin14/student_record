import 'package:flutter/material.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/delete_student.dart';
import 'package:student_record_web/pages/edit_student_page.dart';
import 'package:student_record_web/pages/student_details_page.dart';

class StudentCardGrid extends StatelessWidget {
  final Student student;
  const StudentCardGrid({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentDetailPage(student: student),
        ),
      ),
      child: LayoutBuilder( // Helps handle small screens
        builder: (context, constraints) {
          return SingleChildScrollView( // Prevents overflow
            child: Card(
              color: const Color.fromARGB(255, 57, 208, 135),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adapts height dynamically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circle Avatar
                    CircleAvatar(
                      radius: isSmallScreen ? 35 : 50,
                      backgroundImage: student.imageBytes != null
                          ? MemoryImage(student.imageBytes!)
                          : null,
                      child: student.imageBytes == null
                          ? Icon(Icons.person, size: isSmallScreen ? 35 : 50, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 10),

                    // Student Name
                    Text(
                      student.name,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),

                    // Age & Email (Stacked to Avoid Overflow)
                    Text(
                      'Age: ${student.age}',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Email: ${student.email}',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 16, color: Colors.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Row(
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
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
