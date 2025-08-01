// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:EcoSentinel/shared/widgets/custom_app_bar.dart';
import '../../../core/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  bool _highContrastEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedFontSize = 'Medium';

  final List<String> _availableLanguages = [
    'English',
    'Spanish',
    'French',
    'Arabic',
  ];

  final List<String> _fontSizes = [
    'Small',
    'Medium',
    'Large',
    'Extra Large',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UNColors.unBackground,
      appBar: const CustomAppBar(
        title: 'Profile & Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: UNColors.unBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Environmental Officer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'officer@un-environment.org',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _editProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: UNColors.unBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Settings Sections
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notifications Section
                  _buildSectionCard(
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    children: [
                      _buildSwitchTile(
                        title: 'Push Notifications',
                        subtitle: 'Receive environmental alerts',
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                      _buildListTile(
                        title: 'Notification Settings',
                        subtitle: 'Customize alert preferences',
                        icon: Icons.tune,
                        onTap: _openNotificationSettings,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Security
                  _buildSectionCard(
                    title: 'Privacy & Security',
                    icon: Icons.security,
                    children: [
                      _buildSwitchTile(
                        title: 'Location Services',
                        subtitle: 'Allow location-based features',
                        value: _locationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _locationEnabled = value;
                          });
                        },
                      ),
                      _buildListTile(
                        title: 'Data & Privacy',
                        subtitle: 'Manage your data preferences',
                        icon: Icons.privacy_tip_outlined,
                        onTap: _openPrivacySettings,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Accessibility
                  _buildSectionCard(
                    title: 'Accessibility',
                    icon: Icons.accessibility,
                    children: [
                      _buildDropdownTile(
                        title: 'Font Size',
                        subtitle: 'Adjust text size for readability',
                        value: _selectedFontSize,
                        items: _fontSizes,
                        onChanged: (value) {
                          setState(() {
                            _selectedFontSize = value!;
                          });
                        },
                      ),
                      _buildSwitchTile(
                        title: 'High Contrast',
                        subtitle: 'Improve visibility and readability',
                        value: _highContrastEnabled,
                        onChanged: (value) {
                          setState(() {
                            _highContrastEnabled = value;
                          });
                        },
                      ),
                      _buildListTile(
                        title: 'Voice Settings',
                        subtitle: 'Configure speech and audio',
                        icon: Icons.record_voice_over,
                        onTap: _openVoiceSettings,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Language & Region
                  _buildSectionCard(
                    title: 'Language & Region',
                    icon: Icons.language,
                    children: [
                      _buildDropdownTile(
                        title: 'Language',
                        subtitle: 'Choose your preferred language',
                        value: _selectedLanguage,
                        items: _availableLanguages,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                      ),
                      _buildListTile(
                        title: 'Region Settings',
                        subtitle: 'Date, time, and number format',
                        icon: Icons.location_on_outlined,
                        onTap: _openRegionSettings,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // App Settings
                  _buildSectionCard(
                    title: 'App Settings',
                    icon: Icons.settings,
                    children: [
                      _buildSwitchTile(
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme',
                        value: _darkModeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _darkModeEnabled = value;
                          });
                        },
                      ),
                      _buildListTile(
                        title: 'Data Usage',
                        subtitle: 'Manage offline and sync settings',
                        icon: Icons.data_usage,
                        onTap: _openDataUsageSettings,
                      ),
                      _buildListTile(
                        title: 'Storage',
                        subtitle: 'Manage app storage and cache',
                        icon: Icons.storage,
                        onTap: _openStorageSettings,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Support & Information
                  _buildSectionCard(
                    title: 'Support & Information',
                    icon: Icons.help_outline,
                    children: [
                      _buildListTile(
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        icon: Icons.help,
                        onTap: _openHelpCenter,
                      ),
                      _buildListTile(
                        title: 'Contact Support',
                        subtitle: 'Reach out to our support team',
                        icon: Icons.contact_support,
                        onTap: _contactSupport,
                      ),
                      _buildListTile(
                        title: 'About',
                        subtitle: 'App version and information',
                        icon: Icons.info_outline,
                        onTap: _showAboutDialog,
                      ),
                      _buildListTile(
                        title: 'Terms of Service',
                        subtitle: 'View terms and conditions',
                        icon: Icons.description,
                        onTap: _openTermsOfService,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UNColors.unRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: UNColors.unBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: UNColors.unBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: UNColors.unBlue,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black54,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black54,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: UNColors.unBlue,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: UNColors.unBlue,
        ),
      ),
    );
  }

  // Action Methods
  void _editProfile() {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit Profile feature coming soon'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openNotificationSettings() {
    // Navigate to notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openPrivacySettings() {
    // Navigate to privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openVoiceSettings() {
    // Navigate to voice settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice settings opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openRegionSettings() {
    // Navigate to region settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Region settings opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openDataUsageSettings() {
    // Navigate to data usage settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data usage settings opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openStorageSettings() {
    // Navigate to storage settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Storage settings opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _openHelpCenter() {
    // Navigate to help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help center opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _contactSupport() {
    // Open contact support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact support opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About EcoSentinel'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Build: 2024.12.01'),
            SizedBox(height: 16),
            Text(
              'UN Environmental Governance application for managing environmental practices and policies.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openTermsOfService() {
    // Navigate to terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of service opened'),
        backgroundColor: UNColors.unBlue,
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully'),
                  backgroundColor: UNColors.unGreen,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: UNColors.unRed,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
