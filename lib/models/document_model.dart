import 'dart:convert';
class Doc {
  final String fileName;
  final String assignmentTitle;
  final String assigmentDescription;
  final String docId;
  final String subjectJoiningCode;
  final String userId;
  final String type;
  final String fileUrl;
  final String prediction;
  final String createdAt;
  final bool aiFileExists;
  final List<String> tags;
  Doc({
    required this.fileName,
    required this.assignmentTitle,
    required this.assigmentDescription,
    required this.docId,
    required this.subjectJoiningCode,
    required this.userId,
    required this.type,
    required this.fileUrl,
    required this.prediction,
    required this.createdAt,
    required this.aiFileExists,
    required this.tags,
  });

  Doc copyWith({
    String? fileName,
    String? assignmentTitle,
    String? assigmentDescription,
    String? docId,
    String? subjectJoiningCode,
    String? userId,
    String? type,
    String? fileUrl,
    String? prediction,
    String? createdAt,
    bool? aiFileExists,
    List<String>? tags,
  }) {
    return Doc(
      fileName: fileName ?? this.fileName,
      assignmentTitle: assignmentTitle ?? this.assignmentTitle,
      assigmentDescription: assigmentDescription ?? this.assigmentDescription,
      docId: docId ?? this.docId,
      subjectJoiningCode: subjectJoiningCode ?? this.subjectJoiningCode,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      prediction: prediction ?? this.prediction,
      createdAt: createdAt ?? this.createdAt,
      aiFileExists: aiFileExists ?? this.aiFileExists,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileName': fileName,
      'assignmentTitle': assignmentTitle,
      'assigmentDescription': assigmentDescription,
      'docId': docId,
      'subjectJoiningCode': subjectJoiningCode,
      'userId': userId,
      'type': type,
      'fileUrl': fileUrl,
      'prediction': prediction,
      'createdAt': createdAt,
      'aiFileExists': aiFileExists,
      'tags': tags,
    };
  }

  factory Doc.fromMap(Map<String, dynamic> map) {
    return Doc(
      fileName: map['fileName'] as String,
      assignmentTitle: map['assignmentTitle'] as String,
      assigmentDescription: map['assigmentDescription'] as String,
      docId: map['docId'] as String,
      subjectJoiningCode: map['subjectJoiningCode'] as String,
      userId: map['userId'] as String,
      type: map['type'] as String,
      fileUrl: map['fileUrl'] as String,
      prediction: map['prediction'] as String,
      createdAt: map['createdAt'] as String,
      aiFileExists: map['aiFileExists'] as bool,
      tags: List<String>.from((map['tags'])),
    );
  }


  String toJson() => json.encode(toMap());

  factory Doc.fromJson(String source) => Doc.fromMap(json.decode(source) as Map<String, dynamic>);
}
