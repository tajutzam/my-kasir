import 'package:intl/intl.dart';

class AppUtils {
  /// Format angka ke Rupiah
  static String formatRupiah(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format tanggal
  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d yyyy').format(date);
  }

  /// Format tanggal lengkap
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }
}
