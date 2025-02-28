import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_record_web/model/student_model.dart';


class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  File? _selectedImage;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to save the student details to Hive
  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        email: _emailController.text.trim(),
        imagePath: _selectedImage?.path ?? '',
      );
      Hive.box<Student>('students').add(newStudent);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _selectedImage != null ? FileImage(_selectedImage!) : null,
                  child: _selectedImage == null
                      ? const Icon(Icons.add_a_photo, size: 30, color: Colors.black54)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value != null &&
                        RegExp(r'^[A-Za-z\s]{1,50}$').hasMatch(value)
                    ? null
                    : 'Enter a valid name (letters only)',
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value != null &&
                        RegExp(r'^(1[0-9]|2[0-9]|3[0-9]|4[0-9]|50)$').hasMatch(value)
                    ? null
                    : 'Age must be between 10 and 50',
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value != null &&
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
                    ? null
                    : 'Enter a valid email address',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveStudent,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
