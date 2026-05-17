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

// lib/screens/main_screen.dart
// Updated: Added logout button + masjid name in AppBar
// lib/screens/main_screen.dart
// Updated: Added logout button + masjid name in AppBar
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjidapp/auth/auth_service.dart';
import 'package:masjidapp/auth/login_screen.dart';
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
  final _authService = AuthService();

  // IndexedStack keeps all screens alive — state is preserved on tab switch
  final _screens = const [
    DashboardScreen(),
    DonationsScreen(),
    ExpensesScreen(),
    ProjectsScreen(),
  ];

  // ── Logout confirm dialog ─────────────────────────────
  Future<void> _showLogoutDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0F3D2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.cairo(color: kGold, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Kya aap logout karna chahte hain?',
          style: GoogleFonts.cairo(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Nahi',
              style: GoogleFonts.cairo(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: GoogleFonts.cairo(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
        (route) => false,
      );
    }
  }

  String get _masjidName {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? 'Masjid';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryDark,
      extendBody: true,
      // ─── TOP APP BAR with masjid name and logout ─────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.04),
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF1A4D38), Color(0xFF0A2E24)],
                      ),
                      border: Border.all(
                        color: kGold.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: kGold,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _masjidName,
                          style: GoogleFonts.cairo(
                            color: kGold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Management System',
                          style: GoogleFonts.cairo(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                // Logout button
                IconButton(
                  onPressed: _showLogoutDialog,
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  tooltip: 'Logout',
                ),
                const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        kGold.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // ─── SAFE CONTENT AREA ──────────────────────────────────────────
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
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
            color: Colors.white.withOpacity(0.02),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.04), width: 1),
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: kGold.withOpacity(0.12),
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
//           true, // Allows screens to flow seamlessly behind the glass bar
//       // ─── SAFE CONTENT AREA ─────────────────────────────────────────────
//       // Padding aur SafeArea ka combination content ko bottom bar se upar push karega
//       body: SafeArea(
//         bottom: false, // Background layout ko flow karne dega
//         child: Padding(
//           padding: const EdgeInsets.only(
//             bottom: 100,
//           ), // 65px (bar height) + 10px premium breathing space
//           child: IndexedStack(index: _index, children: _screens),
//         ),
//       ),
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
