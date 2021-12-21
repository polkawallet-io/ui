import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliderThumbShape extends SliderComponentShape {
  final ui.Image? image;
  // ui.Image images;
  SliderThumbShape(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.zero;
  }

  @override
  Future<void> paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) async {
    final Canvas canvas = context.canvas;
    if (image != null) {
      canvas.drawImage(
          image!,
          Offset(
              center.dx - image!.width / 2, center.dy - image!.height / 2 + 2),
          Paint());
    }
  }

  Future<ui.Image> getAssetImage(String asset, {width, height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
