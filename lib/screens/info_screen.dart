import 'package:flutter/material.dart';
import '../models/info.dart';

class UserInfoDisplayPage extends StatefulWidget {
  const UserInfoDisplayPage({Key? key}) : super(key: key);

  @override
  State<UserInfoDisplayPage> createState() => _UserInfoDisplayPageState();
}

class _UserInfoDisplayPageState extends State<UserInfoDisplayPage> {
  UserInfoModel? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await UserInfoService.getUserInfo();
      setState(() {
        _userInfo = userInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading user info: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userInfo == null
              ? _buildEmptyState()
              : _buildProfileContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Profile Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up your profile to get started',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _editProfile(),
            child: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(),
          
          // Profile Information Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPersonalInfoCard(),
                const SizedBox(height: 16),
                _buildCycleInfoCard(),
                const SizedBox(height: 16),
                _buildHealthInfoCard(),
                const SizedBox(height: 16),
                _buildSymptomsCard(),
                if (_userInfo!.notes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildNotesCard(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userInfo!.name.isNotEmpty ? _userInfo!.name : 'User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (_userInfo!.age > 0) ...[
                const SizedBox(height: 8),
                Text(
                  'Age: ${_userInfo!.age}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return _buildInfoCard(
      title: 'Personal Information',
      icon: Icons.person,
      children: [
        if (_userInfo!.weight > 0)
          _buildInfoRow('Weight', '${_userInfo!.weight.toStringAsFixed(1)} kg'),
        if (_userInfo!.height > 0)
          _buildInfoRow('Height', '${_userInfo!.height.toStringAsFixed(1)} cm'),
        if (_userInfo!.weight > 0 && _userInfo!.height > 0)
          _buildInfoRow('BMI', _calculateBMI()),
      ],
    );
  }

  Widget _buildCycleInfoCard() {
    return _buildInfoCard(
      title: 'Cycle Information',
      icon: Icons.calendar_month,
      children: [
        _buildInfoRow('Average Cycle Length', '${_userInfo!.averageCycleLength} days'),
        _buildInfoRow('Average Period Length', '${_userInfo!.averagePeriodLength} days'),
        if (_userInfo!.lastPeriodDate != null)
          _buildInfoRow(
            'Last Period Date',
            '${_userInfo!.lastPeriodDate!.day}/${_userInfo!.lastPeriodDate!.month}/${_userInfo!.lastPeriodDate!.year}',
          ),
        if (_userInfo!.lastPeriodDate != null)
          _buildInfoRow('Days Since Last Period', _getDaysSinceLastPeriod()),
      ],
    );
  }

  Widget _buildHealthInfoCard() {
    return _buildInfoCard(
      title: 'Health Information',
      icon: Icons.medical_services,
      children: [
        _buildInfoRow('Contraceptive Method', _userInfo!.contraceptiveMethod),
        _buildInfoRow('Temperature Unit', _userInfo!.temperatureUnit),
      ],
    );
  }

  Widget _buildSymptomsCard() {
    if (_userInfo!.symptoms.isEmpty) return const SizedBox.shrink();
    
    return _buildInfoCard(
      title: 'Common Symptoms',
      icon: Icons.healing,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _userInfo!.symptoms.map((symptom) {
            return Chip(
              label: Text(
                symptom,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              side: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return _buildInfoCard(
      title: 'Notes',
      icon: Icons.note,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            _userInfo!.notes,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateBMI() {
    if (_userInfo!.weight > 0 && _userInfo!.height > 0) {
      final heightInMeters = _userInfo!.height / 100;
      final bmi = _userInfo!.weight / (heightInMeters * heightInMeters);
      return '${bmi.toStringAsFixed(1)} ${_getBMICategory(bmi)}';
    }
    return 'N/A';
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return '(Underweight)';
    if (bmi < 25) return '(Normal)';
    if (bmi < 30) return '(Overweight)';
    return '(Obese)';
  }

  String _getDaysSinceLastPeriod() {
    if (_userInfo!.lastPeriodDate != null) {
      final daysSince = DateTime.now().difference(_userInfo!.lastPeriodDate!).inDays;
      return '$daysSince days ago';
    }
    return 'N/A';
  }

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoDashboard(
          isFirstTime: false,
          existingUserInfo: _userInfo,
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        _userInfo = result as UserInfoModel;
      });
    }
  }
}