import 'package:flutter/material.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.book,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fertility Education',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Learn about tracking fertility for conception',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 16),
            _buildEducationItem(
              context,
              'Understanding LH Surges',
              'A surge in luteinizing hormone (LH) triggers ovulation. LH levels typically surge 24-36 hours before ovulation, making this your most fertile time. Track LH with urine test strips.',
            ),
            const SizedBox(height: 12),
            _buildEducationItem(
              context,
              'Basal Body Temperature (BBT)',
              'Your BBT rises slightly (0.2-0.5°F) after ovulation due to increased progesterone. Measure first thing in the morning before getting out of bed for accurate readings.',
            ),
            const SizedBox(height: 12),
            _buildEducationItem(
              context,
              'Optimal Timing',
              'The fertile window includes the 5 days before ovulation and the day of ovulation. Having intercourse every 1-2 days during this window maximizes pregnancy chances.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/education');
                },
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationItem(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.labelMedium?.color,
              ),
        ),
      ],
    );
  }
}