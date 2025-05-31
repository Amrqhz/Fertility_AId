import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from a database
    final List<Map<String, dynamic>> historyData = [
      {
        'date': DateTime.now().subtract(const Duration(days: 14)),
        'temperature': 97.3,
        'lhResult': 'negative',
        'notes': 'Feeling normal',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 13)),
        'temperature': 97.2,
        'lhResult': 'negative',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 12)),
        'temperature': 97.4,
        'lhResult': 'negative',
        'notes': 'Slight cramping',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 11)),
        'temperature': 97.3,
        'lhResult': 'low',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'temperature': 97.5,
        'lhResult': 'low',
        'notes': 'Increased cervical mucus',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 9)),
        'temperature': 97.6,
        'lhResult': 'high',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'temperature': 97.8,
        'lhResult': 'high',
        'notes': 'Egg white cervical mucus',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'temperature': 98.0,
        'lhResult': 'peak',
        'notes': 'Ovulation pain',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'temperature': 98.2,
        'lhResult': 'high',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'temperature': 98.3,
        'lhResult': 'low',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'temperature': 98.4,
        'lhResult': 'negative',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'temperature': 98.3,
        'lhResult': 'negative',
        'notes': 'Feeling tired',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'temperature': 98.4,
        'lhResult': 'negative',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'temperature': 98.3,
        'lhResult': 'negative',
        'notes': '',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertility History'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: historyData.length,
          itemBuilder: (context, index) {
            final entry = historyData[index];
            return _buildHistoryCard(context, entry);
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> entry) {
    final date = entry['date'] as DateTime;
    final temperature = entry['temperature'] as double;
    final lhResult = entry['lhResult'] as String;
    final notes = entry['notes'] as String;

    Color cardColor;
    String fertilityStatus;

    if (lhResult == 'peak') {
      cardColor = Colors.red.withOpacity(0.1);
      fertilityStatus = 'Peak Fertility';
    } else if (lhResult == 'high') {
      cardColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      fertilityStatus = 'High Fertility';
    } else if (temperature > 98.0) {
      cardColor = Colors.purple.withOpacity(0.1);
      fertilityStatus = 'Post-Ovulation';
    } else {
      cardColor = Colors.grey.withOpacity(0.1);
      fertilityStatus = 'Low Fertility';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d, yyyy').format(date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    fertilityStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDataItem(
                    context,
                    'Temperature',
                    '${temperature.toStringAsFixed(1)}°F',
                    Icons.thermostat,
                  ),
                ),
                Expanded(
                  child: _buildDataItem(
                    context,
                    'LH Result',
                    _formatLHResult(lhResult),
                    Icons.water_drop,
                  ),
                ),
              ],
            ),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                notes,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  String _formatLHResult(String result) {
    switch (result) {
      case 'negative':
        return 'Negative';
      case 'low':
        return 'Low';
      case 'high':
        return 'High';
      case 'peak':
        return 'Peak';
      default:
        return result;
    }
  }
}