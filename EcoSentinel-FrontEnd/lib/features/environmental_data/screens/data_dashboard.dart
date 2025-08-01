// lib/features/environmental_data/screens/data_dashboard.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';

class DataDashboard extends StatefulWidget {
  const DataDashboard({super.key});

  @override
  State<DataDashboard> createState() => _DataDashboardState();
}

class _DataDashboardState extends State<DataDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedTimeRange = 'Today';
  final List<String> _timeRanges = ['Today', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UNColors.unBackground,
      appBar: const CustomAppBar(
        title: 'Environmental Data',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Time Range Selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Time Range:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _timeRanges.map((range) {
                        final isSelected = _selectedTimeRange == range;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(range),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTimeRange = range;
                              });
                              _loadData();
                            },
                            selectedColor: UNColors.unBlue.withOpacity(0.2),
                            checkmarkColor: UNColors.unBlue,
                            labelStyle: TextStyle(
                              color:
                                  isSelected ? UNColors.unBlue : Colors.black54,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: UNColors.unBlue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: UNColors.unBlue,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Air Quality'),
                Tab(text: 'Water'),
                Tab(text: 'Waste'),
                Tab(text: 'Energy'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: _isLoading
                ? const LoadingIndicator()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAirQualityTab(),
                      _buildWaterQualityTab(),
                      _buildWasteTab(),
                      _buildEnergyTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Status Card
          _buildStatusCard(
            title: 'Air Quality Index',
            value: '72',
            unit: 'AQI',
            status: 'Good',
            statusColor: UNColors.unGreen,
            icon: Icons.air,
            description:
                'Air quality is satisfactory with little risk to health.',
          ),

          const SizedBox(height: 24),

          // Chart
          _buildChartSection(
            title: 'AQI Trend',
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 65),
                        const FlSpot(1, 70),
                        const FlSpot(2, 68),
                        const FlSpot(3, 72),
                        const FlSpot(4, 75),
                        const FlSpot(5, 73),
                        const FlSpot(6, 72),
                      ],
                      isCurved: true,
                      color: UNColors.unBlue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pollutant Breakdown
          _buildPollutantBreakdown(),
        ],
      ),
    );
  }

  Widget _buildWaterQualityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(
            title: 'Water Quality',
            value: '8.2',
            unit: 'pH',
            status: 'Excellent',
            statusColor: UNColors.unGreen,
            icon: Icons.water_drop,
            description: 'Water quality meets all safety standards.',
          ),
          const SizedBox(height: 24),
          _buildChartSection(
            title: 'pH Levels',
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: 7.5 + (index * 0.1),
                          color: UNColors.unBlue,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildWaterParameters(),
        ],
      ),
    );
  }

  Widget _buildWasteTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(
            title: 'Waste Level',
            value: '68',
            unit: '%',
            status: 'Moderate',
            statusColor: UNColors.unOrange,
            icon: Icons.delete_outline,
            description: 'Waste levels are moderate. Consider optimization.',
          ),
          const SizedBox(height: 24),
          _buildChartSection(
            title: 'Waste Distribution',
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: UNColors.unBlue,
                      value: 35,
                      title: 'Organic\n35%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: UNColors.unGreen,
                      value: 25,
                      title: 'Recyclable\n25%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: UNColors.unOrange,
                      value: 20,
                      title: 'Plastic\n20%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: UNColors.unRed,
                      value: 20,
                      title: 'Hazardous\n20%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildWasteMetrics(),
        ],
      ),
    );
  }

  Widget _buildEnergyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(
            title: 'Energy Usage',
            value: '2.4',
            unit: 'MW',
            status: 'Efficient',
            statusColor: UNColors.unGreen,
            icon: Icons.bolt,
            description: 'Energy consumption is within optimal range.',
          ),
          const SizedBox(height: 24),
          _buildChartSection(
            title: 'Energy Consumption',
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 2.1),
                        const FlSpot(1, 2.3),
                        const FlSpot(2, 2.2),
                        const FlSpot(3, 2.4),
                        const FlSpot(4, 2.6),
                        const FlSpot(5, 2.3),
                        const FlSpot(6, 2.4),
                      ],
                      isCurved: true,
                      color: UNColors.unGreen,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildEnergyBreakdown(),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required String unit,
    required String status,
    required Color statusColor,
    required IconData icon,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            unit,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildPollutantBreakdown() {
    final pollutants = [
      {
        'name': 'PM2.5',
        'value': '45',
        'unit': 'μg/m³',
        'color': UNColors.unGreen
      },
      {
        'name': 'PM10',
        'value': '65',
        'unit': 'μg/m³',
        'color': UNColors.unOrange
      },
      {'name': 'NO2', 'value': '32', 'unit': 'ppb', 'color': UNColors.unGreen},
      {'name': 'SO2', 'value': '8', 'unit': 'ppb', 'color': UNColors.unGreen},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pollutant Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...pollutants.map((pollutant) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pollutant['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${pollutant['value']} ${pollutant['unit']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: pollutant['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterParameters() {
    final parameters = [
      {
        'name': 'pH Level',
        'value': '8.2',
        'range': '6.5-8.5',
        'status': 'Normal'
      },
      {
        'name': 'Dissolved Oxygen',
        'value': '7.8',
        'range': '> 6.0',
        'status': 'Good'
      },
      {
        'name': 'Turbidity',
        'value': '2.1',
        'range': '< 4.0',
        'status': 'Excellent'
      },
      {
        'name': 'Temperature',
        'value': '22°C',
        'range': '15-25°C',
        'status': 'Normal'
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Water Parameters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...parameters.map((param) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              param['name'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Range: ${param['range']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          param['value'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: UNColors.unGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            param['status'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: UNColors.unGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteMetrics() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Waste Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child:
                      _buildMetricItem('Total Waste', '142 tons', Icons.delete),
                ),
                Expanded(
                  child:
                      _buildMetricItem('Recycled', '35 tons', Icons.recycling),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child:
                      _buildMetricItem('Landfill', '87 tons', Icons.landscape),
                ),
                Expanded(
                  child:
                      _buildMetricItem('Composted', '20 tons', Icons.compost),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyBreakdown() {
    final sources = [
      {'name': 'Solar', 'percentage': 35, 'color': UNColors.unOrange},
      {'name': 'Wind', 'percentage': 25, 'color': UNColors.unBlue},
      {'name': 'Hydro', 'percentage': 20, 'color': UNColors.unLightBlue},
      {'name': 'Grid', 'percentage': 20, 'color': Colors.grey},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Energy Sources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...sources.map((source) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: source['color'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          source['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${source['percentage']}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UNColors.unBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: UNColors.unBlue, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
