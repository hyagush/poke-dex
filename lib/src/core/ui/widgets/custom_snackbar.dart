import 'package:flutter/material.dart';

extension SnackBarExtension on SnackBar {
  void show(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String content,
    IconData? icon,
    Color backgroundColor = Colors.black87,
    Color iconColor = Colors.white70,
  }) : super(
         content: Row(
           children: [
             if (icon != null) ...[
               Icon(icon, color: iconColor, size: 20),
               const SizedBox(width: 12),
             ],
             Expanded(
               child: Text(
                 content,
                 style: const TextStyle(fontSize: 16, color: Colors.white),
               ),
             ),
           ],
         ),
         backgroundColor: backgroundColor,
         behavior: SnackBarBehavior.floating,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8.0),
         ),
       );

  factory CustomSnackbar.error(String content) {
    return CustomSnackbar(
      content: content,
      icon: Icons.error_outline,
      backgroundColor: Colors.red[800]!,
    );
  }

  factory CustomSnackbar.success(String content) {
    return CustomSnackbar(
      content: content,
      icon: Icons.check_circle_outline,
      backgroundColor: Colors.green[800]!,
    );
  }
}
