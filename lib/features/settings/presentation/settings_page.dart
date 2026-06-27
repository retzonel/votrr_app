import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../auth/data/auth_notifier.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final user = ref.watch(authProvider);
    final scheme = Theme.of(context).colorScheme;

    final email = ref.watch(authRepositoryProvider).currentUser?.email ?? '';
    final vin = email.replaceAll('@votrr.ng', '').toUpperCase();
    final formattedVin = _formatVin(vin);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildProfileCard(context, formattedVin, isDark),
            const SizedBox(height: 24),
            _buildSectionLabel(context, 'Appearance'),
            _buildAppearanceCard(context, ref, isDark),
            const SizedBox(height: 24),
            _buildSectionLabel(context, 'About'),
            _buildAboutCard(context, isDark),
            const SizedBox(height: 24),
            _buildSectionLabel(context, 'Account'),
            _buildAccountCard(context, ref, isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatVin(String raw) {
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(raw[i]);
    }
    return buffer.toString();
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        'Settings',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, String formattedVin, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, AppTheme.deepGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registered Voter',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedVin.isEmpty ? 'Unknown' : formattedVin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Verified Voter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAppearanceCard(
      BuildContext context, WidgetRef ref, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      children: [
        _SettingsTile(
          icon: isDark ? Icons.dark_mode : Icons.light_mode,
          iconColor: isDark ? Colors.deepPurpleAccent : Colors.orange,
          title: 'Dark Mode',
          subtitle: isDark ? 'Currently dark' : 'Currently light',
          trailing: Switch.adaptive(
            value: isDark,
            activeColor: AppTheme.primaryGreen,
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard(BuildContext context, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      children: [
        const _SettingsTile(
          icon: Icons.info_outline,
          iconColor: AppTheme.primaryGreen,
          title: 'Version',
          subtitle: 'Votrr v1.0.0',
          trailing: SizedBox.shrink(),
        ),
        _Divider(isDark: isDark),
        const _SettingsTile(
          icon: Icons.security_outlined,
          iconColor: AppTheme.primaryGreen,
          title: 'Security',
          subtitle: 'Biometric + Firebase Auth',
          trailing: SizedBox.shrink(),
        ),
        _Divider(isDark: isDark),
        const _SettingsTile(
          icon: Icons.storage_outlined,
          iconColor: AppTheme.primaryGreen,
          title: 'Backend',
          subtitle: 'Firebase + Cloud Firestore',
          trailing: SizedBox.shrink(),
        ),
        _Divider(isDark: isDark),
        const _SettingsTile(
          icon: Icons.code_outlined,
          iconColor: AppTheme.primaryGreen,
          title: 'Built with',
          subtitle: 'Flutter · Riverpod · go_router',
          trailing: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAccountCard(BuildContext context, WidgetRef ref, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      children: [
        _SettingsTile(
          icon: Icons.logout,
          iconColor: AppTheme.errorRed,
          title: 'Sign Out',
          subtitle: 'You will need to re-authenticate',
          titleColor: AppTheme.errorRed,
          trailing: const SizedBox.shrink(),
          onTap: () => _showSignOutDialog(context, ref),
        ),
      ],
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to sign out? You will need to authenticate again to access Votrr.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              minimumSize: const Size(0, 44),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(authProvider.notifier).signOut();
    }
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightGrey,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor ??
                          (isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.textDark),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? AppTheme.darkTextMuted : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark ? AppTheme.darkBorder : AppTheme.lightGrey,
    );
  }
}
