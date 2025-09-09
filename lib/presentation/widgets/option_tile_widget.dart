import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;
  final bool answered;

  const OptionTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
    required this.answered,
  });

  @override
  Widget build(BuildContext context) {
    Color tileColor;
    if (answered && isSelected) {
      tileColor = isCorrect ? Color.fromARGB(174, 89, 221, 65) : Colors.red;
    } else if (isSelected) {
      tileColor = Color.fromARGB(174, 89, 221, 65);
    } else {
      tileColor = Colors.grey.shade200;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected && answered ? tileColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }
}
