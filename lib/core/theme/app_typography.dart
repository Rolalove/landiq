import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const _heading = 'PlayfairDisplay';
  static const _body = 'Roboto';


  // HEADINGS (Playfair Display)
 
  static const h1 = TextStyle(
    fontFamily: _heading,
    fontSize: 56,
    fontWeight: FontWeight.w500, // medium
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const h2 = TextStyle(
    fontFamily: _heading,
    fontSize: 48,
    fontWeight: FontWeight.w500, // medium
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const h3 = TextStyle(
    fontFamily: _heading,
    fontSize: 40,
    fontWeight: FontWeight.w600, // semi-bold
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const h4 = TextStyle(
    fontFamily: _heading,
    fontSize: 32,
    fontWeight: FontWeight.w600, // semi-bold
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const h5 = TextStyle(
    fontFamily: _heading,
    fontSize: 24,
    fontWeight: FontWeight.w600, // semi-bold
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const h6 = TextStyle(
    fontFamily: _heading,
    fontSize: 16,
    fontWeight: FontWeight.w600, // semi-bold
    color: AppColors.textPrimary,
    height: 1.0,
  );

  // BODY (Roboto)
  static const bodyLg = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w400, // regular
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const bodyMd = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w400, // regular
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // CAPTION (Roboto)
  static const captionLg = TextStyle(
    fontFamily: _body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const captionSm = TextStyle(
    fontFamily: _body,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
