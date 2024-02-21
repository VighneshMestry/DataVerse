class Doc {
  final String fileName;
  final String type;
  final String fileUrl;
  final String prediction;
  Doc({
    required this.fileName,
    required this.type,
    required this.fileUrl,
    required this.prediction,
  });

  Doc copyWith({
    String? fileName,
    String? type,
    String? fileUrl,
    String? prediction,
  }) {
    return Doc(
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      prediction: prediction ?? this.prediction,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileName': fileName,
      'type': type,
      'fileUrl': fileUrl,
      'prediction': prediction,
    };
  }

  factory Doc.fromMap(Map<String, dynamic> map) {
    return Doc(
      fileName: map['fileName'] as String,
      type: map['type'] as String,
      fileUrl: map['fileUrl'] as String,
      prediction: map['prediction'] as String,
    );
  }

  @override
  String toString() {
    return 'Doc(fileName: $fileName, type: $type, fileUrl: $fileUrl, prediction: $prediction)';
  }
}
