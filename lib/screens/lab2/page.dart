import 'package:flutter/material.dart';
import 'package:unik_mobile/screens/lab2/profile_page.dart';
import 'package:unik_mobile/widgets/app_card.dart';

class _DeviceInfo {
  const _DeviceInfo({
    required this.icon,
    required this.name,
    required this.status,
    required this.color,
  });

  final IconData icon;
  final String name;
  final String status;
  final Color color;
}

const _devices = [
  _DeviceInfo(
    icon: Icons.lightbulb_outline,
    name: 'Lighting',
    status: '6 lights on',
    color: Color(0xFFFFC107),
  ),
  _DeviceInfo(
    icon: Icons.thermostat,
    name: 'Climate',
    status: '22 °C',
    color: Color(0xFF00BCD4),
  ),
  _DeviceInfo(
    icon: Icons.security,
    name: 'Security',
    status: 'All clear',
    color: Color(0xFF4CAF50),
  ),
  _DeviceInfo(
    icon: Icons.bolt,
    name: 'Energy',
    status: '3.4 kWh today',
    color: Color(0xFFFF9800),
  ),
];

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.info});

  final _DeviceInfo info;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: info.color, size: 28),
          const SizedBox(height: 12),
          Text(info.name, style: tt.titleMedium),
          const SizedBox(height: 4),
          Text(info.status, style: tt.bodyMedium),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => _goProfile(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,', style: tt.bodyMedium),
                Text('Alex Johnson', style: tt.headlineMedium),
                const SizedBox(height: 20),
                _StatsRow(),
                const SizedBox(height: 24),
                Text('My Devices', style: tt.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _DeviceCard(info: _devices[0])),
                    const SizedBox(width: 8),
                    Expanded(child: _DeviceCard(info: _devices[1])),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _DeviceCard(info: _devices[2])),
                    const SizedBox(width: 8),
                    Expanded(child: _DeviceCard(info: _devices[3])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    const items = [
      ('12', 'Devices'),
      ('8', 'Active'),
      ('1', 'Alerts'),
    ];
    return Row(
      children: [
        for (final (value, label) in items) ...[
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              child: Column(
                children: [
                  Text(value, style: tt.headlineMedium),
                  const SizedBox(height: 2),
                  Text(label, style: tt.bodyMedium),
                ],
              ),
            ),
          ),
          if (label != 'Alerts') const SizedBox(width: 8),
        ],
      ],
    );
  }
}
