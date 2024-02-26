// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Doc {
  final String fileName;
  final String docId;
  final String type;
  final String fileUrl;
  final String prediction;
  final String createdAt;
  Doc({
    required this.fileName,
    required this.docId,
    required this.type,
    required this.fileUrl,
    required this.prediction,
    required this.createdAt,
  });

  Doc copyWith({
    String? fileName,
    String? docId,
    String? type,
    String? fileUrl,
    String? prediction,
    String? createdAt,
  }) {
    return Doc(
      fileName: fileName ?? this.fileName,
      docId: docId ?? this.docId,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      prediction: prediction ?? this.prediction,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileName': fileName,
      'docId': docId,
      'type': type,
      'fileUrl': fileUrl,
      'prediction': prediction,
      'createdAt': createdAt,
    };
  }

  factory Doc.fromMap(Map<String, dynamic> map) {
    return Doc(
      fileName: map['fileName'] as String,
      docId: map['docId'] as String,
      type: map['type'] as String,
      fileUrl: map['fileUrl'] as String,
      prediction: map['prediction'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  @override
  String toString() {
    return 'Doc(fileName: $fileName, docId: $docId, type: $type, fileUrl: $fileUrl, prediction: $prediction, createdAt: $createdAt)';
  }

  String toJson() => json.encode(toMap());

  factory Doc.fromJson(String source) => Doc.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Doc other) {
    if (identical(this, other)) return true;
  
    return 
      other.fileName == fileName &&
      other.docId == docId &&
      other.type == type &&
      other.fileUrl == fileUrl &&
      other.prediction == prediction &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return fileName.hashCode ^
      docId.hashCode ^
      type.hashCode ^
      fileUrl.hashCode ^
      prediction.hashCode ^
      createdAt.hashCode;
  }
}
