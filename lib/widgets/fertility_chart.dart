import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FertilityChart extends StatelessWidget {
  const FertilityChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from a database
    final List<FlSpot> tempSpots = [
      const FlSpot(1, 97.3),
      const FlSpot(2, 97.2),
      const FlSpot(3, 97.4),
      const FlSpot(4, 97.3),
      const FlSpot(5, 97.5),
      const FlSpot(6, 97.6),
      const FlSpot(7, 97.8),
      const FlSpot(8, 98.0), // LH surge
      const FlSpot(9, 98.2), // Ovulation likely occurred
      const FlSpot(10, 98.3),
      const FlSpot(11, 98.4),
      const FlSpot(12, 98.3),
      const FlSpot(13, 98.4),
      const FlSpot(14, 98.3),
    ];

    final List<FlSpot> lhSpots = [
      const FlSpot(1, 0.2),
      const FlSpot(2, 0.3),
      const FlSpot(3, 0.2),
      const FlSpot(4, 0.4),
      const FlSpot(5, 0.6),
      const FlSpot(6, 0.8),
      const FlSpot(7, 1.2),
      const FlSpot(8, 1.8), // LH surge
      const FlSpot(9, 0.9),
      const FlSpot(10, 0.5),
      const FlSpot(11, 0.3),
      const FlSpot(12, 0.2),
      const FlSpot(13, 0.2),
      const FlSpot(14, 0.1),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 0.5,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
              reservedSize: 40,
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
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                    ),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 1,
        maxX: 14,
        minY: 96.5,
        maxY: 99,
        lineBarsData: [
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
                  radius: 4,
                  color: Colors.green,
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
              y: 98.0,
              color: Colors.red.withOpacity(0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 5, bottom: 5),
                style: const TextStyle(color: Colors.red, fontSize: 9),
                labelResolver: (line) => 'Ovulation Threshold',
              ),
            ),
          ],
        ),
      ),
    );
  }
}