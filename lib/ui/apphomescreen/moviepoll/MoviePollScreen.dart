import 'package:flutter/material.dart';
import 'package:movieee_app/data/Configs.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/managers/FirebaseDatabaseManager.dart';
import 'package:movieee_app/utils/ColorConstants.dart';

class MoviePollScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState()  => new MoviePollScreenState();

}

class MoviePollScreenState extends State<MoviePollScreen> {

  BuildContext mContext;

  PollModel mPollModel;

  Map<Movie,int> mAdapterData;

  FirebaseDatabaseManager mFirebaseDatabaseManager = new FirebaseDatabaseManager();
  NetworkManager mNetworkManager = new NetworkManager();

  TextEditingController mPollIdController = new TextEditingController();

  String mPollId;

  bool mUserHasChosen = false;

  @override
  void initState() {
    super.initState();
    mAdapterData = new Map<Movie,int>();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ColorConstants.LOGIN_BACKGROUND_COLOR,
      body: new Builder(builder: (BuildContext context) {
        mContext = context;
        return getScaffoldBody();
      }),
      floatingActionButton: new FloatingActionButton(
        onPressed: addPollData,
        backgroundColor: Colors.green,
        child: new Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget getScaffoldBody() {
    var topMargin = MediaQuery
        .of(mContext)
        .padding
        .top;
    return new Padding(
        padding: new EdgeInsets.only(top: topMargin),
        child: getPollList()
    );
  }

  Widget getPollList() {
    return new Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: getPollScreenByState()

    );
  }

  Widget getPollScreenByState() {
    if (mUserHasChosen) {
      return getUserHasProvidedPoll();
    } else {
      if (mPollModel != null) {
        return getPoll();
      } else {
       return new Center(child: new Text("No Poll Data Added",
          style: new TextStyle(
              color: Colors.white, fontSize: 26.0, fontFamily: "Roboto"),));
      }
    }
  }

  Widget getUserHasProvidedPoll() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(Icons.beenhere, color: Colors.white,size: 26.0,),
        new Padding(
            padding: const EdgeInsets.only(top: 10.0),
          child: new Center(
            child: new Text("Congratulations! You've voted.",
              style: new TextStyle(
                  color: Colors.white, fontSize: 26.0, fontFamily: "Roboto"),),
          ),
        )
      ],
    );
  }

  Widget getPoll() {
    return new Column(
      children: <Widget>[
       new Center(
         child: new Text(mPollModel.mPollName, style: new TextStyle(
            color: Colors.white, fontSize: 26.0, fontFamily: "Roboto")),
       ),
       new Padding(
         padding: const EdgeInsets.only(top:5.0),
         child: new Center(
           child: new Text("(Tap the movie you'd like to vote for)", style: new TextStyle(
               color: Colors.white, fontSize: 18.0, fontFamily: "Roboto")),
         ),
       ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.all(15.0),
            child: new ListView(
              scrollDirection: Axis.vertical,
              children: getListItems(),
            ),
          ),
        )
//        new ListView.builder(
//            scrollDirection: Axis.vertical,
//            itemBuilder: (BuildContext context, int index) {
//              new Text("Movie Name - ${mAdapterData.keys.toList()[index].mTitle} has the poll count equals to ${mAdapterData.values.toList()[index]}");
//            },
//          itemCount: mAdapterData.length,
//        )
      ],
    );
  }

  List<Widget> getListItems() {
    List<Widget> items = [];
    mAdapterData.forEach((movie,int){
      items.add(getItem(movie, int));
    });
    return items;
  }

  Widget getItem(Movie movie, int count) {
    return new Container(
        height: 150.0,
        margin: new EdgeInsets.only(bottom: 10.0),
        width: MediaQuery.of(context).size.width,
        child: new Material(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(10.0),
          child: new InkWell(
              splashColor: Colors.black12,
              onTap: () {
                var newCount = count + 1;
                mFirebaseDatabaseManager.updateMoviePollCount(movie, mPollId,newCount );
                setState(() {
                  mUserHasChosen = true;
                });
              },
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Image.network(
                          Configs.IMAGE_URL + movie.mPosterUrl),
                    ),
                    new Expanded(
                      child: new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(movie.mTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              new Text(movie.mDescription,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: new TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Roboto",
                                      color: Colors.black)),
                              new Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: new Text("Current Poll Count - ${count}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: new TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: "Roboto",
                                        color: Colors.black)),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )),
        ));
  }

  void addPollData() {
    showDialog(
      context: mContext,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Add Poll ID"),
          content: new TextField(
            controller: mPollIdController,
            decoration: new InputDecoration(
                hintText: "Poll ID"
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  mUserHasChosen = false;
                  mAdapterData.clear();
                  getPollFromFirebase(mPollIdController.text);
                  mPollId = mPollIdController.text;
                  mPollIdController.text = "";
                  Navigator.of(mContext).pop();
                },
                child: new Text("Add"))
          ],
        );
      },
    );
  }

  void getPollFromFirebase(String text) {
    mFirebaseDatabaseManager.getPollDataFromFirebase(text).once().then((
        snapshot) {
      mPollModel = new PollModel(snapshot.value["pollName"],snapshot.value["movies"]);
      getMovieDetailsAndCreateList(mPollModel.mPollMovies);
    });
  }

  void getMovieDetailsAndCreateList(Map mPollMovies) {
    mPollMovies.forEach((movieid, movieidcount){
      mNetworkManager.getMovieById(movieid as String).then((movie){
        setState(() {
          mAdapterData[movie] = movieidcount as int;
        });
      });
    });
  }

}

class PollModel {
  String mPollName;
  Map<dynamic,dynamic> mPollMovies;
  
  PollModel(this.mPollName,this.mPollMovies);
}