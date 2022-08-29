import 'package:flutter/material.dart';

Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
  return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
}

final loginButtonColor = hexToColor('#23689b');

// backgroundColor

const mainAppBarColor = Color(0xFFFFFFFF);
LinearGradient bgGradient = LinearGradient(
    colors: [
      hexToColor('#36c486'),
      hexToColor('#00bf98'),
      hexToColor('#00a1ba'),
      hexToColor('#485da6'),
      hexToColor('#6d327c'),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: const [
      0.1,
      0.4,
      0.5,
      0.8,
      0.9,
      // 0.8,
    ]);
