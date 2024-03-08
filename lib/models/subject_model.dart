class Subject {
  final String name;
  final String subjectId;
  final String subjectType;
  final String backGroundImageUrl;
  final String createdBy;
  final String subjectJoiningCode;
  final List<String> members;
  Subject({
    required this.name,
    required this.subjectId,
    required this.subjectType,
    required this.backGroundImageUrl,
    required this.createdBy,
    required this.subjectJoiningCode,
    required this.members,
  });


  Subject copyWith({
    String? name,
    String? subjectId,
    String? subjectType,
    String? backGroundImageUrl,
    String? createdBy,
    String? subjectJoiningCode,
    List<String>? members,
  }) {
    return Subject(
      name: name ?? this.name,
      subjectId: subjectId ?? this.subjectId,
      subjectType: subjectType ?? this.subjectType,
      backGroundImageUrl: backGroundImageUrl ?? this.backGroundImageUrl,
      createdBy: createdBy ?? this.createdBy,
      subjectJoiningCode: subjectJoiningCode ?? this.subjectJoiningCode,
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
      'subjectJoiningCode': subjectJoiningCode,
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
      subjectJoiningCode: map['subjectJoiningCode'] as String,
      members: List<String>.from((map['members']),)
    );
  }
}
