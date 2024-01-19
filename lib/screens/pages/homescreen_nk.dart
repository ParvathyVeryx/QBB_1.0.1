import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';

import '../../nirmal_api.dart/studies_api.dart';
// import 'package:flutter_gen/gen_I10n/app-localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudyMasterAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Screen'),
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First Section (Widget)
          const Expanded(
            flex: 2, // Adjust the flex value to give more width
            child: SideMenu(),
          ),

          // Second Section (Image)
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.75, 1.0],
                  colors: [Colors.deepPurple, Colors.purple],
                ),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                // fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
