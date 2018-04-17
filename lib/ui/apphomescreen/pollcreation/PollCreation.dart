import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'package:movieee_app/data/Configs.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieee_app/managers/FirebaseDatabaseManager.dart';
import 'package:movieee_app/managers/FirebaseLoginManager.dart';
import 'package:movieee_app/ui/apphomescreen/pollcreation/SelectPollFriends.dart';
import 'package:movieee_app/utils/ColorConstants.dart';
import 'package:movieee_app/utils/NavigatorUtils.dart';

class PollCreation extends StatefulWidget {
  Movie mMovie;

  PollCreation(this.mMovie);

  @override
  State<StatefulWidget> createState() => new PollCreationState(mMovie);
}

class PollCreationState extends State<PollCreation> {
  FirebaseLoginManager loginManager = new FirebaseLoginManager();
  FirebaseDatabaseManager databaseManager = new FirebaseDatabaseManager();

  Movie mMovie;
  List<Movie> movies = [];

  var mPageCounter = 1;

  NetworkManager mNetworkManager;

  List<Movie> mAdapterData;

  int THRESHOLD = 7;

  BuildContext mContext;

  TextEditingController mPollIdController = new TextEditingController();

  PollCreationState(this.mMovie) {
    movies.add(mMovie);
    mNetworkManager = new NetworkManager();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mAdapterData = [];
    loadMovieData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorConstants.LOGIN_BACKGROUND_COLOR,
      body: new Builder(builder: (BuildContext context) {
        mContext = context;
        return getScaffoldBody();
      })
    );
  }

  Widget getScaffoldBody() {
    return new Container(
      padding: new EdgeInsets.only(top: MediaQuery.of(mContext).padding.top),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new Column(
        children: <Widget>[
          getBackButton(),
          buildSelectedList(mContext),
          buildRestOfMoviesList(mContext, mAdapterData),
          buildPollButton(mContext)
        ],
      ),
    );
  }


  Widget getBackButton() {
    return new Padding(
      padding: const EdgeInsets.only(
          left: 10.0,
          top: 10.0
      ),
      child: new Align(
        alignment: Alignment.centerLeft,
        child: new Material(
          borderRadius: new BorderRadius.circular(100.0),
          color: Colors.black26,
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
      ),
    );
  }

  Map<String, int> getUploadData() {
    Map<String,int> returnMap = new Map();
    for(var movie in movies) {
      returnMap[movie.mTitle] = movie.mId;
    }
    return returnMap;
  }

  void loadMovieData() {
    mNetworkManager.getMovieData(mPageCounter).then((movieList) {
      setState(() {
        mAdapterData.insertAll(
            (mAdapterData.length == 0 ? 0 : mAdapterData.length - 1),
            removeMovieFromList(movieList));
      });
    });
    mPageCounter++;
  }

  List<Movie> removeMovieFromList(List<Movie> movieList) {
    int counter = 0;
    List<Movie> returnList = [];
    for (var movie in movieList) {
      if (!movie.mTitle.contains(mMovie.mTitle)) {
        returnList.add(movie);
      }
    }
    return returnList;
  }

  Widget buildSelectedList(BuildContext context) {
    return new Container(
      height: 200.0,
      child: new Padding(
          padding: new EdgeInsets.only(top: 20.0),
          child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return createItem(context, index);
              })),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return new Container(
        height: 50.0,
        width: 50.0,
        margin: const EdgeInsets.only(top: 20.0, left: 20.0),
        child: new Material(
            color: Colors.black.withOpacity(0.4),
            borderRadius: new BorderRadius.circular(100.0),
            child: new InkWell(
                splashColor: Colors.white,
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Center(
                    child:
                        new Icon(Icons.arrow_back_ios, color: Colors.white)))));
  }

  Widget createItem(BuildContext context, int index) {
    return new Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: new Container(
        width: 100.0,
        height: 100.0,
        child: new Image.network(Configs.IMAGE_URL + movies[index].mPosterUrl),
      ),
    );
  }

  Widget buildRestOfMoviesList(BuildContext context, List<Movie> mAdapterData) {
    return new Expanded(
      child: new ListView.builder(
          itemCount: mAdapterData.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == mAdapterData.length - THRESHOLD) {
              loadMovieData();
            }
            return createSelectionItem(context, index);
          }),
    );
  }

  Widget createSelectionItem(BuildContext context, int index) {
    return new Container(
        height: 150.0,
        margin: new EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        width: MediaQuery.of(context).size.width,
        child: new Material(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(10.0),
          child: new InkWell(
              splashColor: Colors.black12,
              onTap: () {
                handleSelectionTap(index);
              },
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Image.network(
                          Configs.IMAGE_URL + mAdapterData[index].mPosterUrl),
                    ),
                    new Expanded(
                      child: new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(mAdapterData[index].mTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              new Text(mAdapterData[index].mDescription,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Roboto",
                                      color: Colors.black))
                            ],
                          )),
                    ),
                  ],
                ),
              )),
        ));
  }

  Widget buildPollButton(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 10.0,bottom: 10.0),
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: new Material(
          color: Colors.green,
          borderRadius: new BorderRadius.circular(10.0),
          child: new InkWell(
            onTap: () {
              addPollName();
//
            },
            splashColor: Colors.white,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: new Icon(
                    Icons.poll,
                    color: Colors.white,
                  ),
                ),
                new Text("Create Poll",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontSize: 15.0))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addPollName() {
    showDialog(
      context: mContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Add Poll Name"),
          content: new TextField(
            controller: mPollIdController,
            decoration: new InputDecoration(
                hintText: "Poll Name"
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.of(mContext).pop();
                  NavigatorUtils.pushRouteWithSlideAnimation(mContext,new SelectPollFriends(movies,mPollIdController.text));
                  mPollIdController.text = "";
                },
                child: new Text("Add"))
          ],
        );
      },
    );
  }

  void handleSelectionTap(int index) {
    var movieData = mAdapterData[index];
    setState(() {
      mAdapterData.removeAt(index);
      movies.insert(0, movieData);
    });
  }
}

