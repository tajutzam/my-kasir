import 'package:floor/floor.dart';

@Entity(
  tableName: 'transaction',
  indices: [
    Index(value: ['invoiceNumber'], unique: true),
    Index(value: ['dateMillis']),
    Index(value: ['status']),
  ],
)
class TransactionModel {
  @primaryKey
  final int? id;

  final String invoiceNumber;
  final int dateMillis;
  final double totalAmount;
  final double totalDiscount;
  final double globalDiscount;
  final String paymentMethod;
  final String cashierName;
  final String status;
  final String? voidReason;
  final int createdAtMillis;

  final double cashReceived; // Uang yang diterima dari pembeli
  final double changeAmount; // Kembalian yang diberikan

  // Getters for convenience
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(dateMillis);
  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdAtMillis);

  // Computed properties
  double get finalTotal => totalAmount - totalDiscount - globalDiscount;
  bool get isCompleted => status == 'completed';
  bool get isVoided => status == 'voided';

  TransactionModel({
    this.id,
    required this.invoiceNumber,
    DateTime? date,
    required this.totalAmount,
    this.totalDiscount = 0,
    this.globalDiscount = 0,
    this.cashReceived = 0,
    this.changeAmount = 0,
    required this.paymentMethod,
    required this.cashierName,
    this.status = 'completed',
    this.voidReason,
    DateTime? createdAt,
  }) : dateMillis =
           date?.millisecondsSinceEpoch ??
           DateTime.now().millisecondsSinceEpoch,
       createdAtMillis =
           createdAt?.millisecondsSinceEpoch ??
           DateTime.now().millisecondsSinceEpoch;

  // CopyWith method
  TransactionModel copyWith({
    int? id,
    String? invoiceNumber,
    DateTime? date,
    double? totalAmount,
    double? totalDiscount,
    double? globalDiscount,
    double? cashReceived, // Tambahkan di sini
    double? changeAmount, // Tambahkan di sini
    String? paymentMethod,
    String? cashierName,
    String? status,
    String? voidReason,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? date,
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      globalDiscount: globalDiscount ?? this.globalDiscount,
      cashReceived: cashReceived ?? this.cashReceived, // Dan di sini
      changeAmount: changeAmount ?? this.changeAmount,   // Dan di sini
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cashierName: cashierName ?? this.cashierName,
      status: status ?? this.status,
      voidReason: voidReason ?? this.voidReason,
      createdAt: createdAt,
    );
  }

  // Void transaction
  TransactionModel voidTransaction(String reason) {
    return copyWith(status: 'voided', voidReason: reason);
  }
}
