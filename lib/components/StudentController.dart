import 'package:get/get.dart';

class StudentController extends GetxController {
  Map<String, dynamic> student = {};
  void setStudent(Map<String, dynamic> student) {
    this.student = student;
    update();
  }

  Map<String, dynamic> getStudentData() {
    return student;
  }
}
