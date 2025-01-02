import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final VoidCallback? onBackPress;
  final Color backgroundColor;
  final Color iconColor;
  final double height;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final TextStyle? titleStyle; // Allows customization for the title style
  final Widget? leading; // Allows customization for the leading widget (e.g., back button or other icons)
  final bool automaticallyImplyLeading; // Similar to AppBar's automaticallyImplyLeading

  const RoundedAppBar({
    Key? key,
    required this.title,

    this.onBackPress,
    this.backgroundColor = const Color(0xFF243B6D), // Default to the AppBar background color (dark blue)
    this.iconColor = Colors.white, // Default icon color (white)
    this.height = 150, // Default height
    this.bottomLeftRadius = 30, // Default roundness for bottom-left
    this.bottomRightRadius = 30, // Default roundness for bottom-right
    this.titleStyle, // Optionally allow custom title style
    this.leading, // Optionally allow a custom leading widget (back button, etc.)
    this.automaticallyImplyLeading = false, // By default, imply leading (back button) if onBackPress is not null
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius),
      ),
      child: Container(
        height: height,
        color: backgroundColor,
        child: Stack(
          children: [
            // Custom leading widget (back button or other icons)
            if (leading != null)
              Positioned(
                top: 50,
                left: 16,
                child: leading!,
              ),
            if (automaticallyImplyLeading && onBackPress != null && leading == null)
              Positioned(
                top: 50,
                left: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: iconColor,
                  ),
                  onPressed: onBackPress,
                ),
              ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                        color: iconColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
