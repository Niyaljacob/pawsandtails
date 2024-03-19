import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
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

  const CustomTextField({
    Key? key,
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
  }) : super(key: key);

  @override
  
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText && _obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                )
              : null,
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

  const SearchTextField({super.key, 
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
          filled: false, 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
