import 'package:flutter/cupertino.dart';
import 'package:asetize/imports.dart';
import '../../../../core/util/app_permission.dart';
import '../../../feed/pages/feed_new_screen.dart';
import '../../../home_screen/pages/home_screen.dart';
import '../../../self_profile/pages/profile_screen.dart';
import '../../../member/pages/members_tab_bar_screen.dart';

enum TabItemBottomNavigatorWithStack { menu1, menu2, menu3, menu4, menu5 }

/// This is the stateful widget that the main application instantiates.
class BottomNavigatorWithStack extends StatefulWidget {
  final TabItemBottomNavigatorWithStack? currentTab;
  final ValueChanged<TapedItemModel>? onSelectTab;

  final List<Widget>? widgetOptions;
  final double menuHeight;

  const BottomNavigatorWithStack({
    Key? key,
    this.currentTab,
    this.onSelectTab,
    this.menuHeight = 59,
    this.widgetOptions,
  }) : super(key: key);

  @override
  State<BottomNavigatorWithStack> createState() =>
      _BottomNavigatorWithStackState(currentTab: currentTab, onSelectTab: onSelectTab);
}

/// This is the private State class that goes with BottomNavigatorWithStack.
class _BottomNavigatorWithStackState extends State<BottomNavigatorWithStack> {
  TabItemBottomNavigatorWithStack? currentTab;
  ValueChanged<TapedItemModel>? onSelectTab;
  int selectedIndex = 0;
  double menuHeight = 56;
  double fontSize = 15;
  Map<String, dynamic> homeBottomNavigationBar =
      MainAppBloc.configTheme.containsKey("homeBottomNavigationBar")
          ? MainAppBloc.configTheme["homeBottomNavigationBar"]
          : {};
  Map<String, dynamic> setting = MainAppBloc.configTheme.containsKey("setting")
      ? MainAppBloc.configTheme["setting"]
      : {};
  Color backgroundColor = Colors.white;
  Color activeIconColor = Colors.orange;
  late UserProfileBloc bloc;
  Color deActiveIconColor = Colors.blueGrey.withOpacity(0.25);
  TextStyle activeMenuTextStyle =
      const TextStyle(fontSize: 0, color: Colors.orange);
  TextStyle deActiveMenuTextStyle =
      TextStyle(fontSize: 0, color: Colors.blueGrey.withOpacity(0.25));
  double elevation = 0;
  int bottomMenuType = 0;

  List<BottomNavigationBarItem> menuItem = <BottomNavigationBarItem>[];
  List<dynamic> menuItemTemp = [];

/*  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    String menuPageId = menuItemTemp[selectedIndex]["menuPageId"];
    widget.onItemTapped?.call(selectedIndex, menuPageId);
  }*/

  _BottomNavigatorWithStackState({this.onSelectTab, this.currentTab}) {
    //Set values from jason file
    backgroundColor = homeBottomNavigationBar.containsKey("backgroundColor")
        ? Color(int.parse(homeBottomNavigationBar["backgroundColor"]))
        : backgroundColor;
    activeIconColor = homeBottomNavigationBar.containsKey("activeIconColor")
        ? Color(int.parse(homeBottomNavigationBar["activeIconColor"]))
        : activeIconColor;
    deActiveIconColor = homeBottomNavigationBar.containsKey("deActiveIconColor")
        ? Color(int.parse(homeBottomNavigationBar["deActiveIconColor"]))
        : deActiveIconColor;
    if (homeBottomNavigationBar.containsKey("deActiveMenuTextStyle")) {
      deActiveMenuTextStyle.copyWith(
          color: Color(int.parse(
              homeBottomNavigationBar["deActiveMenuTextStyle"]["color"])),
          fontSize: homeBottomNavigationBar["deActiveMenuTextStyle"]["fontSize"]
              .toDouble());
    }
    if (homeBottomNavigationBar.containsKey("activeMenuTextStyle")) {
      activeMenuTextStyle.copyWith(
          color: Color(int.parse(
              homeBottomNavigationBar["activeMenuTextStyle"]["color"])),
          fontSize: homeBottomNavigationBar["activeMenuTextStyle"]["fontSize"]
              .toDouble());
    }

    if (homeBottomNavigationBar.containsKey("elevation")) {
      elevation = homeBottomNavigationBar["elevation"];
    }
    if (homeBottomNavigationBar.containsKey("bottomMenuType")) {
      bottomMenuType = homeBottomNavigationBar["bottomMenuType"];
    }

    if (homeBottomNavigationBar.containsKey("menuHeight")) {
      menuHeight = homeBottomNavigationBar["menuHeight"];
    }

    if (menuHeight < 56) {
      menuHeight = 56;
    }

    //updateMenuItem(context);
  }

  @override
  void didUpdateWidget(covariant BottomNavigatorWithStack oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.currentTab != null) {
      setState(() {
        currentTab = widget.currentTab;
        updateMenuItem(context);
      });
    }
  }

  @override
  void initState() {
    bloc = BlocProvider.of<UserProfileBloc>(context);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    String menuPageId = menuItemTemp[selectedIndex]["menuPageId"];
    String statusBarColor = menuItemTemp[selectedIndex]["statusBarColors"];
    widget.onSelectTab?.call(TapedItemModel(
        tabItemBottomNavigatorWithStack: getMenuId(menuPageId),
        statusBarColor: statusBarColor));
    // widget.onItemTapped?.call(selectedIndex, menuPageId);
  }

  @override
  Widget build(BuildContext context) {
    updateMenuItem(context);
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(width: 0.5, color: Colors.grey.shade300))),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: BottomNavigationBar(
              items: menuItem,
              elevation: elevation,
              type: bottomMenuType == 0
                  ? BottomNavigationBarType.shifting
                  : BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              // fixedColor: backgroundColor,
              currentIndex: selectedIndex,
              selectedIconTheme: IconThemeData(color: activeIconColor),
              selectedItemColor: activeIconColor,
              unselectedItemColor: deActiveIconColor,
              selectedLabelStyle: activeMenuTextStyle,
              unselectedLabelStyle: deActiveMenuTextStyle,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  TabItemBottomNavigatorWithStack getMenuId(String menuIdStr) {
    TabItemBottomNavigatorWithStack? tapedItem;
    switch (menuIdStr) {
      case "menu1":
        tapedItem = TabItemBottomNavigatorWithStack.menu1;
        break;
      case "menu2":
        tapedItem = TabItemBottomNavigatorWithStack.menu2;
        break;
      case "menu3":
        tapedItem = TabItemBottomNavigatorWithStack.menu3;
        break;
      case "menu4":
        tapedItem = TabItemBottomNavigatorWithStack.menu4;
        break;
      case "menu5":
        tapedItem = TabItemBottomNavigatorWithStack.menu5;
        break;
    }
    return tapedItem!;
  }

  bool hideBottomMenuTab(String tabName, BuildContext context) {
    /// Keep Home & Profile always visible
    if (tabName == "Home" || tabName == 'Profile') {
      return true;
    }

    /// Remove the Post tab completely
    if (tabName == "Post") {
      return false; // <- This hides the Post tab
    }

    /// Other menu based on permission
    if (tabName == "Members") {
      return AppPermission.instance.canPermission(AppString.memberList, context: context);
    }

    return false;
  }


  void updateMenuItem(BuildContext context) {
    if (homeBottomNavigationBar.containsKey("menu_item")) {
      // menuItemTemp = homeBottomNavigationBar["menu_item"];
      menuItemTemp = [];
      homeBottomNavigationBar["menu_item"].map((values) {
        if (hideBottomMenuTab(values["label"],context)) {
          menuItemTemp.add(values);
        }
      }).toList();
      menuItem = [];
      // int index = 0;

      menuItemTemp.map((values) {
        menuItem.add(BottomNavigationBarItem(
          backgroundColor: Colors.white,
          activeIcon: Container(
            color: Colors.transparent,
            padding: /*index == 2 || index == 3 ? EdgeInsets.zero :*/const EdgeInsets.only(left: 6, right: 6),
            margin: EdgeInsets.zero,
            height: 40,
            child: Container(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.textBlueColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    values["label"].toString().toLowerCase() == "profile"? CircleAvatar(
                      backgroundImage: NetworkImage(
                          bloc.user.profilePhoto ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQT18yU3a-TP6m3SI_WV5p0o5LJaK70Ol8GgA8c57Vq2TNfImU8V-2vd7FMz2lsWbp2d8E&usqp=CAU"
                      ),
                      radius: 13.5, // Adjust radius (half of height/width) to match size
                    ):WorkplaceIcons.iconImage(
                        imageUrl: values["activeIcon"],
                        imageColor: Colors.white,
                        iconSize: const Size(20, 20)),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Text(
                          values["label"],
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                )),
          ),
          icon: values["label"].toString().toLowerCase() == "profile"?

          CircleAvatar(
            backgroundImage: NetworkImage(
                bloc.user.profilePhoto ??
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQT18yU3a-TP6m3SI_WV5p0o5LJaK70Ol8GgA8c57Vq2TNfImU8V-2vd7FMz2lsWbp2d8E&usqp=CAU"
            ),
            radius: 13.5,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 0.2, // Adjust border thickness as needed
                ),
              ),
            ),
          )
              : Container(
              padding: const EdgeInsets.all(0),
              height: /*index == 2 || index == 3 ? 25.5 :*/  values["label"].toString().toLowerCase() == "members"? 25:30,
              child: WorkplaceIcons.iconImage(
                  imageUrl: values["deActiveIcon"],
                  imageColor: const Color(0xFF575757))),
          label: "" /*values["label"]*/,
        ));
        // index++;
      }).toList();
    }
  }
}

class TapedItemModel {
  final TabItemBottomNavigatorWithStack tabItemBottomNavigatorWithStack;
  final String? statusBarColor;

  TapedItemModel(
      {required this.tabItemBottomNavigatorWithStack, this.statusBarColor});
}

//App Navigator
class AppNavigatorRoutes {
  static const String root = '/';
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key, this.navigatorKey, this.tabItem, this.item});

  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItemBottomNavigatorWithStack? tabItem;
  final dynamic item;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {dynamic item}) {
    return {
      AppNavigatorRoutes.root: (context) => _buildRootWidget(context),
    };
  }




  Widget _buildRootWidget(BuildContext context) {
    if (tabItem == TabItemBottomNavigatorWithStack.menu1) {
      return const HomeScreen();
    } else if (tabItem == TabItemBottomNavigatorWithStack.menu2) {
      return const FeedNewScreen();
    } else if (tabItem == TabItemBottomNavigatorWithStack.menu3) {
      return const MembersTabBarScreen();
    }else {
      return const UserProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {

    final routeBuilders = _routeBuilders(context, item: item);

    return Navigator(
      key: navigatorKey,
      initialRoute: AppNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }
}
