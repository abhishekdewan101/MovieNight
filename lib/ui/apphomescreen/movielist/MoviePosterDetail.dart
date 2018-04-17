import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'package:movieee_app/data/Configs.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/ui/apphomescreen/pollcreation/PollCreation.dart';
import 'package:movieee_app/utils/ColorConstants.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviePosterDetail extends StatelessWidget {
  Movie movie;

  BuildContext mContext;

  MoviePosterDetail(this.movie);

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
    return new Padding(
          padding: new EdgeInsets.only(
              top: topMargin),
          child: new Column(
            children: <Widget>[
             getTopHeroImageWithBackButton(),
             new Expanded(child:getMovieDetailCard()),
            ],
          ));
  }

  Widget getTopHeroImageWithBackButton() {
    return new Stack(
      children: <Widget>[
        buildHeroImage(mContext),
        getBackButton(),
      ],
    );
}

  Widget getMovieDetailCard() {
    return new Padding(
      padding: const EdgeInsets.only(top:10.0,left: 10.0,right:10.0),
      child: new Builder(builder: (BuildContext context){
        return new Container(
          width: MediaQuery.of(context).size.width,
          child: new Material(
            borderRadius: new BorderRadius.only(
              topLeft: new Radius.circular(20.0),
              topRight: new Radius.circular(20.0)
            ),
            color: Colors.white,
            child: getMovieDetails()
          )
        );
      })
    );
  }

  Widget getMovieDetails() {
    return new SingleChildScrollView(
      child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getMovieTitle(),
              getMoveDescription(),
              getButtonRow(),
            ],
          )
      ),
    );
  }

  Widget getButtonRow() {
    return new Builder(
      builder: (BuildContext context) {
        return new Row(
          children: <Widget>[
            new Expanded(child: buildTrailerButton(context)),
            new Expanded(child: buildPollButton(context)),
          ],
        );
      });
  }

  Widget getMovieTitle() {
    return new Text(movie.mTitle,style: new TextStyle(
      color:Colors.black,
      fontSize:26.0,
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold
    ));
  }

  Widget getMoveDescription() {
    return new Padding(
      padding: const EdgeInsets.only(top:15.0),
      child: new Text(movie.mDescription,style: new TextStyle(
          color:Colors.black54,
          fontSize:16.0,
          fontFamily: "Roboto"
      )),
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
  

  Widget buildTrailerButton(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: new Material(
          color: Colors.lightBlue,
          borderRadius: new BorderRadius.circular(10.0),
          child: new InkWell(
            onTap: () {
              launchTrailer(context, movie.mTitle);
            },
            splashColor: Colors.white,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: new Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                new Text("Watch Trailer",
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

  Widget buildHeroImage(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 300.0,
      child: new Image.network(
        Configs.IMAGE_URL + movie.mPosterUrl,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }

  Widget buildPollButton(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(top: 30.0,left: 10.0),
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: new Material(
          color: Colors.green,
          borderRadius: new BorderRadius.circular(10.0),
          child: new InkWell(
            onTap: () {
              launchPoll(context, movie.mTitle);
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

  void launchTrailer(BuildContext context, String url) async {
    var launchURL =
        "https://www.youtube.com/results?search_query=" + url + " trailer";
    _launchURL(launchURL);
  }

  _launchURL(String launchURL) async {
    print(launchURL);
    if (await canLaunch(Uri.encodeFull(launchURL))) {
      await launch(Uri.encodeFull(launchURL));
    } else {
      throw 'Could not launch ${Uri.encodeFull(launchURL)}';
    }
  }

  void launchPoll(BuildContext context, String mTitle) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          return new PollCreation(movie);
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new SlideTransition(
              position:
                  new Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .animate(animation),
              child: child);
        }));
  }





}
