import 'package:flutter/material.dart';

class HomeScreenTab extends StatefulWidget{

  final IconData mTabIcon;
  final String mTabTitle;
  final bool mInitialSelectedState;

  HomeScreenTab(this.mTabIcon,this.mTabTitle,this.mInitialSelectedState);

  HomeScreenTabState homeScreenTabState;

  void toggleSelectedState(bool state) {
    homeScreenTabState.setState((){
      homeScreenTabState.mSelected = state;
    });
  }

  @override
  State<StatefulWidget> createState() {
    homeScreenTabState = new HomeScreenTabState(mTabIcon, mTabTitle,mInitialSelectedState);
    return homeScreenTabState;
  }
}

class HomeScreenTabState extends State<HomeScreenTab> {

  final IconData mTabIcon;
  final String mTabTitle;

  bool mSelected = false;

  HomeScreenTabState(this.mTabIcon, this.mTabTitle,this.mSelected);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return new Container(
      height: height,
      width: 110.0,
      padding: new EdgeInsets.only(right: 15.0),
      decoration: getBoxDecoration(),
      child: new Row(
        children: <Widget>[
          new Container(child: new Icon(mTabIcon,color:getColor()),padding: new EdgeInsets.only(right:10.0)),
          new Text(mTabTitle,style: new TextStyle(color: getColor(),fontFamily: "Roboto",fontStyle: FontStyle.normal))
        ],
      ),
    );


//      new Row(
//      children: <Widget>[
//        new Icon(mTabIcon, color: Colors.white),
//        new Text(mTabTitle, style: new TextStyle(color: Colors.white),)
//      ],
//    );
  }

  Decoration getBoxDecoration() {
    if (mSelected) {
      return new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(
                  color:Colors.deepOrange,
                  width: 2.0
              )
          )
      );
    } else {
      return new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(
                  color:Colors.transparent,
                  width: 2.0
              )
          )
      );
    }
  }

  Color getColor() {
    if (mSelected){
      return Colors.white;
    } else {
      return Colors.white70;
    }
  }
}