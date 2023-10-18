// ignore_for_file: unused_import, prefer_const_constructors, avoid_unnecessary_containers, duplicate_ignore, file_names, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unused_element, unused_field, sized_box_for_whitespace, camel_case_types

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hostelhub/Userdetails/users_details.dart';
import 'package:hostelhub/comments.dart';
import 'package:hostelhub/home.dart';
import 'package:hostelhub/hostels/hostels.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:hostelhub/hostels/hostels.dart';
import 'package:hostelhub/profile.dart';
import 'package:hostelhub/userdashboard/my_room.dart';

import '../hostels/add_hostel.dart';
import '../hostels/user_hostel.dart';

class userDashboard extends StatefulWidget {
  userDashboard({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer(context) {
    Navigator.of(context).pop();
  }

  @override
  State<userDashboard> createState() => _userDashboardState();
}

Color color = Colors.deepPurple;

class _userDashboardState extends State<userDashboard> {
  String disp = '';
  int _selectedIndex = 0;
  String? text = "Hostel Hub";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        text = "Hostel Hub";
      }
      if (index == 1) {
        text = "All User";
      }
      if (index == 2) {
        text = "Coments";
      }
      if (index == 3) {
        text = "My room";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //       MaterialPageRoute(builder: (context) => Setting()));
      // body: Container(
      //   // color: Colors.black,
      //   // ignore: prefer_const_constructors
      //   child: Center(
      //     child: Text(
      //       ' Here is userDashboard',
      //       style: TextStyle(
      //           fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
      //     ),
      //   ),
      // ),
      // backgroundColor: color,
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: color,
      //   // ignore: prefer_const_literals_to_create_immutables
      //   items: [
      //     Icon(Icons.home),
      //     Icon(Icons.person_2),
      //     Icon(Icons.details),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       if (index == 0) {
      //         color =  Color.fromARGB(255, 7, 80, 140);
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => newHostel()));
      //       } else if (index == 1) {
      //         color = Colors.brown;
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => ProfileScreen()));
      //       } else if (index == 2) {
      //         color =  Color.fromARGB(255, 7, 80, 140)Grey;
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => DetailsScreen()));
      //       } else {
      //         Container();
      //       }
      //     });
      //   },
      // ),

      appBar: AppBar(
        title: Text(text!),
        backgroundColor: Color.fromARGB(255, 7, 80, 140),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Container(
              width: 50,
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ), // Three dots icon
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
              // Handle the three dots icon pressed
            },
          ),
          //   // IconButton(
          //   //   icon: Icon(Icons.more_vert), // Three dots icon
          //   //   onPressed: () {
          //   //     // Scaffold.of(context).openEndDrawer();
          //   //     // Handle the three dots icon pressed
          //   //   },
          //   // ),
        ],
      ),
      // drawer: Drawer(),
      endDrawer: Drawer(
        child: ListView.builder(itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const Icon(Icons.list),
            title: Text("Item1"),
            trailing: const Icon(Icons.done),
          );
        }),
        //elevation: 20.0,
        //semanticLabel: 'endDrawer',
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromARGB(255, 7, 80, 140),
        backgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.home,
            color: Colors.white,
            semanticLabel: "home",
          ),
          Icon(
            Icons.supervised_user_circle_sharp,
            color: Colors.white,
          ),
          Icon(
            Icons.comment,
            color: Colors.white,
          ),
          Icon(
            Icons.info,
            color: Colors.white,
          ),
        ],
        // on
        // currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // items: [
        //   BottomNavigationBarItem(
        //     icon: Icon(
        //       Icons.home,
        //     ),
        //     label: 'Home',
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.person),
        //     label: 'Profile',
        //   ),
        //   BottomNavigationBarItem(
        //     icon: Icon(Icons.info),
        //     label: 'Details',
        //   ),
        // ],
      ),
      body: Container(
        child: _getPage(_selectedIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        text = "Hostel Hub";
        return hostelsUser();
      case 1:
        text = " All Users";
        return allUsers();
      case 2:
        text = "Comments";
        return CommentsScreen();
      case 3:
        return userRoomDetails();
      default:
        return Container();
    }
  }
}
