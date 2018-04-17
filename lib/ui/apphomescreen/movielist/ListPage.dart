import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'package:movieee_app/data/Configs.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/ui/apphomescreen/movielist/MoviePoster.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ListPageState();
}

class ListPageState extends State<ListPage> {

  List<Movie> mMovieListAdapter;
  NetworkManager mNetworkManager = new NetworkManager();

  int mDataPageCounter = 1;

  ScrollController mScrollController = new ScrollController();

  int mThresholdValue = 7;

  @override
  void initState() {
    super.initState();
    mMovieListAdapter = [];
    loadMovieData();
  }

  void loadMovieData() {
    mNetworkManager.getMovieData(mDataPageCounter).then((movieList){
      setState((){
        mMovieListAdapter.insertAll((mMovieListAdapter.length == 0?0:mMovieListAdapter.length - 1),movieList);
      });
    });
    mDataPageCounter++;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.0
      ),
      child: new CustomScrollView(
            slivers: <Widget>[
              new SliverGrid(
                  delegate: new SliverChildBuilderDelegate(
                     (BuildContext context, int index) {
                       if (index == mMovieListAdapter.length - mThresholdValue) {
                         loadMovieData();
                       }
                       return getGridChildItem(context,mMovieListAdapter[index]);
                     },
                     childCount: mMovieListAdapter.length
                  ),
                  gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.60,
                  )
              )
            ],
          ),
    );
  }

  Widget getGridChildItem(BuildContext context, Movie movie) {
    return new MoviePoster(movie);
  }

}