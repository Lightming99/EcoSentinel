// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:EcoSentinel/features/home/widgets/activity_iteam.dart';
import '../../../core/theme/colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UNColors.unBackground,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: UNColors.unBlue,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 130,
              floating: false,
              pinned: true,
              backgroundColor: UNColors.unBlue,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        UNColors.unBlue,
                        UNColors.unLightBlue,
                      ],
                    ),
                  ),
                  child: const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: UNColors.unWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'EcoSentinel: Environmental Chatbot',
                            style: TextStyle(
                              color: UNColors.unWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: UNColors.unWhite,
                  onPressed: () {
                    // Handle notifications
                  },
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Environmental Stats
                    const Text(
                      'Environmental Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        StatCard(
                          title: 'Air Quality',
                          value: '72',
                          unit: 'AQI',
                          icon: Icons.air,
                          statusColor: UNColors.unGreen,
                          status: 'Good',
                          onTap: () {
                            // Navigate to air quality details
                          },
                        ),
                        StatCard(
                          title: 'Water Quality',
                          value: '8.2',
                          unit: 'pH',
                          icon: Icons.water_drop,
                          statusColor: UNColors.unGreen,
                          status: 'Excellent',
                          onTap: () {
                            // Navigate to water quality details
                          },
                        ),
                        StatCard(
                          title: 'Waste Level',
                          value: '68',
                          unit: '%',
                          icon: Icons.delete_outline,
                          statusColor: UNColors.unOrange,
                          status: 'Moderate',
                          onTap: () {
                            // Navigate to waste management
                          },
                        ),
                        StatCard(
                          title: 'Energy Usage',
                          value: '2.4',
                          unit: 'MW',
                          icon: Icons.bolt,
                          statusColor: UNColors.unGreen,
                          status: 'Efficient',
                          onTap: () {
                            // Navigate to energy details
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // const SizedBox(height: 0.15),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        ActionButton(
                          title: 'Report Incident',
                          subtitle: 'Environmental issues',
                          icon: Icons.report_problem,
                          iconColor: UNColors.unRed,
                          onTap: () {
                            // Navigate to report screen
                          },
                        ),
                        ActionButton(
                          title: 'View Policies',
                          subtitle: 'Environmental laws',
                          icon: Icons.policy,
                          iconColor: UNColors.unBlue,
                          onTap: () {
                            // Navigate to policies
                          },
                        ),
                        ActionButton(
                          title: 'Data Analytics',
                          subtitle: 'Environmental trends',
                          icon: Icons.analytics,
                          iconColor: UNColors.unGreen,
                          onTap: () {
                            // Navigate to analytics
                          },
                        ),
                        ActionButton(
                          title: 'Ask Assistant',
                          subtitle: 'Get help & info',
                          icon: Icons.chat,
                          iconColor: UNColors.unLightBlue,
                          onTap: () {
                            // Navigate to chat
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Recent Activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // View all activities
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: UNColors.unBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Activity List
                    ActivityItem(
                      title: 'Air Quality Alert',
                      description: 'AQI levels increased in downtown area',
                      timestamp:
                          DateTime.now().subtract(const Duration(minutes: 15)),
                      icon: Icons.warning,
                      iconColor: UNColors.unOrange,
                      onTap: () {
                        // View alert details
                      },
                    ),
                    ActivityItem(
                      title: 'Water Quality Report',
                      description: 'Monthly water quality assessment completed',
                      timestamp:
                          DateTime.now().subtract(const Duration(hours: 2)),
                      icon: Icons.water_drop,
                      iconColor: UNColors.unBlue,
                      onTap: () {
                        // View report
                      },
                    ),
                    ActivityItem(
                      title: 'Incident Resolved',
                      description:
                          'Waste overflow issue at Park Street resolved',
                      timestamp:
                          DateTime.now().subtract(const Duration(hours: 4)),
                      icon: Icons.check_circle,
                      iconColor: UNColors.unGreen,
                      onTap: () {
                        // View incident details
                      },
                    ),
                    ActivityItem(
                      title: 'Policy Update',
                      description: 'New environmental regulation published',
                      timestamp:
                          DateTime.now().subtract(const Duration(days: 1)),
                      icon: Icons.policy,
                      iconColor: UNColors.unBlue,
                      onTap: () {
                        // View policy
                      },
                    ),

                    const SizedBox(
                        height: 100), // Bottom padding for navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Refresh UI
    });
  }
}
