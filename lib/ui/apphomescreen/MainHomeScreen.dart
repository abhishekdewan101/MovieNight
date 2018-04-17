import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieee_app/managers/FirebaseLoginManager.dart';
import 'package:movieee_app/ui/apphomescreen/movielist/ListPage.dart';
import 'package:movieee_app/ui/apphomescreen/moviepoll/MoviePollScreen.dart';
import 'package:movieee_app/ui/homescreen/homescreenmovielist.dart';
import 'package:movieee_app/utils/ColorConstants.dart';
import 'package:movieee_app/utils/Constants.dart';
import 'package:movieee_app/utils/NavigatorUtils.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainHomeScreenState();

}

class MainHomeScreenState extends State<MainHomeScreen>{

  BuildContext mContext;
  FirebaseLoginManager mFirebaseLoginManager = new FirebaseLoginManager();
  FirebaseUser mUser;
  PageController mPageController;

  int mBottomSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    mFirebaseLoginManager.getFirebaseUser().then((user){
      setState(() {
        mUser = user;
      });
    });
    mPageController  = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: ColorConstants.LOGIN_BACKGROUND_COLOR,
        appBar: getTitleBar(context),
        body: new Builder(builder: (BuildContext context) {
          mContext = context;
          return getScaffoldBody();
        }),
        bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getScaffoldBody() {
    var topMargin = MediaQuery.of(mContext).padding.top;
    return new Padding(
        padding: new EdgeInsets.only(top: topMargin),
        child:  new PageView(
            children: [
              new ListPage(),
              new MoviePollScreen()
            ],
            /// Specify the page controller
            controller: mPageController
        ),
    );
  }
  
  Widget getTitleBar(BuildContext context) {
    return new PreferredSize(preferredSize: new Size(
          MediaQuery.of(context).size.width,
          50.0),
      child: new Container(
        padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: ColorConstants.LOGIN_BUTTON_BACKGROUND_COLOR,
        child: new Stack(
          children: <Widget>[
            new Align(alignment: Alignment.center, child: getTitle()),
            new Align(alignment: Alignment.centerRight, child: getLogoutText())
          ],
        ),
      )
    );
  }

  Text getTitle() {
    return new Text("Movie Night",style: new TextStyle(
      color: Colors.white,
      fontFamily: "Roboto",
      fontSize: 24.0
    ));
  }

  Widget getLogoutText() {
    return new Padding(
      padding: const EdgeInsets.only(right:15.0),
      child: new Container(
        height: 35.0,
        width: 35.0,
        child: new Material(
          borderRadius: new BorderRadius.circular(100.0),
          child: new InkWell(
            onTap: (){ showMenu(context: mContext,
                items: getPopupMenuList(),
                position: new RelativeRect.fromLTRB(
                    MediaQuery.of(mContext).size.width,
                    MediaQuery.of(mContext).padding.top + 50.0,
                    0.0, 0.0
                )
              );
            },
            splashColor: Colors.white,
            child: getProfileImage()
          ),
        ),
      )
    );
  }

  Image getProfileImage() {
    if (mUser != null) {
      return new Image.network(mUser.photoUrl,height:50.0, width: 50.0,fit: BoxFit.cover);
    } else {
      return new Image.network(Constants.EMPTY_PROFILE_PIC_URL,height:50.0, width: 50.0,fit: BoxFit.cover);
    }
  }

  List<PopupMenuItem> getPopupMenuList() {
    List<PopupMenuItem> menuList = [];
    menuList.add(new PopupMenuItem(
        child: new InkWell(
          onTap: (){
            NavigatorUtils.popTillLoginPage(mContext);
            mFirebaseLoginManager.signOut();
          },
          splashColor: Colors.black26,
          child: new Row(
            children: <Widget>[
              new Icon(Icons.exit_to_app),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: new Text("Logout"),
              )
            ],
          ),
        )
    ));
    return menuList;
  }

  Widget getBottomNavigationBar() {
    return new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int){
          setState(() {
            mBottomSelectedIndex = int;
            bottomNavigationTapped(mBottomSelectedIndex);
          });
        },
        currentIndex: mBottomSelectedIndex,
        items: getBottomNavigationItems()
    );
  }

  List<BottomNavigationBarItem> getBottomNavigationItems() {
    List<BottomNavigationBarItem> navigationItems = [];
    navigationItems.add(new BottomNavigationBarItem(
        icon: new Icon(Icons.movie),
        title: new Text("Movie List")
      )
    );
    navigationItems.add(new BottomNavigationBarItem(
        icon: new Icon(Icons.poll),
        title: new Text("My Polls")
    )
    );
    return navigationItems;
  }

  void bottomNavigationTapped(int selectedIndex) {
    mPageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
  }

}