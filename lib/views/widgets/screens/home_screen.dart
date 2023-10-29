import 'package:flutter/material.dart';
import 'package:eduquality/app_pref.dart';
import 'package:eduquality/constants.dart';
import 'package:eduquality/views/widgets/screens/add_video_screen.dart';
import 'package:eduquality/views/widgets/screens/profile_screen.dart';
import 'package:eduquality/views/widgets/screens/search_screen.dart';
import 'package:eduquality/views/widgets/screens/video_screen.dart';
import 'package:eduquality/views/widgets/screens/bookmarkVideo_screen.dart';
import 'package:eduquality/views/widgets/screens/no_access_screen.dart';
import '../custom_icon.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    bool isGuest = getPrefValue("Role") == "3";
    bool isAdmin = getPrefValue("Role") == "0";

    List<BottomNavigationBarItem> bottomNavBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 30),
        label: 'Home',
      ),

      const BottomNavigationBarItem(
        icon: Icon(Icons.search, size: 30),
        label: 'Search',
      ),
    ];
    //BOOKMARK ON NAV BAR
    bottomNavBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark, size: 30),
          label: 'Bookmarked Videos',
        ),
    );
    /***** THIS GIVES ONLY GUEST A LOCK ICON< BUT IT IS STILL CLICKABLE
    if (!isGuest) {
      bottomNavBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark, size: 30),
          label: 'Bookmarked Videos',
        ),
      );
    } else {
      // For the "Guest Only" button, wrap it in an IgnorePointer widget
      // to prevent it from responding to tap events
      bottomNavBarItems.add(
        BottomNavigationBarItem(
          icon: IgnorePointer(
            ignoring: true,
            child: Icon(Icons.lock, size: 30),
          ),
          label: 'Guest Only',
        ),
      );
    }
    *********/
    if (isAdmin) {
      bottomNavBarItems.add(
        const BottomNavigationBarItem(
          icon: CustomIcon(),
          label: '',
        ),
      );
    }

    bottomNavBarItems.add(
      const BottomNavigationBarItem(
        icon: Icon(Icons.person, size: 30),
        label: 'Profile',
      ),
    );

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              pageIdx = idx;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: backgroundColor,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          currentIndex: pageIdx,
          items: bottomNavBarItems,
        ),
        body: isAdmin
        ? [
        const VideoScreen(),
        SearchScreen(),
        const BookmarkVideoScreen(),
        const AddVideoScreen(),
        ProfileScreen(uid: authController.user.uid),
        ][pageIdx]

        //FOR GUEST NO ACCESS BOOKMARKS
        : isGuest
        ? [
        const VideoScreen(),
        SearchScreen(), //MAY WISH TO REMOVE THIS
        const NoAccessScreen(),
        ProfileScreen(uid: authController.user.uid),
        ][pageIdx]

        : [
        const VideoScreen(),
        SearchScreen(),
        const BookmarkVideoScreen(),
        ProfileScreen(uid: authController.user.uid),
        ][pageIdx],
    );
  }
}
