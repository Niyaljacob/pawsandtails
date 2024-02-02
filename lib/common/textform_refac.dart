import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon; 
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.3), // Background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}


class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;

  SearchTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        filled: false, // Remove fill color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.black), // Set outline color
        ),
      ),
    );
  }
}
