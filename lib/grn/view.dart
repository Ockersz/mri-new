// lib/screens/grn_screen.dart
import 'package:flutter/material.dart';
import 'package:mri/data/user/user_repository.dart';

class GRNScreen extends StatefulWidget {
  const GRNScreen({Key? key}) : super(key: key);
  static const String routeName = '/grn';

  @override
  GRNScreenState createState() => GRNScreenState();
}

class GRNScreenState extends State<GRNScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Issue Note'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              UserRepository().logout();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/home',
                ); // Replace with your home route
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('GRN'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/grn',
                ); // Replace with your GRN list route
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('This is the GRN Screen')),
    );
  }
}
