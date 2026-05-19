import 'package:flutter/material.dart';

class DashboardDevice {
  const DashboardDevice({
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

const List<DashboardDevice> dashboardDevices = [
  DashboardDevice(
    icon: Icons.lightbulb_outline,
    name: 'Lighting',
    status: '6 lights on',
    color: Color(0xFFFFC107),
  ),
  DashboardDevice(
    icon: Icons.thermostat,
    name: 'Climate',
    status: '22 °C',
    color: Color(0xFF00BCD4),
  ),
  DashboardDevice(
    icon: Icons.security,
    name: 'Security',
    status: 'All clear',
    color: Color(0xFF4CAF50),
  ),
  DashboardDevice(
    icon: Icons.bolt,
    name: 'Energy',
    status: '3.4 kWh today',
    color: Color(0xFFFF9800),
  ),
];
