import 'package:flutter/material.dart';
import '../utils/text_constant.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        TextConstants.title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.amber.withOpacity(0.2),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
