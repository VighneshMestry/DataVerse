import 'package:flutter/material.dart';
import 'package:ml_project/models/subject_model.dart';

class Constants {
  static const subjectTypes = ["AIDS", "DMBI", "EHF", "WEBX"];

  static final defaultSubjects = [
    Subject(name: "Artificial Intelligence and Data Science", subjectId: "0", subjectType: "AIDS", backGroundImageUrl: "assets/subjectBackgroundImages/aidsImage.jpg", createdBy: "You", members: [], subjectJoiningCode: ""),
    Subject(name: "Data Mining and Business Intelligence", subjectId: "1", subjectType: "DMBI", backGroundImageUrl: "assets/subjectBackgroundImages/dbmiImage.jpeg", createdBy: "You", members: [], subjectJoiningCode: ""),
    Subject(name: "Ethical Hacking and Forensics", subjectId: "2", subjectType: "EHF", backGroundImageUrl: "assets/subjectBackgroundImages/ehfImage.jpg", createdBy: "You", members: [], subjectJoiningCode: ""),
    Subject(name: "WebX", subjectId: "3", subjectType: "WEBX", backGroundImageUrl: "assets/subjectBackgroundImages/webxImage.jpg", createdBy: "You", members: [], subjectJoiningCode: ""),
    Subject(name: "Wireless Technology", subjectId: "4", subjectType: "WT", backGroundImageUrl: "assets/subjectBackgroundImages/wtImage.jpeg", createdBy: "You", members: [], subjectJoiningCode: ""),
  ];

  static final subjectColors = [
    Colors.green.shade400,
    Colors.blue.shade400,
    Colors.deepOrange.shade400,
    Colors.grey.shade400,
    Colors.yellow.shade400
  ];

  static final subjectBackground = [
    "assets/subjectBackgroundImages/aidsImage.jpg",
    "assets/subjectBackgroundImages/dbmiImage.jpeg",
    "assets/subjectBackgroundImages/ehfImage.jpg",
    "assets/subjectBackgroundImages/webxImage.jpg",
    "assets/subjectBackgroundImages/wtImage.jpeg",

  ];

}