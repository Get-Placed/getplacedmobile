import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  bool statusName = false,
      statusPhone = false,
      statusEmail = false,
      statusAEmail = false,
      statusDOB = false,
      statusCGPA = false,
      statusYOC = false,
      statusUserName = false,
      oldPassword = false,
      newPassword = false,
      conPassword = false;

  void updatePass() {
    statusUserName = !statusUserName;
    oldPassword = !oldPassword;
    newPassword = !newPassword;
    conPassword = !conPassword;

    update();
  }

  void updateEditName() {
    statusName = !statusName;
    update();
    print(statusName);
  }

  void updateEditPhone() {
    statusPhone = !statusPhone;
    update();
    print("statusPhone : $statusPhone");
  }

  void updateEditEmail() {
    statusEmail = !statusEmail;
    update();
    print("statusEmail : $statusEmail");
  }

  void updateEditAEmail() {
    statusAEmail = !statusAEmail;
    update();
    print("statusAEmail : $statusAEmail");
  }

  void updateEditDOB() {
    statusDOB = !statusDOB;
    update();
    print("statusDOB : $statusDOB");
  }

  void updateEditCGPA() {
    statusCGPA = !statusCGPA;
    update();
    print("statusCGPA : $statusCGPA");
  }

  void updateEditYOC() {
    statusYOC = !statusYOC;
    update();
    print("statusYOC : $statusYOC");
  }

  void resetAll() {
    statusName = false;
    statusPhone = false;
    statusEmail = false;
    statusAEmail = false;
    statusDOB = false;
    statusCGPA = false;
    statusYOC = false;
    update();
    print("All Disabled");
  }
}
