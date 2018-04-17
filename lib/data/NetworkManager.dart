import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Configs.dart';

class NetworkManager {

  Future<List<Movie>> getMovieData(int page) async {
    var response = await http.get(
        Uri.encodeFull(getUrl(page)),
        headers: {
          "Accept" : "application/json"
        }
    );

    Map data = json.decode(response.body);
    return convertMapToModel(data["results"]);
  }

  Future<Movie> getMovieById(String id) async {
    var response = await http.get(Uri.encodeFull(getMovieDetailUrl(id)),
        headers: {
          "Accept": "application/json"
        });

    Map data = json.decode(response.body);
    return converMapToMovie(data);
  }

  String getMovieDetailUrl(String id) {
    print("https://api.themoviedb.org/3/movie/${id}?api_key=${Configs.API_KEY}");
    return "https://api.themoviedb.org/3/movie/${id}?api_key=${Configs.API_KEY}";
  }

  String getUrl(int page) {
    print(Configs.BASE_URL + Configs.DISCOVER_PATH + Configs.API_KEY + "&page="+page.toString());
    return Configs.BASE_URL + Configs.DISCOVER_PATH + Configs.API_KEY + "&page="+page.toString();
  }

  Movie converMapToMovie (data) {
    return new Movie(data["original_title"],
        data["poster_path"],data["backdrop_path"],data["overview"],data["id"]);
  }

  List<Movie> convertMapToModel(data) {
    List<Movie> movieData = new List<Movie>();
    for(data in data) {
      movieData.add(new Movie(data["original_title"],
          data["poster_path"],data["backdrop_path"],data["overview"],data["id"]));
    }

    return movieData;
  }

}

class Movie {
  String mTitle;
  String mPosterUrl;
  String mBackdropUrl;
  String mDescription;
  var mId;

  Movie(this.mTitle, this.mPosterUrl, this.mBackdropUrl, this.mDescription,this.mId);
}