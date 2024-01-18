import 'package:flutter/material.dart';

class Study {
  final String studyCode;
  final String studyName;
  final String studyDescription;

  Study({
    required this.studyCode,
    required this.studyName,
    required this.studyDescription,
  });
}

class StudyProvider extends ChangeNotifier {
  List<Study> _studies = [];

  List<Study> get studies => _studies;

  void setStudies(List<Study> studies) {
    _studies = studies;
    notifyListeners();

    // Debug statements to check the values
    print('Studies set: ${_studies.length} studies');
    for (var study in _studies) {
      print(
          'Study: ${study.studyCode}, ${study.studyName}, ${study.studyDescription}');
    }
  }
}
