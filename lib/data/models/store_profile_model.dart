import 'package:floor/floor.dart';

@Entity(tableName: 'store_profile')
class StoreProfileModel {
  @PrimaryKey(autoGenerate: false)
  final int id; // Always 1 for singleton

  final String? storeName;
  final String? address;
  final String? phone;
  final String? email;
  final String? logoPath;
  final String? footerNote;
  final String? taxNumber;
  final String? themeColor;
  final int isDarkMode;

  // Getters for convenience
  bool get isDarkModeBool => isDarkMode == 1;

  StoreProfileModel({
    this.id = 1,
    this.storeName,
    this.address,
    this.phone,
    this.email,
    this.logoPath,
    this.footerNote,
    this.taxNumber,
    this.themeColor,
    this.isDarkMode = 0,
  });

  // CopyWith method
  StoreProfileModel copyWith({
    int? id,
    String? storeName,
    String? address,
    String? phone,
    String? email,
    String? logoPath,
    String? footerNote,
    String? taxNumber,
    String? themeColor,
    int? isDarkMode,
  }) {
    return StoreProfileModel(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logoPath: logoPath ?? this.logoPath,
      footerNote: footerNote ?? this.footerNote,
      taxNumber: taxNumber ?? this.taxNumber,
      themeColor: themeColor ?? this.themeColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  // Default profile
  factory StoreProfileModel.defaultProfile() {
    return StoreProfileModel(
      id: 1,
      storeName: 'My Store',
      address: '',
      phone: '',
      email: '',
      logoPath: null,
      footerNote: 'Thank you for shopping with us!',
      taxNumber: '',
      themeColor: '#2196F3',
      isDarkMode: 0,
    );
  }

  // Convert to map for easy access
  Map<String, String?> toMap() {
    return {
      'storeName': storeName,
      'address': address,
      'phone': phone,
      'email': email,
      'logoPath': logoPath,
      'footerNote': footerNote,
      'taxNumber': taxNumber,
      'themeColor': themeColor,
    };
  }
}
