import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_record_web/model/student_model.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;
  const EditStudentPage({super.key, required this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _ageController = TextEditingController(text: widget.student.age.toString());
    _emailController = TextEditingController(text: widget.student.email);
    _imageBytes = widget.student.imageBytes; // Load existing image bytes
  }

  /// Pick an image and store it as bytes
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes(); // Read image as bytes
      setState(() => _imageBytes = bytes);
    }
  }

  /// Save the updated student details
  void _updateStudent() {
    if (_formKey.currentState!.validate()) {
      widget.student
        ..name = _nameController.text.trim()
        ..age = int.parse(_ageController.text.trim())
        ..email = _emailController.text.trim()
        ..imageBytes = _imageBytes; // Store image as bytes

      widget.student.save();
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
      appBar: AppBar(title: const Text('Edit Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Picture Selector
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                  child: _imageBytes == null ? const Icon(Icons.add_a_photo, size: 30) : null,
                ),
              ),
              const SizedBox(height: 16),

              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value != null && RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)
                    ? null
                    : 'Enter a valid name (letters only)',
              ),
              const SizedBox(height: 10),

              // Age Input
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value != null && RegExp(r'^(1[0-9]|2[0-9]|3[0-9]|4[0-9]|50)$').hasMatch(value)
                    ? null
                    : 'Age must be between 10 and 50',
              ),
              const SizedBox(height: 10),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value != null && RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
                    ? null
                    : 'Enter a valid email address',
              ),
              const SizedBox(height: 20),

              // Update Button
              ElevatedButton(
                onPressed: _updateStudent,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
