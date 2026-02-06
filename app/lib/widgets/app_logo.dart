import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double fontSize;

  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.fontSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(size * 0.25),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size * 0.3),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.2),
            child: Image.asset(
              'assets/icon/icon.jpeg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.menu_book_rounded,
                  color: AppTheme.primaryColor,
                  size: size,
                );
              },
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.4),
          Text(
            'DevBlog',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: AppTheme.textColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
