import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String email;

  @HiveField(3)
  Uint8List? imageBytes;
  Student({
    required this.name,
    required this.age,
    required this.email,
    this.imageBytes,
  });
}
