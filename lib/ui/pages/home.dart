import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/ui/widgets/overlay.dart';
import 'package:elearning/theme/box_icons_icons.dart';
import 'package:elearning/theme/config.dart';
import 'package:elearning/ui/pages/leaderboard.dart';
import 'package:elearning/ui/pages/planner.dart';
import 'package:elearning/ui/pages/videos.dart';
import 'package:elearning/ui/widgets/sectionHeader.dart';
import 'package:elearning/ui/widgets/topBar.dart';
import 'package:elearning/ui/widgets/videoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class Home extends StatefulWidget {
  final onMenuTap;
  final User user; // Received user details
  Home({required this.onMenuTap, required this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tabNo = 0;
  late bool overlayVisible;
  CupertinoTabController? controller;
  @override
  void initState() {
    overlayVisible = false;
    controller = CupertinoTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CupertinoTabScaffold(
          backgroundColor: Colors().secondColor(1),
          controller: controller,
          tabBar: CupertinoTabBar(
            onTap: (value) {
              setState(() {
                tabNo = value;
              });
            },
            activeColor: material.Colors.lightBlue,
            inactiveColor: Color(0xFFADADAD),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bx_home_circle),
                  label: tabNo == 0 ? "Home" : null),
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bx_calendar),
                  label: tabNo == 1 ? "Planner" : null),
              BottomNavigationBarItem(icon: Container()),
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bxs_videos),
                  label: tabNo == 3 ? "Videos" : null),
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bx_stats),
                  label: tabNo == 4 ? "Leaderboard" : null),
            ],
          ),
          tabBuilder: (context, index) => (index == 0)
              ? HomePage(
                  onMenuTap: widget.onMenuTap,
                  user: widget.user, // Pass the user object
                )
              : (index == 1)
                  ? PlannerPage(
                      onMenuTap: widget.onMenuTap,
                      user: widget.user, // Pass the user object
                    )
                  : (index == 2)
                      ? Container(
                          color: CupertinoColors.activeOrange,
                        )
                      : (index == 3)
                          ? VideosPage(
                              onMenuTap: widget.onMenuTap,
                              user: widget.user, // Pass the user object
                            )
                          : LeaderboardPage(
                              onMenuTap: widget.onMenuTap,
                              user: widget.user, // Pass the user object
                            ),
        ),
        Positioned(
            bottom: 0,
            child: GestureDetector(
              child: SizedBox(
                height: 60,
                width: 80,
                child: Text(""),
              ),
              onTap: () {},
            )),
        overlayVisible ? OverlayWidget() : Container(),
        Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFABDCFF),
                      Color(0xFF0396FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 25,
                        color: Color(0xFF03A9F4).withOpacity(0.4),
                        offset: Offset(0, 4))
                  ],
                  borderRadius: BorderRadius.circular(500)),
              child: material.FloatingActionButton(
                  elevation: 0,
                  highlightElevation: 0,
                  backgroundColor: material.Colors.transparent,
                  child: overlayVisible
                      ? Icon(material.Icons.close)
                      : Icon(BoxIcons.bx_pencil),
                  onPressed: () {
                    setState(() {
                      overlayVisible = !overlayVisible;
                    });
                  }),
            )),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  final onMenuTap;
   final User user; // Receive the user object
  HomePage({
    Key? key,
    required this.onMenuTap,
    required this.user
  }) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: Colors().secondColor(1),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverFixedExtentList(
                    delegate: SliverChildListDelegate.fixed([Container()]),
                    itemExtent: screenHeight * 0.36,
                  ),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      text: 'Recommended Lectures',
                      onPressed: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 245,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return VideoCard(long: false);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      text: 'Revision Lectures',
                      onPressed: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 245,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return VideoCard(long: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: TopBar(
                controller: controller,
                expanded: true,
                onMenuTap: onMenuTap,
                userName: user.name, // Provide the user's name here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
