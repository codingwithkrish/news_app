import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Newsview.dart';
import '../model/model.dart';

class Category extends StatefulWidget {
  String Query;
  Category({required this.Query});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    super.initState();
    getnewsbyquery(widget.Query);
  }

  List<NewsQueryModel> newsmodellist = <NewsQueryModel>[];
  bool isloading = true;
  String url = "";
  getnewsbyquery(String query) async {
    if (query == "Top News" || query == "India") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=9561da83005649bb9d198deb8dd116c0";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$query&apiKey=9561da83005649bb9d198deb8dd116c0";
    }
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print(data);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel recipemodel = new NewsQueryModel();
        recipemodel = NewsQueryModel.fromMap(element);
        newsmodellist.add(recipemodel);
        setState(() {
          isloading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Krish News")),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.Query,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            isloading
                ? CircularProgressIndicator()
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsmodellist.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(10),
                          height: 260,
                          width: 100,
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsView(
                                            url: newsmodellist[index].newsUrl,
                                          )));
                            }),
                            child: Card(
                              elevation: 25,
                              color: Color.fromARGB(113, 255, 139, 7),
                              shadowColor: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    newsmodellist[index].newsimg,
                                    fit: BoxFit.fitHeight,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsmodellist[index].newsHead,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 20,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            newsmodellist[index]
                                                        .newsDocs
                                                        .length >
                                                    50
                                                ? "${newsmodellist[index].newsDocs.substring(0, 55)}....."
                                                : newsmodellist[index].newsDocs,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          ));
                    }),
          ]),
        ),
      ),
    );
  }
}
