class ManageDocumentModel {
  String name;
  String fileFormat;
  String filePath;
  String fileSize;
  String createdAt;

  ManageDocumentModel({
    required this.name,
    required this.filePath,
    required this.createdAt,
    required this.fileFormat,
    required this.fileSize,
  });
}

List<ManageDocumentModel> listOfDocument = [
  ManageDocumentModel(
      name: 'Offer later',
      filePath:
          'https://www.indiafilings.com/sample-format/offer-letter-format.pdf',
      createdAt: '12/2/2024',
      fileFormat: 'pdf',
      fileSize: '120KB'),
  ManageDocumentModel(
      name: 'Offer later',
      filePath:
          'https://www.indiafilings.com/sample-format/offer-letter-format.pdf',
      createdAt: '12/2/2024',
      fileFormat: 'pdf',
      fileSize: '120KB'),
  ManageDocumentModel(
      name: 'Performance Review Template',
      filePath:
          'https://www.indiafilings.com/sample-format/offer-letter-format.pdf',
      createdAt: '12/2/2024',
      fileFormat: 'doc',
      fileSize: '120KB'),
  ManageDocumentModel(
      name: 'Leave Request Form',
      filePath:
          'https://www.indiafilings.com/sample-format/offer-letter-format.pdf',
      createdAt: '12/2/2024',
      fileFormat: 'image',
      fileSize: '120KB'),
];
