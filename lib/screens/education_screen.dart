import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertility Education'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Understanding Your Fertility',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                context,
                'The Menstrual Cycle',
                'The menstrual cycle is typically 28 days but can range from 21-35 days. It consists of the follicular phase (before ovulation) and the luteal phase (after ovulation).',
                Icons.calendar_month,
                [
                  'Day 1-5: Menstruation',
                  'Day 6-13: Follicular phase, estrogen rises',
                  'Day 14: Ovulation (in a 28-day cycle)',
                  'Day 15-28: Luteal phase, progesterone rises',
                ],
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                context,
                'Luteinizing Hormone (LH)',
                'LH is the hormone that triggers ovulation. A surge in LH occurs 24-36 hours before ovulation, making this your most fertile time.',
                Icons.water_drop,
                [
                  'Negative: No visible test line',
                  'Low: Test line lighter than control line',
                  'High: Test line similar to control line',
                  'Peak: Test line darker than control line (LH surge)',
                  'Test LH daily during your fertile window',
                  'Best time to test is between 10am-8pm',
                  'Reduce liquid intake 2 hours before testing',
                ],
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                context,
                'Basal Body Temperature (BBT)',
                'BBT is your body temperature at rest. It rises slightly (0.2-0.5°F) after ovulation due to increased progesterone levels.',
                Icons.thermostat,
                [
                  'Take temperature immediately upon waking',
                  'Use a BBT thermometer for accuracy',
                  'Take temperature at the same time each day',
                  'Record temperature before getting out of bed',
                  'A sustained temperature rise confirms ovulation has occurred',
                  'Temperature remains elevated until your next period',
                ],
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                context,
                'Cervical Mucus Changes',
                'Cervical mucus changes throughout your cycle in response to hormonal fluctuations. Fertile mucus helps sperm survive and reach the egg.',
                Icons.opacity,
                [
                  'After period: Dry or sticky (not fertile)',
                  'Approaching ovulation: Creamy, like lotion (becoming fertile)',
                  'Most fertile: Slippery, stretchy, like egg white (very fertile)',
                  'After ovulation: Returns to sticky or dry (not fertile)',
                  'Check cervical mucus daily for changes',
                ],
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                context,
                'Maximizing Conception Chances',
                'Timing intercourse around your fertile window maximizes your chances of conception.',
                Icons.favorite,
                [
                  'The fertile window is about 6 days: 5 days before ovulation and the day of ovulation',
                  'Sperm can survive up to 5 days in fertile cervical mucus',
                  'An egg lives for only 12-24 hours after ovulation',
                  'Having intercourse every 1-2 days during your fertile window is optimal',
                  'The two days before ovulation are the most fertile',
                ],
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                context,
                'Factors Affecting Fertility',
                'Various factors can affect your fertility and cycle regularity.',
                Icons.info_outline,
                [
                  'Age: Fertility declines with age, especially after 35',
                  'Stress: Can delay ovulation or cause irregular cycles',
                  'Weight: Being significantly under or overweight can affect ovulation',
                  'Sleep: Poor sleep can disrupt hormone production',
                  'Medications: Some medications can affect fertility',
                  'Health conditions: PCOS, endometriosis, thyroid disorders can impact fertility',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    List<String> bulletPoints,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...bulletPoints.map((point) => _buildBulletPoint(context, point)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}