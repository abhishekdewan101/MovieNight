import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttery/framing.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieee_app/managers/FirebaseDatabaseManager.dart';
import 'package:movieee_app/managers/FirebaseLoginManager.dart';
import 'package:log/log.dart';
import 'package:movieee_app/ui/apphomescreen/MainHomeScreen.dart';
import 'package:movieee_app/ui/homescreen/HomeScreen.dart';
import 'package:movieee_app/utils/ColorConstants.dart';
import 'package:movieee_app/utils/Constants.dart';
import 'package:movieee_app/utils/NavigatorUtils.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CreateUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CreateUserState();
}

class CreateUserState extends State<CreateUser> {
  FirebaseLoginManager mFirebaseLoginManager = new FirebaseLoginManager();
  FirebaseDatabaseManager mFirebaseDatabaseManager =
      new FirebaseDatabaseManager();

  BuildContext mContext;

  TextEditingController mDisplayNameController = new TextEditingController();
  TextEditingController mEmailController = new TextEditingController();
  TextEditingController mPasswordController = new TextEditingController();
  TextEditingController mRepeatPasswordController = new TextEditingController();

  File mUserImage;

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
    var topMargin = MediaQuery.of(mContext).padding.top;
    return new SingleChildScrollView(
      child: new Padding(
          padding: new EdgeInsets.only(
              bottom: 20.0, left: 20.0, right: 20.0, top: topMargin + 20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getBackButton(),
              getCircleAvatar(),
              getInputForm(),
              getLoginButton()
            ],
          )),
    );
  }

  Widget getBackButton() {
    return new Align(
      alignment: Alignment.centerLeft,
      child: new Material(
        borderRadius: new BorderRadius.circular(100.0),
        color: ColorConstants.LOGIN_BUTTON_BACKGROUND_COLOR,
        child: new InkWell(
          splashColor: Colors.white,
          onTap: () {
            Navigator.of(mContext).pop();
          },
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget getCircleAvatar() {
    return new Padding(
      padding: new EdgeInsets.only(top: 20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Material(
            borderRadius: new BorderRadius.circular(100.0),
            child: new InkWell(
                splashColor: Colors.white,
                onTap: () {
                  getImage();
                },
                child: getProfileImage()),
          )
        ],
      ),
    );
  }

  Widget getInputField(
      TextEditingController controller, String hintText, bool isPasswordField) {
    return new Container(
      decoration: new BoxDecoration(
          color: Colors.transparent,
          border: new Border(
              bottom:
                  new BorderSide(color: ColorConstants.LOGIN_HINT_TEXT_COLOR))),
      child: new TextField(
        obscureText: isPasswordField,
        controller: controller,
        style: new TextStyle(color: Colors.white),
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: new TextStyle(
            color: ColorConstants.LOGIN_HINT_TEXT_COLOR,
          ),
        ),
      ),
    );
  }

  Widget getInputForm() {
    return new Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: getInputField(mDisplayNameController, "Display name", false),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: getInputField(mEmailController, "Email", false),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: getInputField(mPasswordController, "Password", true),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: getInputField(
                mRepeatPasswordController, "Repeat password", true),
          )
        ],
      ),
    );
  }

  Widget getLoginButton() {
    return new Padding(
      padding: new EdgeInsets.only(top: 40.0),
      child: new Container(
        width: 300.0,
        height: 50.0,
        child: new Material(
          color: ColorConstants.LOGIN_BUTTON_BACKGROUND_COLOR,
          borderRadius: new BorderRadius.circular(50.0),
          child: new InkWell(
            onTap: () {
              handleLoginWithEmailAndPassword();
            },
            splashColor: Colors.white,
            child: new Center(
              child: new Text("CREATE ACCOUNT",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "Roboto")),
            ),
          ),
        ),
      ),
    );
  }

  void handleLoginWithEmailAndPassword() {
    if (mDisplayNameController.text.isNotEmpty &&
        mEmailController.text.isNotEmpty &&
        mPasswordController.text.isNotEmpty &&
        mRepeatPasswordController.text.isNotEmpty) {
      if (mPasswordController.text == mRepeatPasswordController.text) {
        showLoadingDialog();
        if (mUserImage != null) {
          createFirebaseUserWithUserImage();
        } else {
          createFirebaseUserWithDefaultImage();
        }
      }
    }
  }

  void createFirebaseUserWithDefaultImage() {
    mFirebaseLoginManager
        .createUserWithEmailAndPassword(
            mEmailController.text, mPasswordController.text)
        .then((user) {
      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = mDisplayNameController.text;
      updateInfo.photoUrl = Constants.EMPTY_PROFILE_PIC_URL;
      mFirebaseLoginManager.updateUserDetails(updateInfo);
      mFirebaseDatabaseManager.pushLoggedInUserDetails(user);
      Navigator.of(mContext).pop();
      NavigatorUtils.pushRouteWithSlideAnimation(mContext, new MainHomeScreen());
    }, onError: (error) => handleFirebaseError(error));
  }

  void createFirebaseUserWithUserImage() {
    mFirebaseLoginManager
        .createUserWithEmailAndPassword(
            mEmailController.text, mPasswordController.text)
        .then((user) {
      mFirebaseDatabaseManager.uploadProfileImage(mUserImage, user.uid).then(
          (uploadSnapShot) {
        UserUpdateInfo updateInfo = new UserUpdateInfo();
        updateInfo.displayName = mDisplayNameController.text;
        updateInfo.photoUrl = uploadSnapShot.downloadUrl.toString();
        mFirebaseLoginManager.updateUserDetails(updateInfo);
        mFirebaseDatabaseManager.pushLoggedInUserDetails(user);
        Navigator.of(mContext).pop();
        NavigatorUtils.pushRouteWithSlideAnimation(mContext, new MainHomeScreen());
      }, onError: (error) => handleFirebaseError(error));
    }, onError: (error) => handleFirebaseError(error));
  }

  void handleError(int errorCode) {
    switch (errorCode) {
      case 1:
        NavigatorUtils.showSnackBarWithMessage(
            mContext, "PASSWORDS DO NOT MATCH");
        break;
      case 2:
        NavigatorUtils.showSnackBarWithMessage(
            mContext, "PLEASE ENSURE ALL FIELDS ARE FILLED");
    }
  }

  handleFirebaseError(error) {
    Log.error(error);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      mUserImage = image;
    });
  }

  Image getProfileImage() {
    if (mUserImage != null) {
      return new Image.file(mUserImage,
          height: 100.0, width: 100.0, fit: BoxFit.cover);
    } else {
      return new Image.asset("assets/profile_common.png",
          width: 100.0, height: 100.0, fit: BoxFit.cover);
    }
  }

  void showLoadingDialog() {
    showDialog(context: mContext,
        child: new ProgressHUD(
          backgroundColor: Colors.black12,
          color: Colors.white,
          containerColor: Colors.transparent,
          borderRadius: 5.0,
        )
    );
  }
}
