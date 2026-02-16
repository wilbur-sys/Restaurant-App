import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

// class untuk menyimpan semua text style yang dipakai di aplikasi
class RestaurantTextStyles {
  // base style pakai font Poppins dari GoogleFonts
  static TextStyle get _commonStyle => GoogleFonts.poppins();

  // style untuk text ukuran sangat besar (judul utama)
  static TextStyle get displayLarge => _commonStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // style untuk heading besar
  static TextStyle get displayMedium => _commonStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // style untuk sub heading besar
  static TextStyle get displaySmall => _commonStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // style untuk heading section
  static TextStyle get headlineLarge =>
      _commonStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600);

  // style untuk heading medium
  static TextStyle get headlineMedium =>
      _commonStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500);

  // style untuk heading kecil
  static TextStyle get headlineSmall =>
      _commonStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w500);

  // style untuk title utama
  static TextStyle get titleLarge =>
      _commonStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  // style untuk title secondary
  static TextStyle get titleMedium =>
      _commonStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500);

  // style untuk title kecil
  static TextStyle get titleSmall =>
      _commonStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500);

  // style body text tebal, biasanya untuk highlight
  static TextStyle get bodyLargeBold => _commonStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.6,
  );

  // style body text normal, paling sering dipakai
  static TextStyle get bodyLargeMedium => _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  // style body text kecil
  static TextStyle get bodyLargeRegular => _commonStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  // style untuk label besar (button, dll)
  static TextStyle get labelLarge =>
      _commonStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600);

  // style untuk label medium
  static TextStyle get labelMedium =>
      _commonStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500);

  // style untuk label kecil
  static TextStyle get labelSmall =>
      _commonStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500);
}
