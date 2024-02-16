import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/list_product_category.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? opacity;
  CustomElevatedButton({
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColo.primaryColor1.withOpacity(0.5), // Customize button color
        ),
        child: Text(label,style: TextStyle(color: Colors.black,fontSize: 25),),
      ),
    );
  }
}




class CustomRowWithButton extends StatelessWidget {
  final String customText;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomRowWithButton({
    required this.customText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          customText,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: TextButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}
