import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieee_app/managers/FirebaseDatabaseManager.dart';
import 'package:movieee_app/managers/FirebaseLoginManager.dart';
import 'package:log/log.dart';
import 'package:movieee_app/ui/apphomescreen/MainHomeScreen.dart';
import 'package:movieee_app/ui/homescreen/HomeScreen.dart';
import 'package:movieee_app/ui/loginscreen/CreateUser.dart';
import 'package:movieee_app/utils/ColorConstants.dart';
import 'package:movieee_app/utils/NavigatorUtils.dart';
import 'package:progress_hud/progress_hud.dart';

class LoginScreen extends StatelessWidget {

  final FirebaseLoginManager mFirebaseLoginManager = new FirebaseLoginManager();
  final FirebaseDatabaseManager mFirebaseDatabaseManager = new FirebaseDatabaseManager();

  TextEditingController mEmailController = new TextEditingController();
  TextEditingController mPasswordController = new TextEditingController();

  BuildContext mContext;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorConstants.LOGIN_BACKGROUND_COLOR,
      body: new Builder(builder: (BuildContext context){
        mContext = context;
        return getScaffoldBody();
      }),
    );
  }

  Widget getScaffoldBody() {
    
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getLogo(),
            getEmailLoginForm(),
            getLoginButton(),
            getGoogleLoginButton(),
            getCreateAccountWithEmail()
          ],
        ),
      ),
    );
  }

  Widget getLoginButton() {
    return new Padding(
        padding: new EdgeInsets.only(top:40.0),
        child: new Container(
          width: 300.0,
          height: 50.0,
          child: new Material(
            color: ColorConstants.LOGIN_BUTTON_BACKGROUND_COLOR,
            borderRadius: new BorderRadius.circular(50.0),
            child: new InkWell(
              onTap: (){ handleLoginWithEmailAndPassword(); },
              splashColor: Colors.white,
              child: new Center(
                child: new Text("SIGN IN",style: new TextStyle(
                 color: Colors.white,
                 fontSize: 16.0,
                 fontFamily: "Roboto"
                )),
              ),
            ),
          ),
        ),
    );
  }

  Widget getGoogleLoginButton() {
    return new Padding(
      padding: new EdgeInsets.only(top:40.0),
      child: new Container(
        width: 300.0,
        height: 50.0,
        child: new Material(
          color: ColorConstants.LOGIN_BUTTON_BACKGROUND_COLOR,
          borderRadius: new BorderRadius.circular(50.0),
          child: new InkWell(
            onTap: () { handleSiginInSilently(); },
            splashColor: Colors.white,
            child: new Center(
              child: new Text("SIGN IN WITH GOOGLE",style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "Roboto"
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget getEmailLoginForm() {
    return new Padding(
      padding: const EdgeInsets.only(left: 30.0,right: 30.0),
      child: new Center(
        child: new Column(
          children: <Widget>[
            getInputField(mEmailController,"Email",false),
            new Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: getInputField(mPasswordController,"Password",true),
            ),

          ],
        ),
      ),
    );
  }

  Widget getInputField(TextEditingController controller,String hintText,bool isPasswordField) {
    return new Container(
      decoration: new BoxDecoration(
          color: Colors.transparent,
          border: new Border(bottom: new BorderSide(
              color: ColorConstants.LOGIN_HINT_TEXT_COLOR
          ))
      ),
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

  Widget getLogo() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: new Center(
        child: new Text("Movie Night",style: new TextStyle(
         color: Colors.white,
         fontSize: 44.0,
         fontFamily: "Roboto"
        )),
      ),
    );
  }

  Widget getCreateAccountWithEmail() {
    return new Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: new Center(
        child: Container(
          decoration: new BoxDecoration(
            border: new Border(bottom: new BorderSide(color: Colors.white))
          ),
          child: new Material(
            color:Colors.transparent,
            child: new InkWell(
              onTap: (){ handleCreatingNewAccount(); },
              splashColor: Colors.white,
              child: new Text("CREATE NEW ACCOUNT",style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "Roboto"
              )),
            ),
          ),
        ),
      ),
    );
  }

  void handleSignInToFirebase(GoogleSignInAccount account) {
    mFirebaseLoginManager.getGoogleAuthentication(account).then((auth) {
      mFirebaseLoginManager
          .signInToFirebaseWithGoogle(auth.idToken, auth.accessToken)
          .then((user) {
        handleFirebaseLoginSuccess(user);
      }, onError: (error) {
        handleError(error);
      });
    }, onError: (error) {
      handleError(error);
    });
  }

  void handleFirebaseLoginSuccess(FirebaseUser user) {
    Log.message(" Firebase User Has been Logged In " + user.email);
    handleUpdatingDatabase(user);
    Navigator.of(mContext).pop();
    Navigator.of(mContext).push(new MaterialPageRoute(builder: (BuildContext context) => new MainHomeScreen()));
    Scaffold.of(mContext).showSnackBar(new SnackBar(
        content: new Text("${user.displayName} was logged in"),
      )
    );
  }

  void handleUpdatingDatabase(FirebaseUser user) {
    mFirebaseDatabaseManager.pushLoggedInUserDetails(user);
  }

  void handleError(error) {
    Navigator.of(mContext).pop();
    NavigatorUtils.showSnackBarWithMessage(mContext, "Error: ${error}");
    print(error);
  }

  void handleSiginInSilently() {
    showLoadingDialog();
    mFirebaseLoginManager.signInGoogleSilenty().then((account) {
      if (account != null) {
        handleSignInToFirebase(account);
      } else {
        handleSignInToGoogle();
      }
    });
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

  void handleSignInToGoogle() {
    mFirebaseLoginManager.signInToGoogle().then((user) {
      if (user != null) {
        handleSignInToFirebase(user);
      } else {
        Log.error("USER REFUSED TO SIGNIN");
      }
    });
  }

  void handleUserSignOut() {
    mFirebaseLoginManager.signOut();
  }

  void handleLoginWithEmailAndPassword() {
    showLoadingDialog();
    Log.message("UserName - ${mEmailController.text}");
    Log.message("Password - ${mPasswordController.text}");
    if (mEmailController.text.isNotEmpty && mPasswordController.text.isNotEmpty) {
      mFirebaseLoginManager.loginUserWithEmailAndPassword(
          mEmailController.text, mPasswordController.text)
          .then((user) {
        handleFirebaseLoginSuccess(user);
      }, onError: (error) {
        handleError(error);
      });
    } else if (mEmailController.text.isEmpty) {
      handleError("Please enter a valid email.");
    } else if (mPasswordController.text.isEmpty) {
      handleError("Please enter a valid password.");
    }
  }

  void handleCreatingNewAccount() {
    NavigatorUtils.pushRouteWithSlideAnimation(mContext, new CreateUser());
  }
}


