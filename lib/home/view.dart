import 'package:flutter/material.dart';
import 'package:mri/data/user/user_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores - Earthfoam'),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/mri');
              },
              child: Card(child: Center(child: Text('MRI'))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/grn');
              },
              child: Card(child: Center(child: Text('GRN'))),
            ),
          ],
        ),
      ),
    );
  }
}
