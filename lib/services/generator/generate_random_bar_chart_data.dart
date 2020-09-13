import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

List<BarChartGroupData> generateRandomBarChartData() {
  final rand = Random();
  final data = <BarChartGroupData>[];
  for (var x = 0; x < 5; ++x) {
    final rods = <BarChartRodData>[];
    for (var rod = 0; rod < 5; ++rod) {
      final first = rand.nextInt(20).toDouble();
      final second = rand.nextInt(20).toDouble();
      rods.add(BarChartRodData(
          y: first + second,
          rodStackItem: [
            BarChartRodStackItem(0, first, Constants.IndigoColor),
            BarChartRodStackItem(
                first, first + second, Constants.LightIndigoColor),
          ],
          borderRadius: const BorderRadius.all(Radius.zero)));
    }
    data.add(BarChartGroupData(x: x, barsSpace: 4, barRods: rods));
  }
  return data;
}
