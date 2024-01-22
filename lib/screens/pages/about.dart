import 'package:QBB/bottom_nav.dart';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/notification.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AboutUs extends StatefulWidget {
  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PopScope(
      canPop: true,
      child: Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: textcolor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    "assets/images/icon.png",
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
                // SizedBox(
                //   width: 50.0,
                // ),
                Text(
                  'aboutUs'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.w900 ,
                    fontFamily: 'Impact',
                  ),
                ),
                // SizedBox(
                //   width: 50.0,
                // ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                  icon: const Icon(Icons.notifications_none_outlined),
                  iconSize: 30.0,
                  color: textcolor,
                )
              ],
            ),
            backgroundColor: appbar,
          ),
          // bottomNavigationBar: BottomMenu(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // color: textcolor,
                // height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white, // Container background color
                  borderRadius: BorderRadius.circular(0), // Border radius
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 188, 188, 188)
                          .withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: const Offset(0, 3), // Offset from top-left
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('aboutUs'.tr,
                          style:
                              TextStyle(color: Colors.black, fontSize: 24.0)),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'aboutContent'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'aboutContentt'.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
