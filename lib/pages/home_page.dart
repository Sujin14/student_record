import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/add_student_page.dart';
import 'package:student_record_web/pages/student_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    final studentsBox = Hive.box<Student>('students');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Student Details'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view, color: Colors.white),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Student>>(
        valueListenable: studentsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No student details added.'));
          }

          final students = box.values.toList();

          return isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: students.length,
                  itemBuilder: (context, index) => StudentCard(student: students[index]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: students.length,
                  itemBuilder: (context, index) => StudentCard(student: students[index]),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddStudentPage()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
  ImageProvider? imageProvider;

if (student.imageBytes != null && student.imageBytes!.isNotEmpty) {
  imageProvider = MemoryImage(student.imageBytes!); // Works for both Web & Android
}


    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: student.imageBytes != null ? MemoryImage(student.imageBytes!) : null,
          child: student.imageBytes == null ? const Icon(Icons.person) : null,
      ),

        title: Text(student.name),
        subtitle: Text('Age: ${student.age}\nEmail: ${student.email}'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentDetailPage(student: student)),
        ),
      ),
    );
  }
}
