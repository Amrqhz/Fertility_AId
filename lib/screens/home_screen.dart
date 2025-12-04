import 'package:flutter/material.dart';
import 'package:fertility_aid/widgets/fertility_status_card.dart';
import 'package:fertility_aid/widgets/fertility_chart.dart';
import 'package:fertility_aid/widgets/education_card.dart';
import 'package:fertility_aid/widgets/protips.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Fertility AId'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.person, size: 25),
                onPressed: () => Navigator.pushReplacementNamed(context, "/info"),
              ),
              SizedBox(width: 5),
              const FertilityStatusCard(),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.show_chart,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'نمودار باروری شما',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'داده های مرتبط با وضعیت باروری شما در طی سیکل',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(
                        height: 250,
                        child: FertilityChart(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          child: const Text('مرور کامل وضعیت شما'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Protips(),
              const EducationCard(),
            ],
          ),
        ),
      ),
    );
  }
}