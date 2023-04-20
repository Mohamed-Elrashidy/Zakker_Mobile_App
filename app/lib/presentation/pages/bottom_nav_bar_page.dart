import 'package:app/presentation/pages/category_page.dart';
import 'package:app/presentation/pages/home_page.dart';
import 'package:app/utils/dependency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'notes_page.dart';

class BottomNavBarPage extends StatelessWidget {
   BottomNavBarPage({Key? key}) : super(key: key);
  PersistentTabController _controller=PersistentTabController(initialIndex: 0);


  @override
  Widget build(BuildContext context) {
    Dependancy().initDimensionScale(context);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.black, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
  List<Widget> _buildScreens() {
  return [
  HomePage(),
  NotesPage(),
  CategoryPage(),
  Container(),
  Container(),

  ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
  PersistentBottomNavBarItem(
  icon: Icon(CupertinoIcons.home),
//  title: ("Home"),
  activeColorPrimary: CupertinoColors.white,
  inactiveColorPrimary: CupertinoColors.systemGrey,
  ),PersistentBottomNavBarItem(
  icon: Icon(Icons.sticky_note_2_outlined),
  //title: ("Notes"),
  activeColorPrimary: CupertinoColors.white,
  inactiveColorPrimary: CupertinoColors.systemGrey,
  ),PersistentBottomNavBarItem(
  icon: Icon(Icons.category_outlined),
  //title: ("Category"),
  activeColorPrimary: CupertinoColors.white,
  inactiveColorPrimary: CupertinoColors.systemGrey,
  ),PersistentBottomNavBarItem(
  icon: Icon(Icons.settings),
  //title: ("settings"),
  activeColorPrimary: CupertinoColors.white,
  inactiveColorPrimary: CupertinoColors.systemGrey,
  ),
  PersistentBottomNavBarItem(
  icon: Icon(Icons.account_circle_outlined),
  //title: ("profile"),
  activeColorPrimary: CupertinoColors.white,
  inactiveColorPrimary: CupertinoColors.systemGrey,
  ),
  ];
  }
}
