import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'package:movieee_app/data/Configs.dart';
import 'package:movieee_app/data/NetworkManager.dart';
import 'package:movieee_app/ui/homescreen/homescreensearchbar.dart';

class HomeScreenMovieList extends StatefulWidget implements SearchBarInterface {

  HomeScreenMovieListInterface updateMovieInterface;
  HomeScreenMovieSelected movieSelectedInterface;

  HomeScreenMoveiListState state;

  HomeScreenMovieList(this.updateMovieInterface,this.movieSelectedInterface){
    state = new HomeScreenMoveiListState(updateMovieInterface,movieSelectedInterface);
  }

  @override
  State<StatefulWidget> createState() => state;

  @override
  void filterSearchResult(String searchTerm) {
    state.filterSearchResult(searchTerm);
  }

}

abstract class HomeScreenMovieListInterface{
   updateMovieNumber(int length);
}

abstract class HomeScreenMovieSelected{
  movieSelected(Movie movie,BuildContext context);
}

class HomeScreenMoveiListState extends State<HomeScreenMovieList> {

  List<Movie> mAdapterData;
  NetworkManager mNetworkManager = new NetworkManager();

  int mPageCounter = 1;

  ScrollController scrollController = new ScrollController(
  );

  var THRESHOLD = 8;

  HomeScreenMovieListInterface updateMovieInterface;
  HomeScreenMovieSelected movieSelectedInterface;

  HomeScreenMoveiListState(this.updateMovieInterface,this.movieSelectedInterface);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mAdapterData = [];
    loadMovieData();
  }


  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height.toString());
    return new Expanded(
      child: new CustomScrollView(
        slivers: <Widget>[
          new SliverGrid(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == mAdapterData.length - THRESHOLD) {
                      loadMovieData();
                    }
                return createNewMoviePosterWidget(mAdapterData[index]);
              },
              childCount: mAdapterData.length,
            ),
          )
        ],
      ),
    );
  }

  Widget createNewMoviePosterWidget(Movie movie) {
    return new InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        movieSelectedInterface.movieSelected(movie,context);
      },
      child: new Padding(
        padding: const EdgeInsets.all(3.0),
        child: new Container(
          child: new Column(
            children: <Widget>[
              new Image.network(
                  Configs.IMAGE_URL + movie.mPosterUrl,
                height: 200.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: new Center(
                  child: new Align(
                    alignment: Alignment.center,
                    child: new Text(movie.mTitle,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadMovieData() {
      mNetworkManager.getMovieData(mPageCounter).then((movieList){
        setState((){
          mAdapterData.insertAll((mAdapterData.length == 0?0:mAdapterData.length - 1),movieList);
          updateMovieInterface.updateMovieNumber(mAdapterData.length);
        });
      });
      mPageCounter++;
  }

  void filterSearchResult(String searchTerm) {
    print("Filtering Search Results with Search Term " + searchTerm);
    if (searchTerm.length == 0) {
      mPageCounter = 1;
      mAdapterData.clear();
      loadMovieData();
    } else {
      List<Movie> list = [];
      for (var movie in mAdapterData) {
        if (movie.mTitle.contains(searchTerm)) {
          list.add(movie);
        }
      }
      setState((){
        mAdapterData = list;
        updateMovieInterface.updateMovieNumber(mAdapterData.length);
      });
    }
  }
}