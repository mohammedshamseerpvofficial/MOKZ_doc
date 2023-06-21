class Document {
  String title;
  String description;
  String file;
  DateTime?expiryDate;
  String? documentType;
  String? thumbnail;

  Document({
    required this.title,
    required this.description,
    required this.file,
    this.expiryDate,
    this.documentType,
    this.thumbnail,
  });


  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      title: json['title'],
      description: json['description'],
      file: json['file'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      documentType: json['documentType'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'file': file,
      'expiryDate': expiryDate?.toIso8601String(),
      'documentType': documentType,
      'thumbnail': thumbnail,
    };
  }

}