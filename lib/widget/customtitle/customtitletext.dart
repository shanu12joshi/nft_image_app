import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class CustomTitle extends StatelessWidget {
  @required
  String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final double? letterspace;
  final Locale? locale;
  final TextOverflow? overflow;
  final Paint? foreground;
  TextDecoration? linethrough;



  CustomTitle({Key? key,this.overflow,this.color,this.align,this.fontFamily,this.fontSize,this.locale,required this.text,this.linethrough, this.fontWeight, this.letterspace, this.foreground}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,style: GoogleFonts.poppins(
      letterSpacing: letterspace,
      foreground: foreground,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
      decoration: linethrough,
    ),textAlign: align,);
  }
}
