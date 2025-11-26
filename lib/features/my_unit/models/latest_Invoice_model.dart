class LatestInvoice {
  final int id;
  final String invoiceNumber;
  final String durations;
  final String createdAt;
  final String dueDate;
  final String billMode;
  final String amount;
  final String status;
  final String invoiceFile;

  LatestInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.durations,
    required this.createdAt,
    required this.dueDate,
    required this.billMode,
    required this.amount,
    required this.status,
    required this.invoiceFile,
  });

  factory LatestInvoice.fromJson(Map<String, dynamic> json) {
    return LatestInvoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      durations: json['durations'],
      createdAt: json['created_at'],
      dueDate: json['due_date'],
      billMode: json['bill_mode'],
      amount: json['amount'],
      status: json['status'],
      invoiceFile: json['invoice_file'] ?? '',
    );
  }
}
