import 'package:flutter/material.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/constants/custom_fonts.dart';

class FormInput extends StatelessWidget {
  final TextInputType? textInputType;
  final String? labelText;
  final bool isObscured;
  final String? hintText;
  final TextEditingController controller;
  final bool isEnabled;
  final int maxLength;
  final TextInputAction? textInputAction;
  final Function? onSubmittedFunction;
  final bool isEmptyError;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final int maxLines;
  final double height;
  final double width;
  final Decoration? boxDecoration;
  final Function? onSuffixPressed;
  final int minLines;
  final bool expands;
  final bool? alignWithLabel;
  final IconData? icon;
  final Color? iconColor;

  const FormInput(
      {super.key,
      this.textInputType,
      this.labelText,
      this.hintText,
      required this.controller,
      this.isObscured = false,
      this.boxDecoration,
      this.isEnabled = true,
      this.maxLength = 30,
      this.textInputAction,
      this.onSubmittedFunction,
      this.isEmptyError = false,
      this.borderRadius = 5,
      this.contentPadding = const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
      this.onSuffixPressed,
      this.maxLines = 1,
      this.height = 100,
      this.width = 300,
      this.minLines = 1,
      this.alignWithLabel,
      this.icon,
      this.iconColor,
      this.expands = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      enableSuggestions: false,
      obscureText: isObscured,
      autocorrect: false,
      style: TextStyle(fontFamily: CustomFonts.get.oxygen_bold, color: CustomColor.get.light_grey, fontSize: 16),
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.get.light_pink, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.get.light_pink, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.get.deep_pink, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        alignLabelWithHint: alignWithLabel,
        contentPadding: contentPadding,
        labelText: labelText,
        labelStyle: TextStyle(fontFamily: CustomFonts.get.oxygen_bold, color: CustomColor.get.light_grey, fontSize: 16),
      ),
    );
  }
}
