// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AIDoc {
  final String fileName;
  final String aiDocId;
  final String mainDocId;
  final String userId;
  final String fileUrl;
  final String createdAt;
  AIDoc({
    required this.fileName,
    required this.aiDocId,
    required this.mainDocId,
    required this.userId,
    required this.fileUrl,
    required this.createdAt,
  });

  AIDoc copyWith({
    String? fileName,
    String? aiDocId,
    String? mainDocId,
    String? userId,
    String? fileUrl,
    String? createdAt,
  }) {
    return AIDoc(
      fileName: fileName ?? this.fileName,
      aiDocId: aiDocId ?? this.aiDocId,
      mainDocId: mainDocId ?? this.mainDocId,
      userId: userId ?? this.userId,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileName': fileName,
      'aiDocId': aiDocId,
      'mainDocId': mainDocId,
      'userId': userId,
      'fileUrl': fileUrl,
      'createdAt': createdAt,
    };
  }

  factory AIDoc.fromMap(Map<String, dynamic> map) {
    return AIDoc(
      fileName: map['fileName'] as String,
      aiDocId: map['aiDocId'] as String,
      mainDocId: map['mainDocId'] as String,
      userId: map['userId'] as String,
      fileUrl: map['fileUrl'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AIDoc.fromJson(String source) => AIDoc.fromMap(json.decode(source) as Map<String, dynamic>);
}
