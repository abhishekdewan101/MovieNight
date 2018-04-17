import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/managers/FirebaseDatabaseManager.dart';
import 'package:movieee_app/managers/FirebaseLoginManager.dart';
import 'package:movieee_app/utils/ColorConstants.dart';
import 'package:share/share.dart';

class SelectPollFriends extends StatefulWidget {

  List<Movie> mSelectedMovies;
  String mPollName;

  SelectPollFriends(this.mSelectedMovies,this.mPollName);

  @override
  State<StatefulWidget> createState() => new SelectPollFriendsState(mSelectedMovies,mPollName);

}

class SelectPollFriendsState extends State<SelectPollFriends> {
  BuildContext mContext;
  List<Movie> mSelectedMovies;

  FirebaseDatabaseManager mFirebaseDatabaseManager = new FirebaseDatabaseManager();
  FirebaseLoginManager mFirebaseLoginManager = new FirebaseLoginManager();

  bool mPollCreated = false;

  String mPollName;

  SelectPollFriendsState(this.mSelectedMovies,this.mPollName);

  DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    mFirebaseLoginManager.getFirebaseUser().then((user){
      reference = mFirebaseDatabaseManager.pushPollData(user, mSelectedMovies,mPollName);
      print("Poll reference key is ${reference.key}");
      setState(() {
        mPollCreated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorConstants.LOGIN_BACKGROUND_COLOR,
      body: new Builder(builder: (BuildContext context) {
        mContext = context;
        return getScaffoldBody();
      }),
    );
  }

  Widget getScaffoldBody() {
    return new Container(
      padding: new EdgeInsets.only(top: MediaQuery.of(mContext).padding.top),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: getBodyBasedOnState(),
    );
  }

  Widget getBodyBasedOnState() {
    if (mPollCreated) {
      return buildPollCreatedState();
    } else {
      return buildPollCreatingState();
    }
  }

  Widget buildPollCreatedState() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(Icons.beenhere,color:Colors.white,size: 28.0,),
        new Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: new Text("Poll created.\n Share the code with friends",
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontFamily: "Roboto"
            ))),
        new Padding(
            padding: const EdgeInsets.only(top:15.0),
            child: new Container(
              padding: const EdgeInsets.all(10.0),
              color: ColorConstants.LOGIN_BUTTON_BACKGROUND_COLOR,
              child: new GestureDetector(
                onLongPress: (){
                  share("I've create a movie poll called ${mPollName}. To vote copy the following code into the Movie Night App:\n ${reference.key}");
                  Clipboard.setData(new ClipboardData(text: reference.key));
                  Scaffold.of(mContext).showSnackBar(new SnackBar(content: new Text("Poll reference id was copied to your clipboard.")));
                },
                child: new Text("${reference.key}",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontFamily: "Roboto-Thin"
                    )),
              ),
            ),
        )
      ],
    );
  }

  Widget buildPollCreatingState() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Theme(
          data: Theme.of(context).copyWith(accentColor: Colors.white),
          child: new CircularProgressIndicator(
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: new Text("Creating poll. Please wait..",
            textAlign: TextAlign.center,
            style: new TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontFamily: "Roboto"
          ),),
        )
      ],
    );
  }
}