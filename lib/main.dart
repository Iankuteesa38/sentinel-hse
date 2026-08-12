import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/dashboard_page.dart';
import 'features/auth/pages/login_page.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/pages/account_setup_page.dart';
import 'features/auth/services/account_setup_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pagzliqekrzmhjgcsohg.supabase.co',
    publishableKey: 'sb_publishable_0IVM1bnu48XpWw3n54ya7A_roVIKC_7',
  );

  runApp(const SentinelHSEApp());
}

class SentinelHSEApp extends StatelessWidget {
  const SentinelHSEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentinel HSE',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = Supabase.instance.client.auth.currentSession;

          if (session == null) {
            return const LoginPage();
          }
          return FutureBuilder<bool>(
            future: AccountSetupService.hasProfile(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (profileSnapshot.data != true) {
                return FutureBuilder<bool>(
                  future: AccountSetupService.completeInvitedAccount(),
                  builder: (context, inviteSnapshot) {
                    if (inviteSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (inviteSnapshot.data == true) {
                      return FutureBuilder<bool>(
                        future: AccountSetupService.isCurrentUserActive(),
                        builder: (context, activeSnapshot) {
                          if (activeSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (activeSnapshot.data != true) {
                            return const Scaffold(
                              body: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text(
                                    'Your Sentinel HSE account is inactive. Please contact your organization administrator.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }

                          return const DashboardPage();
                        },
                      );
                    }

                    return const AccountSetupPage();
                  },
                );
              }

              return const DashboardPage();
            },
          );
        },
      ),
    );
  }
}
