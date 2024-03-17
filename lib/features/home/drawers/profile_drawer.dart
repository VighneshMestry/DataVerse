import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/auth/screens/login_screen.dart';

class ProfileDrawer extends ConsumerStatefulWidget {
  const ProfileDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends ConsumerState<ProfileDrawer> {
  void logOut() {
    print("YOOOOOOOOOOOOOOOOOOOOOO");
    ref.read(authControllerProvider.notifier).logOut();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text("My Profile"),
              leading: const Icon(Icons.person),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('LogOut'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false);
                              logOut();
                            },
                            child: const Text('LogOut'),
                          ),
                        ],
                      );
                    });
              },
            ),
            Switch.adaptive(
              // value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.dark,
              // onChanged: (val) => toggleTheme(ref),
              value: true,
              onChanged: (val) {},
            )
          ],
        ),
      ),
    );
  }
}
