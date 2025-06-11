import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserInfoModel {
  String name;
  int age;
  double weight;
  double height;
  int averageCycleLength;
  int averagePeriodLength;
  DateTime? lastPeriodDate;
  String contraceptiveMethod;
  List<String> symptoms;
  String temperatureUnit;
  String notes;

  UserInfoModel({
    this.name = '',
    this.age = 0,
    this.weight = 0.0,
    this.height = 0.0,
    this.averageCycleLength = 28,
    this.averagePeriodLength = 5,
    this.lastPeriodDate,
    this.contraceptiveMethod = 'None',
    this.symptoms = const [],
    this.temperatureUnit = 'Celsius',
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'averageCycleLength': averageCycleLength,
      'averagePeriodLength': averagePeriodLength,
      'lastPeriodDate': lastPeriodDate?.millisecondsSinceEpoch,
      'contraceptiveMethod': contraceptiveMethod,
      'symptoms': symptoms,
      'temperatureUnit': temperatureUnit,
      'notes': notes,
    };
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      weight: json['weight']?.toDouble() ?? 0.0,
      height: json['height']?.toDouble() ?? 0.0,
      averageCycleLength: json['averageCycleLength'] ?? 28,
      averagePeriodLength: json['averagePeriodLength'] ?? 5,
      lastPeriodDate: json['lastPeriodDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['lastPeriodDate'])
          : null,
      contraceptiveMethod: json['contraceptiveMethod'] ?? 'None',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      temperatureUnit: json['temperatureUnit'] ?? 'Celsius',
      notes: json['notes'] ?? '',
    );
  }
}

class UserInfoService {
  static const String _userInfoKey = 'user_info';

  static Future<void> saveUserInfo(UserInfoModel userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userInfo.toJson()); 
    await prefs.setString(_userInfoKey, jsonString.toString());
  }

  static Future<UserInfoModel> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userInfoKey);
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString); // Fixed: Use jsonDecode
        return UserInfoModel.fromJson(jsonMap);
      } catch (e) {
        print('Error parsing user info: $e');
        return UserInfoModel();
      }
    }
    return UserInfoModel();
  }

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_userInfoKey);
  }
}

class UserInfoDashboard extends StatefulWidget {
  final bool isFirstTime;
  final UserInfoModel? existingUserInfo;

  const UserInfoDashboard({
    Key? key,
    this.isFirstTime = false,
    this.existingUserInfo,
  }) : super(key: key);

  @override
  State<UserInfoDashboard> createState() => _UserInfoDashboardState();
}

class _UserInfoDashboardState extends State<UserInfoDashboard> {
  final _formKey = GlobalKey<FormState>();
  late UserInfoModel _userInfo;
  
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _cycleLengthController = TextEditingController();
  final _periodLengthController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String _selectedContraceptive = 'None';
  String _selectedTempUnit = 'Celsius';
  List<String> _selectedSymptoms = [];

  final List<String> _contraceptiveMethods = [
    'None',
    'Birth Control Pills',
    'IUD',
    'Condoms',
    'Implant',
    'Injection',
    'Patch',
    'Ring',
    'Other'
  ];

  final List<String> _commonSymptoms = [
    'Cramps',
    'Bloating',
    'Mood Swings',
    'Headaches',
    'Breast Tenderness',
    'Fatigue',
    'Acne',
    'Food Cravings',
    'Back Pain',
    'Nausea'
  ];

  @override
  void initState() {
    super.initState();
    _userInfo = widget.existingUserInfo ?? UserInfoModel();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = _userInfo.name;
    _ageController.text = _userInfo.age > 0 ? _userInfo.age.toString() : '';
    _weightController.text = _userInfo.weight > 0 ? _userInfo.weight.toString() : '';
    _heightController.text = _userInfo.height > 0 ? _userInfo.height.toString() : '';
    _cycleLengthController.text = _userInfo.averageCycleLength.toString();
    _periodLengthController.text = _userInfo.averagePeriodLength.toString();
    _notesController.text = _userInfo.notes;
    _selectedDate = _userInfo.lastPeriodDate;
    _selectedContraceptive = _userInfo.contraceptiveMethod;
    _selectedTempUnit = _userInfo.temperatureUnit;
    _selectedSymptoms = List.from(_userInfo.symptoms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirstTime ? 'Welcome! Set Up Your Profile' : 'Edit Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isFirstTime) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.pink, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Let\'s get to know you better!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.pink.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This information helps us provide accurate fertility predictions and personalized insights.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.pink.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Personal Information Section
              _buildSectionTitle('Personal Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                validator: (value) => value?.isEmpty == true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _ageController,
                      label: 'Age',
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Please enter your age';
                        final age = int.tryParse(value!);
                        if (age == null || age < 12 || age > 60) {
                          return 'Please enter a valid age (12-60)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      label: 'Weight (kg)',
                      icon: Icons.monitor_weight,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _heightController,
                      label: 'Height (cm)',
                      icon: Icons.height,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Cycle Information Section
              _buildSectionTitle('Cycle Information'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cycleLengthController,
                      label: 'Average Cycle Length (days)',
                      icon: Icons.calendar_month,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Required';
                        final length = int.tryParse(value!);
                        if (length == null || length < 21 || length > 35) {
                          return 'Enter 21-35 days';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _periodLengthController,
                      label: 'Period Length (days)',
                      icon: Icons.water_drop,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Required';
                        final length = int.tryParse(value!);
                        if (length == null || length < 2 || length > 10) {
                          return 'Enter 2-10 days';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Last Period Date
              _buildDatePicker(),

              const SizedBox(height: 24),

              // Health Information Section
              _buildSectionTitle('Health Information'),
              _buildDropdown(
                value: _selectedContraceptive,
                items: _contraceptiveMethods,
                label: 'Contraceptive Method',
                icon: Icons.medical_services,
                onChanged: (value) => setState(() => _selectedContraceptive = value!),
              ),

              const SizedBox(height: 16),

              _buildDropdown(
                value: _selectedTempUnit,
                items: ['Celsius', 'Fahrenheit'],
                label: 'Temperature Unit',
                icon: Icons.thermostat,
                onChanged: (value) => setState(() => _selectedTempUnit = value!),
              ),

              const SizedBox(height: 16),

              // Symptoms Section
              _buildSectionTitle('Common Symptoms'),
              _buildSymptomsSelector(),

              const SizedBox(height: 24),

              // Notes Section
              _buildSectionTitle('Additional Notes'),
              _buildTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                icon: Icons.note,
                maxLines: 3,
                hint: 'Any additional information about your cycle, health conditions, or medications...',
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.isFirstTime ? 'Complete Setup' : 'Save Changes',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 7)),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(
              _selectedDate != null
                  ? 'Last Period: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Select Last Period Date *',
              style: TextStyle(
                fontSize: 16,
                color: _selectedDate != null ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select symptoms you commonly experience:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonSymptoms.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);
              return FilterChip(
                label: Text(symptom),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSymptoms.add(symptom);
                    } else {
                      _selectedSymptoms.remove(symptom);
                    }
                  });
                },
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                checkmarkColor: Theme.of(context).primaryColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _saveUserInfo()  async{
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      _userInfo = UserInfoModel(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weight: double.tryParse(_weightController.text) ?? 0.0,
        height: double.tryParse(_heightController.text) ?? 0.0,
        averageCycleLength: int.parse(_cycleLengthController.text),
        averagePeriodLength: int.parse(_periodLengthController.text),
        lastPeriodDate: _selectedDate,
        contraceptiveMethod: _selectedContraceptive,
        symptoms: _selectedSymptoms,
        temperatureUnit: _selectedTempUnit,
        notes: _notesController.text,
      );

      try {
        // Save to SharedPreferences
        await UserInfoService.saveUserInfo(_userInfo);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.isFirstTime ? 'Profile created successfully!' : 'Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate based on context
          if (widget.isFirstTime) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pop(context, _userInfo);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your last period date'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}