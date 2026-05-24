import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Health',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMetricCard(
                title: 'CPU Usage',
                value: '42%',
                icon: Icons.memory,
                color: Colors.blue,
              ),
              _buildMetricCard(
                title: 'Memory Usage',
                value: '1.2 GB',
                icon: Icons.storage,
                color: Colors.purple,
              ),
              _buildMetricCard(
                title: 'Active Nodes',
                value: '0 / 4',
                icon: Icons.router,
                color: Colors.orange,
              ),
              _buildMetricCard(
                title: 'Uptime',
                value: '02:14:30',
                icon: Icons.access_time,
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActivityLog(),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(color: Color(0xFF3A3A3A)),
        itemBuilder: (context, index) {
          final logs = [
            'System started in simulation mode.',
            'Model inference initialized.',
            'WebSocket connection established.',
            'Searching for ESP32 nodes on network...',
            'No ESP32 nodes found. Using simulated data.',
          ];
          final times = [
            '2 mins ago',
            '2 mins ago',
            '3 mins ago',
            '3 mins ago',
            '3 mins ago',
          ];
          return ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: Text(logs[index]),
            subtitle: Text(times[index]),
          );
        },
      ),
    );
  }
}
