import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogDataScreen extends StatefulWidget {
  const LogDataScreen({Key? key}) : super(key: key);

  @override
  State<LogDataScreen> createState() => _LogDataScreenState();
}

class _LogDataScreenState extends State<LogDataScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _temperatureController = TextEditingController();
  String _lhResult = 'منفی';
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _temperatureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, save this data to a database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اطلاعات با موفقیت ثبت شد!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اطلاعات کاربری'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تاریخ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('MMMM d, yyyy').format(_selectedDate),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select the date for this measurement',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          'دمای پایه ی بدن (°c)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _temperatureController,
                          decoration: const InputDecoration(
                            hintText: '37.8',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا دما را وارد کنید';
                            }
                            final temp = double.tryParse(value);
                            if (temp == null) {
                              return 'لطفا یک عدد درست وارد کنید';
                            }
                            if (temp < 96 || temp > 100) {
                              return 'دما باید بین 36 الی 38 درجه سیلسیوس باشد';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'دما را در اولین فرصت پس از بیدار شدن از خواب در هنگام صبح وارد کنید',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          'نتیجه تست LH',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildLHRadioGroup(),
                        const SizedBox(height: 4),
                        Text(
                          'نتیجه تست LH را براساس کیت انتخاب کنید',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          'یادداشت (اختیاری)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            hintText: 'مشاهدات اضافی ...',
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Record any other symptoms or observations',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 24),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('ذخیره اطلاعات '),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLHRadioGroup() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('منفی (بدون تست) '),
          value: 'منفی',
          groupValue: _lhResult,
          onChanged: (value) {
            setState(() {
              _lhResult = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Low (test line lighter than control)'),
          value: 'پایین',
          groupValue: _lhResult,
          onChanged: (value) {
            setState(() {
              _lhResult = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('High (test line similar to control)'),
          value: 'بالا',
          groupValue: _lhResult,
          onChanged: (value) {
            setState(() {
              _lhResult = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('حداکثر (نتیجه تست از خط کنترل تیره تر میباشد)'),
          value: 'حداکثر',
          groupValue: _lhResult,
          onChanged: (value) {
            setState(() {
              _lhResult = value!;
            });
          },
        ),
      ],
    );
  }
}