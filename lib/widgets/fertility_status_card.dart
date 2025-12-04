import 'package:flutter/material.dart';

class FertilityStatusCard extends StatelessWidget {
  const FertilityStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, this would be calculated based on user data
    const String fertileStatus = "باروری زیاد";
    const int cycleDay = 8;
    const String nextPeriod = "3 مهر";
    const String ovulationPrediction = "19 شهریور";
    const String fertileWindow = "17شهریور20 - شهریور";

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
                      'وضعیت باروری شما ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'روز دوران قاعدگی $cycleDay',
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
                    'تخمین باروری',
                    ovulationPrediction,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    context,
                    Icons.water_drop,
                    'پنجره باروری',
                    fertileWindow,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    context,
                    Icons.calendar_today,
                    'تاریخ قاعدگی',
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