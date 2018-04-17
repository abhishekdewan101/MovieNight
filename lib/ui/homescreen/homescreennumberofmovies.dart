import 'package:flutter/material.dart';
import 'package:movieee_app/ui/homescreen/homescreenmovielist.dart';

class HomeScreenNumberOfMovies extends StatefulWidget implements HomeScreenMovieListInterface {

  HomeScreenNumberOfMoviesState state = new HomeScreenNumberOfMoviesState();

  @override
  State<StatefulWidget> createState() => state;

  @override
  updateMovieNumber(int length) {
    print("The movie length is " + length.toString());
    state.setState(() {
      state.movieLength = length;
    });
  }
}

class HomeScreenNumberOfMoviesState extends State<HomeScreenNumberOfMovies> {

  int movieLength = 0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 30.0,
      child: new Padding(
        padding: new EdgeInsets.only(top: 10.0),
        child: new Center(
          child: new Text(
            movieLength.toString() + " TITLES IN THEATRES",
            style: new TextStyle(
                color: Colors.grey.shade300,
                fontSize: 12.0,
                fontFamily: "Roboto-Thin",
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

}