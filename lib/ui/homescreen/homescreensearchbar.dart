import 'dart:ui';

import 'package:flutter/material.dart';

class HomeScreenSearchBar extends StatefulWidget {

  SearchBarInterface mListner;

  HomeScreenSearchBar(this.mListner);

  @override
  State<StatefulWidget> createState() => new HomeScreenSearchBarState(mListner);
}

class HomeScreenSearchBarState extends State<HomeScreenSearchBar> {

  bool mSearchBarWasTapped = false;

  TextEditingController editingController = new TextEditingController();

  SearchBarInterface searchBarInterface;

  HomeScreenSearchBarState(this.searchBarInterface);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 60.0,
      child: new Padding(
        padding: new EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0,bottom: 13.0),
        child: new Material(
          color: Colors.grey.shade50.withOpacity(0.2),
          borderRadius: new BorderRadius.circular(20.0),
          child: new InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: (){
              mSearchBarWasTapped = true;
            },
            child: new Center(
              child: new Padding(
                  padding: const EdgeInsets.only(left: 20.0,right:30.0),
                  child: new TextField(
                    controller: editingController,
                    onSubmitted: (stringValue){
                      searchBarInterface.filterSearchResult(stringValue);
                    },
                    style: new TextStyle(
                        color: Colors.white70,
                        fontFamily: "Roboto"
                    ),
                    decoration: new InputDecoration(
                        hintText: "Search for movies by title",
                        hintStyle: new TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.grey.shade50.withOpacity(0.4)
                        ),
                        border: InputBorder.none,
                        contentPadding: new EdgeInsets.only(bottom: 1.0),
                        prefixIcon: new Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: new Icon(Icons.search,color:Colors.grey.shade50.withOpacity(0.4)),
                        )
                    ),
                  ),
                ),
            ),
            ),
          ),
        ),
    );
  }
}

abstract class SearchBarInterface{
  void filterSearchResult(String searchTerm);
}


