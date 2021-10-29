import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  Future<void> addColleges(Map<String, dynamic> clgData, String clgID) async {
    return await FirebaseFirestore.instance
        .collection("Colleges")
        .doc(clgID)
        .set(clgData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addCompanies(
      Map<String, dynamic> compData, String compID) async {
    return await FirebaseFirestore.instance
        .collection("Company")
        .doc(compID)
        .set(compData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> createNotices(
    Map<String, dynamic> noticeData,
  ) async {
    return await FirebaseFirestore.instance
        .collection("Notices")
        .doc()
        .set(noticeData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> appliedJobs(
    Map<String, dynamic> appliedJobData,
    String appliedID,
  ) async {
    return await FirebaseFirestore.instance
        .collection("Applied Jobs")
        .doc(appliedID)
        .set(appliedJobData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> createJob(Map<String, dynamic> jobData) async {
    return await FirebaseFirestore.instance
        .collection("Jobs")
        .doc()
        .set(jobData)
        .catchError((e) {
      print(e.toString());
    });
  }
}
