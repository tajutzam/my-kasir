import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<void> cleanImageDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      if (directory.existsSync()) {
        // List semua file di dalam folder tersebut
        final List<FileSystemEntity> files = directory.listSync();

        for (var file in files) {
          if (file is File && file.path.contains('img_')) {
            // Hapus hanya file yang berawalan 'img_' (sesuai format kamu)
            await file.delete();
            print("Deleted: ${file.path}");
          }
        }
      }
    } catch (e) {
      print("Error cleaning directory: $e");
    }
  }
}
