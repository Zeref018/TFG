import 'package:flutter/material.dart';
import 'package:tfg/constants/custom_colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        semanticsLabel: 'Loader',
        backgroundColor: CustomColor.get.black.withOpacity(0.7),
        color: CustomColor.get.light_pink,
      ),
    );
  }
}
