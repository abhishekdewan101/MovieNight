import 'package:flutter/material.dart';
import 'package:movieee_app/data/Configs.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/ui/apphomescreen/movielist/MoviePosterDetail.dart';
import 'package:movieee_app/utils/NavigatorUtils.dart';

class MoviePoster extends StatefulWidget {
  MoviePosterState posterState;

  MoviePoster(Movie movie) {
    posterState = new MoviePosterState(movie);
  }

  @override
  State<StatefulWidget> createState() => posterState;
}

class MoviePosterState extends State<MoviePoster> {
  Movie movie;
  MoviePosterState(this.movie);

  @override
  Widget build(BuildContext context) {
    return getNormalMoviePoster();
  }

  Widget getNormalMoviePoster() {
    return new Material(
      borderRadius: new BorderRadius.circular(10.0),
      color: Colors.white,
      child: new InkWell(
        onTap: () { showMovieDetail(context,movie); },
        splashColor: Colors.black26,
        child: new Stack(
          children: <Widget>[
            new Image.network(
              Configs.IMAGE_URL + movie.mPosterUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }

  void showMovieDetail(BuildContext context,Movie movie) {
    NavigatorUtils.pushRouteWithSlideAnimation(context,new MoviePosterDetail(movie));
  }
}
