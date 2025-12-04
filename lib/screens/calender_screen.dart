import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // In a real app, this would come from a database
  final Map<DateTime, List<String>> _events = {
    DateTime.now().subtract(const Duration(days: 2)): ['High Fertility'],
    DateTime.now().subtract(const Duration(days: 1)): ['Peak Fertility'],
    DateTime.now(): ['Ovulation Day'],
    DateTime.now().add(const Duration(days: 1)): ['High Fertility'],
    DateTime.now().add(const Duration(days: 14)): ['Expected Period'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertility Calendar'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Calendar section with constrained height
              Container(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay,
                  // Add height constraint to prevent overflow
                  daysOfWeekHeight: 40,
                  rowHeight: 52,
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Events section
              _buildEventList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final events = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _selectedDay != null
                ? 'Events for ${_selectedDay!.month}/${_selectedDay!.day}/${_selectedDay!.year}'
                : 'Select a day to see events',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (events.isEmpty && _selectedDay != null)
            const Text('No fertility events for this day.'),
          if (events.isNotEmpty)
            ...events.map((event) => _buildEventItem(event)).toList(),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Calendar Legend',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(context, 'Peak Fertility', Colors.red),
                  const SizedBox(height: 8),
                  _buildLegendItem(context, 'High Fertility', Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  _buildLegendItem(context, 'Ovulation Day', Colors.purple),
                  const SizedBox(height: 8),
                  _buildLegendItem(context, 'Expected Period', Colors.grey),
                ],
              ),
            ),
          ),
          // Add bottom padding for scroll space
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEventItem(String event) {
    Color color;
    IconData icon;

    if (event.contains('Peak')) {
      color = Colors.red;
      icon = Icons.favorite;
    } else if (event.contains('High')) {
      color = Theme.of(context).colorScheme.primary;
      icon = Icons.water_drop;
    } else if (event.contains('Ovulation')) {
      color = Colors.purple;
      icon = Icons.egg;
    } else {
      color = Colors.grey;
      icon = Icons.calendar_today;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color.withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(event),
        subtitle: Text(
          _getEventDescription(event),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  String _getEventDescription(String event) {
    if (event.contains('Peak')) {
      return 'Highest chance of conception. Recommended to have intercourse today.';
    } else if (event.contains('High')) {
      return 'Good chance of conception. Recommended to have intercourse every 1-2 days.';
    } else if (event.contains('Ovulation')) {
      return 'Egg release day. Fertility will decline after today.';
    } else {
      return 'Menstruation expected to begin.';
    }
  }

  Widget _buildLegendItem(BuildContext context, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}