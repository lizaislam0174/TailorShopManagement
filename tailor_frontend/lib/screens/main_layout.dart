import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../core/theme/app_theme.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('Tailor Management'),
            ),
      drawer: isDesktop ? null : const _AppDrawer(),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: _AppDrawer(),
            ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final currentRoute = router.routerDelegate.currentConfiguration.fullPath;

    return Drawer(
      backgroundColor: AppTheme.surfaceColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cut, size: 40, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Tailor Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            isSelected: currentRoute == '/dashboard',
            onTap: () => context.go('/dashboard'),
          ),
          _DrawerItem(
            icon: Icons.people,
            title: 'Customers',
            isSelected: currentRoute.startsWith('/customers'),
            onTap: () => context.go('/customers'),
          ),
          _DrawerItem(
            icon: Icons.badge,
            title: 'Employees',
            isSelected: currentRoute.startsWith('/employees'),
            onTap: () => context.go('/employees'),
          ),
          _DrawerItem(
            icon: Icons.shopping_cart,
            title: 'Orders',
            isSelected: currentRoute.startsWith('/orders'),
            onTap: () => context.go('/orders'),
          ),
          _DrawerItem(
            icon: Icons.payment,
            title: 'Payments',
            isSelected: currentRoute.startsWith('/payments'),
            onTap: () => context.go('/payments'),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorColor),
            title: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
