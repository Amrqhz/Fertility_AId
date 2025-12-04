import 'package:flutter/material.dart';

class Protips extends StatefulWidget {
  const Protips({Key? key}) : super(key: key);

  @override
  State<Protips> createState() => _ProtipsState();
}

class _ProtipsState extends State<Protips> {
  bool isExpanded = false;

  final List<Map<String, String>> proTips = [
    {
      'title': 'بهترین زمان برای باروری',
      'tip':
          'Have intercourse every other day during your fertile window, which is typically 5 days before and the day of ovulation.',
    },
    {
      'title': 'سیکل قاعدگیت رو کنترل کن',
      'tip':
          'Monitor basal body temperature and cervical mucus changes to better identify your most fertile days.',
    },
    {
      'title': 'سبک زندگی سالم ',
      'tip':
          'Maintain a balanced diet rich in folic acid, limit caffeine and alcohol, and exercise regularly but not excessively.',
    },
    {
      'title': 'مدیریت استرس و اضطراب',
      'tip':
          'High stress levels can affect ovulation. Practice relaxation techniques like meditation, yoga, or deep breathing.',
    },
    {
      'title': 'حمایت پارتنر',
      'tip':
          'Men should maintain healthy habits too - avoid excessive heat, limit smoking and alcohol, and eat antioxidant-rich foods.',
    },
    {
      'title': 'زمانبندی مهمه',
      'tip':
          'Sperm can live up to 5 days in the female reproductive tract, so timing intercourse before ovulation is beneficial.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFECEC), // Pink background matching your image
      child: Column(
        children: [
          // Header section
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Sun icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.wb_sunny,
                      color: Colors.yellow,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title
                  Expanded(
                    child: Text(
                      'نکات حیاتی',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  // Dropdown arrow
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child:
                isExpanded
                    ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          const Divider(color: Colors.black26),
                          const SizedBox(height: 8),
                          ...proTips
                              .map(
                                (tip) => _buildTipItem(
                                  context,
                                  tip['title']!,
                                  tip['tip']!,
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String title, String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tip,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
