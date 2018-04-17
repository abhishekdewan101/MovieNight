import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttery/framing.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/ui/apphomescreen/movielist/MoviePosterDetail.dart';
import 'package:movieee_app/ui/homescreen/homescreenmovielist.dart';
import 'package:movieee_app/ui/homescreen/homescreennumberofmovies.dart';
import 'package:movieee_app/ui/homescreen/homescreensearchbar.dart';
import 'package:movieee_app/ui/homescreen/homescreentab.dart';

class HomeScreen extends StatelessWidget implements HomeScreenMovieSelected {

  HomeScreenTab titles =  new HomeScreenTab(Icons.movie,"Title",true);
  HomeScreenTab local =  new HomeScreenTab(Icons.local_movies,"Local",false);

  @override
  Widget build(BuildContext context) {

    HomeScreenNumberOfMovies movies = new HomeScreenNumberOfMovies();
    HomeScreenMovieList movieList = new  HomeScreenMovieList(movies,this);
    HomeScreenSearchBar searchBar = new HomeScreenSearchBar(movieList);

    SystemChrome.setEnabledSystemUIOverlays([]);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Scaffold(
      backgroundColor: Colors.white12,
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
              width: double.infinity,
              height: 50.0,
              margin: new EdgeInsets.only(top: 0.0),
              padding: new EdgeInsets.only(left: 15.0),
              child: new Center(
                  child: new Text(
                      "Movieeee",
                    style: new TextStyle(
                      color:Colors.white,
                      fontFamily: "Roboto-Thin",
                      fontSize: 24.0
                    ),
                  )
              )
            ),
            buildDivider(),
            movies,
            searchBar,
            movieList
          ],
        ),
      ),
    );
  }

//  new Row(
//  children: <Widget>[
//  new InkWell(
//  splashColor: Colors.white12,
//  onTap: (){handleTabInput(0);},
//  child: titles,
//  ),
//  new InkWell(
//  splashColor: Colors.white12,
//  onTap: (){handleTabInput(1);},
//  child: local,
//  )
//  ],
//  )

//  Container buildNumberOfMoviesInTheatre() {
//    return new Container(
//            width: double.infinity,
//            height: 30.0,
//            child: new Padding(
//              padding: new EdgeInsets.only(top: 10.0),
//              child: new Center(
//                child: new Text(
//                  "38 TITLES IN THEATRES",
//                  style: new TextStyle(
//                    color: Colors.grey.shade300,
//                    fontSize: 12.0,
//                    fontFamily: "Roboto-Thin",
//                    fontWeight: FontWeight.bold
//                  ),
//                ),
//              ),
//            ),
//          );
//  }

  Container buildDivider() {
    return new Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.deepOrange,
          );
  }

  void handleTabInput(int i) {
    if (i == 0) {
      local.toggleSelectedState(false);
      titles.toggleSelectedState(true);
    } else {
      local.toggleSelectedState(true);
      titles.toggleSelectedState(false);
    }

  }

  @override
  movieSelected(Movie movie,BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context,_,__) {
          return new MoviePosterDetail(movie);
        },
        transitionsBuilder: (_,Animation<double> animation,__,Widget child) {
          return new SlideTransition(
              position : new Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero
              ).animate(animation),
              child: child
          );
        }
    ));
  }

}