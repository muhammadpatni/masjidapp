import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'dashboard_screen.dart';
import 'donations_screen.dart';
import 'expenses_screen.dart';
import 'projects_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  // IndexedStack keeps all screens alive — state is preserved on tab switch
  final _screens = const [
    DashboardScreen(),
    DonationsScreen(),
    ExpensesScreen(),
    ProjectsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: kCard,
        indicatorColor: kPrimarySoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon:         Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: kPrimary),
            label:        'Dashboard',
          ),
          NavigationDestination(
            icon:         Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism, color: kPrimary),
            label:        'Donations',
          ),
          NavigationDestination(
            icon:         Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: kPrimary),
            label:        'Expenses',
          ),
          NavigationDestination(
            icon:         Icon(Icons.construction_outlined),
            selectedIcon: Icon(Icons.construction, color: kPrimary),
            label:        'Projects',
          ),
        ],
      ),
    );
  }
}
