import 'package:flutter/material.dart';

class ResponsiveFormSpacing {
  final EdgeInsets outerPadding;
  final EdgeInsets cardPadding;

  const ResponsiveFormSpacing({
    required this.outerPadding,
    required this.cardPadding,
  });

  static ResponsiveFormSpacing fromWidth(double screenWidth) {
    if (screenWidth < 360) {
      return const ResponsiveFormSpacing(
        outerPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        cardPadding: EdgeInsets.all(10),
      );
    }

    if (screenWidth < 420) {
      return const ResponsiveFormSpacing(
        outerPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        cardPadding: EdgeInsets.all(12),
      );
    }

    return const ResponsiveFormSpacing(
      outerPadding: EdgeInsets.all(24),
      cardPadding: EdgeInsets.all(20),
    );
  }
}
