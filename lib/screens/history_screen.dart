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
        'temperature': 37.3,
        'lhResult': 'منفی',
        'notes': 'وضعیت نرمال ',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 13)),
        'temperature': 37.2,
        'lhResult': 'منفی',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 12)),
        'temperature': 37.4,
        'lhResult': 'منفی',
        'notes': 'شروع درد های کرمپی شکم',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 11)),
        'temperature': 37.3,
        'lhResult': 'پایین',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'temperature': 37.5,
        'lhResult': 'پایین',
        'notes': 'افزایش ضخامت موکوز واژن',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 9)),
        'temperature': 37.6,
        'lhResult': 'بالا',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'temperature': 37.8,
        'lhResult': 'بالا',
        'notes': 'Egg white cervical mucus',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'temperature': 38.0,
        'lhResult': 'حداکثر',
        'notes': 'شروع درد های تخمک گذاری',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 6)),
        'temperature': 38.2,
        'lhResult': 'بالا',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'temperature': 38.3,
        'lhResult': 'پایین ',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'temperature': 38.4,
        'lhResult': 'منفی',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'temperature': 38.3,
        'lhResult': 'منفی',
        'notes': 'احساس خستگی مداوم',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'temperature': 38.4,
        'lhResult': 'منفی',
        'notes': '',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'temperature': 38.3,
        'lhResult': 'منفی',
        'notes': '',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه باروری شما'),
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

    if (lhResult == 'حداکثر') {
      cardColor = const Color.fromARGB(255, 12, 190, 6).withOpacity(0.1);
      fertilityStatus = 'حداکثر میزان باروری';
    } else if (lhResult == 'بالا') {
      cardColor = Colors.amberAccent.withOpacity(0.1);
      fertilityStatus = 'باروری با درصد موفقیت بالا';
    } else if (temperature > 38.0) {
      cardColor = Colors.purple.withOpacity(0.1);
      fertilityStatus = 'پس از تخمک گذاری';
    } else {
      cardColor = const Color.fromARGB(122, 225, 240, 88).withOpacity(0.1);
      fertilityStatus = 'باروری با درصد موفقیت کم';
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
                    color: cardColor.withOpacity(0.9),
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
                    'دما',
                    '${temperature.toStringAsFixed(1)}°C',
                    Icons.thermostat,
                  ),
                ),
                Expanded(
                  child: _buildDataItem(
                    context,
                    'LH نتیجه',
                    _formatLHResult(lhResult),
                    Icons.water_drop,
                  ),
                ),
              ],
            ),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'یادداشت:',
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
      case 'منفی':
        return 'منفی';
      case 'پایین':
        return 'پایین';
      case 'بالا':
        return 'بالا';
      case 'حداکثر':
        return 'حداکثر';
      default:
        return result;
    }
  }
}