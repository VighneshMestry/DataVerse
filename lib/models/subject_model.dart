import 'dart:convert';

import 'package:flutter/foundation.dart';

class Subject {
  final String name;
  final String subjectId;
  final String subjectType;
  final String backGroundImageUrl;
  final String createdBy;
  final List<String> members;
  Subject({
    required this.name,
    required this.subjectId,
    required this.subjectType,
    required this.backGroundImageUrl,
    required this.createdBy,
    required this.members,
  });


  Subject copyWith({
    String? name,
    String? subjectId,
    String? subjectType,
    String? backGroundImageUrl,
    String? createdBy,
    List<String>? members,
  }) {
    return Subject(
      name: name ?? this.name,
      subjectId: subjectId ?? this.subjectId,
      subjectType: subjectType ?? this.subjectType,
      backGroundImageUrl: backGroundImageUrl ?? this.backGroundImageUrl,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'subjectId': subjectId,
      'subjectType': subjectType,
      'backGroundImageUrl': backGroundImageUrl,
      'createdBy': createdBy,
      'members': members,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      name: map['name'] as String,
      subjectId: map['subjectId'] as String,
      subjectType: map['subjectType'] as String,
      backGroundImageUrl: map['backGroundImageUrl'] as String,
      createdBy: map['createdBy'] as String,
      members: List<String>.from((map['members'] as List<String>),
    ));
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Subject(name: $name, subjectId: $subjectId, subjectType: $subjectType, backGroundImageUrl: $backGroundImageUrl, createdBy: $createdBy, members: $members)';
  }

  @override
  bool operator ==(covariant Subject other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.subjectId == subjectId &&
      other.subjectType == subjectType &&
      other.backGroundImageUrl == backGroundImageUrl &&
      other.createdBy == createdBy &&
      listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      subjectId.hashCode ^
      subjectType.hashCode ^
      backGroundImageUrl.hashCode ^
      createdBy.hashCode ^
      members.hashCode;
  }
}
