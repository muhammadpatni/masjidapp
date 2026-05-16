// import 'package:flutter/material.dart';
// import '../constants/app_theme.dart';
// import 'dashboard_screen.dart';
// import 'donations_screen.dart';
// import 'expenses_screen.dart';
// import 'projects_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _index = 0;

//   // IndexedStack keeps all screens alive — state is preserved on tab switch
//   final _screens = const [
//     DashboardScreen(),
//     DonationsScreen(),
//     ExpensesScreen(),
//     ProjectsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: _index, children: _screens),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _index,
//         onDestinationSelected: (i) => setState(() => _index = i),
//         backgroundColor: kCard,
//         indicatorColor: kPrimarySoft,
//         labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.dashboard_outlined),
//             selectedIcon: Icon(Icons.dashboard, color: kPrimary),
//             label: 'Dashboard',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.volunteer_activism_outlined),
//             selectedIcon: Icon(Icons.volunteer_activism, color: kPrimary),
//             label: 'Donations',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.receipt_long_outlined),
//             selectedIcon: Icon(Icons.receipt_long, color: kPrimary),
//             label: 'Expenses',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.construction_outlined),
//             selectedIcon: Icon(Icons.construction, color: kPrimary),
//             label: 'Projects',
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../constants/app_theme.dart';
// import 'dashboard_screen.dart';
// import 'donations_screen.dart';
// import 'expenses_screen.dart';
// import 'projects_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _index = 0;

//   // IndexedStack keeps all screens alive — state is preserved on tab switch
//   final _screens = const [
//     DashboardScreen(),
//     DonationsScreen(),
//     ExpensesScreen(),
//     ProjectsScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryDark, // Global dark background framework
//       extendBody:
//           true, // Crucial: Allows screens to flow seamlessly behind the glass bar
//       body: IndexedStack(index: _index, children: _screens),
//       bottomNavigationBar: _buildGlassNavigationBar(),
//     );
//   }

//   // ─── Translucent Frosted Navigation Bar ─────────────────────────────
//   Widget _buildGlassNavigationBar() {
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.02), // Micro translucent layer
//             border: Border(
//               top: BorderSide(
//                 color: Colors.white.withOpacity(
//                   0.04,
//                 ), // Ultra sharp premium top border
//                 width: 1,
//               ),
//             ),
//           ),
//           child: NavigationBarTheme(
//             data: NavigationBarThemeData(
//               indicatorColor: kGold.withOpacity(
//                 0.12,
//               ), // Subtle glow behind active icon
//               labelTextStyle: WidgetStateProperty.resolveWith((states) {
//                 if (states.contains(WidgetState.selected)) {
//                   return GoogleFonts.cairo(
//                     color: kGold,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   );
//                 }
//                 return GoogleFonts.cairo(
//                   color: Colors.white38,
//                   fontSize: 11,
//                   fontWeight: FontWeight.normal,
//                 );
//               }),
//               iconTheme: WidgetStateProperty.resolveWith((states) {
//                 if (states.contains(WidgetState.selected)) {
//                   return const IconThemeData(color: kGold, size: 24);
//                 }
//                 return const IconThemeData(color: Colors.white38, size: 24);
//               }),
//             ),
//             child: NavigationBar(
//               selectedIndex: _index,
//               onDestinationSelected: (i) => setState(() => _index = i),
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               height: 65,
//               surfaceTintColor: Colors.transparent,
//               labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//               destinations: const [
//                 NavigationDestination(
//                   icon: Icon(Icons.dashboard_outlined),
//                   selectedIcon: Icon(Icons.dashboard),
//                   label: 'Dashboard',
//                 ),
//                 NavigationDestination(
//                   icon: Icon(Icons.volunteer_activism_outlined),
//                   selectedIcon: Icon(Icons.volunteer_activism),
//                   label: 'Donations',
//                 ),
//                 NavigationDestination(
//                   icon: Icon(Icons.receipt_long_outlined),
//                   selectedIcon: Icon(Icons.receipt_long),
//                   label: 'Expenses',
//                 ),
//                 NavigationDestination(
//                   icon: Icon(Icons.construction_outlined),
//                   selectedIcon: Icon(Icons.construction),
//                   label: 'Projects',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: kPrimaryDark, // Global dark background framework
      extendBody:
          true, // Allows screens to flow seamlessly behind the glass bar
      // ─── SAFE CONTENT AREA ─────────────────────────────────────────────
      // Padding aur SafeArea ka combination content ko bottom bar se upar push karega
      body: SafeArea(
        bottom: false, // Background layout ko flow karne dega
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 100,
          ), // 65px (bar height) + 10px premium breathing space
          child: IndexedStack(index: _index, children: _screens),
        ),
      ),
      bottomNavigationBar: _buildGlassNavigationBar(),
    );
  }

  // ─── Translucent Frosted Navigation Bar ─────────────────────────────
  Widget _buildGlassNavigationBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02), // Micro translucent layer
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(
                  0.04,
                ), // Ultra sharp premium top border
                width: 1,
              ),
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: kGold.withOpacity(
                0.12,
              ), // Subtle glow behind active icon
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.cairo(
                    color: kGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  );
                }
                return GoogleFonts.cairo(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: kGold, size: 24);
                }
                return const IconThemeData(color: Colors.white38, size: 24);
              }),
            ),
            child: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 65,
              surfaceTintColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.volunteer_activism_outlined),
                  selectedIcon: Icon(Icons.volunteer_activism),
                  label: 'Donations',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Expenses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.construction_outlined),
                  selectedIcon: Icon(Icons.construction),
                  label: 'Projects',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
