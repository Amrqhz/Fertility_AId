import 'package:flutter/material.dart';

class FertilityStatusCard extends StatelessWidget {
  const FertilityStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, this would be calculated based on user data
    const String fertileStatus = "High Fertility";
    const int cycleDay = 8;
    const String nextPeriod = "June 15";
    const String ovulationPrediction = "June 2";
    const String fertileWindow = "May 30 - June 3";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFE6FFFA), // Light teal background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Fertility Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Cycle Day $cycleDay',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    fertileStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    context,
                    Icons.thermostat,
                    'Predicted Ovulation',
                    ovulationPrediction,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    context,
                    Icons.water_drop,
                    'Fertile Window',
                    fertileWindow,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    context,
                    Icons.calendar_today,
                    'Next Period',
                    nextPeriod,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}