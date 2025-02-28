import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record_web/model/student_model.dart';
import 'package:student_record_web/pages/add_student_page.dart';
import 'package:student_record_web/pages/student_grid.dart';
import 'package:student_record_web/pages/student_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final studentsBox = Hive.box<Student>('students');

    return Scaffold(
      appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 79, 20, 152),
  title: Row(
    children: [
      const Text(
        'Student Details',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      const Spacer(), // Push search bar to the right
      if (isSearching)
        Container(
          width: 250, // Width of the search bar
          height: 40, // Height of the search bar
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
            border: Border.all(color: Colors.white70, width: 2), // Border
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none, // Remove default border
              contentPadding: EdgeInsets.symmetric(horizontal: 10), // Padding inside
            ),
          ),
        ),
    ],
  ),
  actions: [
    IconButton(
      icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
      onPressed: () {
        setState(() {
          if (isSearching) {
            searchQuery = '';
            searchController.clear();
          }
          isSearching = !isSearching;
        });
      },
    ),
    IconButton(
      icon: Icon(isGridView ? Icons.list : Icons.grid_view, color: Colors.white),
      onPressed: () => setState(() => isGridView = !isGridView),
    ),
  ],
),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 79, 20, 152), Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ValueListenableBuilder<Box<Student>>(
          valueListenable: studentsBox.listenable(),
          builder: (context, box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Text('No student details added.', style: TextStyle(color: Colors.white)),
              );
            }

            // Filtering students based on search query
            final students = box.values.where((student) {
              return student.name.toLowerCase().contains(searchQuery);
            }).toList();

            if (students.isEmpty) {
              return const Center(
                child: Text(
                  'No matching results.',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }

            return isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.8,
                    ),
                    itemCount: students.length,
                    itemBuilder: (context, index) => StudentCardGrid(student: students[index]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: students.length,
                    itemBuilder: (context, index) => StudentCard(student: students[index]),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 7, 67, 170),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddStudentPage()),
        ),
        child: const Icon(Icons.add, color: Colors.deepPurple, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
