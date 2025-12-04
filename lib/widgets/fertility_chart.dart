import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FertilityChart extends StatelessWidget {
  const FertilityChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Temperature data (36-37.5°C range)
    final List<FlSpot> tempSpots = [
      const FlSpot(6, 36.4),
      const FlSpot(7, 36.5),
      const FlSpot(8, 36.4),
      const FlSpot(9, 36.5),
      const FlSpot(10, 36.4),
      const FlSpot(11, 36.3), // Slight dip before ovulation
      const FlSpot(12, 36.2), // Pre-ovulation dip
      const FlSpot(13, 36.3),
      const FlSpot(14, 36.8), // Post-ovulation rise
      const FlSpot(15, 36.9),
      const FlSpot(16, 37.0),
      const FlSpot(17, 36.9),
      const FlSpot(18, 37.0),
      const FlSpot(19, 36.9),
      const FlSpot(20, 37.0),
      const FlSpot(21, 36.9),
      const FlSpot(22, 37.0),
      const FlSpot(23, 36.9),
      const FlSpot(24, 36.8),
      const FlSpot(25, 36.9),
      const FlSpot(26, 36.8),
      const FlSpot(27, 36.7),
      const FlSpot(28, 36.6),
    ];

    // LH data (1-10 scale) - mapped to 1-10 range for right axis
    final List<FlSpot> lhSpots = [
      const FlSpot(6, 2.0),
      const FlSpot(7, 2.2),
      const FlSpot(8, 2.5),
      const FlSpot(9, 3.0),
      const FlSpot(10, 3.5),
      const FlSpot(11, 3.5),
      const FlSpot(12, 3.0), // LH surge begins
      const FlSpot(13, 5.5), // Peak LH surge
      const FlSpot(14, 8.0),
      const FlSpot(15, 7.0), // Declining
      const FlSpot(16, 5.8), // LH surge begins
      const FlSpot(17, 5.5), // Peak LH surge
      const FlSpot(18, 4.5),
      const FlSpot(19, 4.0), // Declining
      const FlSpot(20, 2.8),
      const FlSpot(21, 2.3),
      const FlSpot(22, 2.0),
      const FlSpot(23, 2.0),
    ];

    return Container(
      height: 400,
      child: Column(
        children: [
          // Simple legend
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(width: 20, height: 3, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('دمای بدن', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 20, height: 3, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text('وضعیت LH', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 20, height: 3, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('حداکثر باروری', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: false,
                    drawVerticalLine: true,
                    horizontalInterval: 0.1,
                    verticalInterval: 1,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    // Right side - LH (1-10)
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value >= 1 && value <= 10 && value % 1 == 0) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                '${value.toInt()}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              'روز ${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        reservedSize: 25,
                      ),
                    ),
                    // Left side - Temperature (°C)
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.1,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${value.toStringAsFixed(1)}°',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                              ),
                            ),
                          );
                        },
                        reservedSize: 50,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 6,
                  maxX: 28,
                  minY: 36.0,
                  maxY: 37.5,
                  lineBarsData: [
                    // Temperature line (uses left axis)
                    LineChartBarData(
                      spots: tempSpots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.green,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // LH line - scaled to fit in temperature range for display
                    LineChartBarData(
                      spots:
                          lhSpots
                              .map(
                                (spot) =>
                                    FlSpot(spot.x, 36.0 + (spot.y / 10) * 1.5),
                              )
                              .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 2,
                            color: Colors.blue,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 36.7,
                        color: Colors.red.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 5, bottom: 5),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                          ),
                          labelResolver: (line) => 'آستانه تخمک گذاری',
                        ),
                      ),
                    ],
                    verticalLines: [
                      // Maximum fertility period (days 11-15)
                      VerticalLine(
                        x: 15,
                        color: const Color.fromARGB(
                          255,
                          55,
                          209,
                          41,
                        ).withOpacity(0.2),
                        strokeWidth: 40,
                        label: VerticalLineLabel(
                          show: true,
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 5),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 9,
                          ),
                          labelResolver: (line) => 'حداکثر باروری',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
