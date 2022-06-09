import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:news_app/Newsview.dart';
import 'package:news_app/category/category.dart';
import 'package:news_app/model/model.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getnewsbyquery("india");
    getnewsbyprovider();
  }

  TextEditingController cont = new TextEditingController();
  List<String> navbaritem = [
    "Top News",
    "India",
    "Health",
    "India",
    "Covid",
    "Cricket",
    "Sports",
    "Ipl",
    "ukraine",
    "china",
    "Delhi",
    "Mumbai",
    "Korba",
    "Russia",
    "US",
    "Narendra Modi",
    "Stocks",
    "Coding",
    "Blockchain",
    "Web 3.0",
    "Asia",
    "Pakistan",
    "Sports",
    "Europe",
    "petrol",
    "gas",
    "coal",
    "electricity",
    "water"
  ];
  final List items = [
    Colors.blueAccent,
    Colors.orange,
    Colors.red,
    Colors.yellow,
  ];
  List<NewsQueryModel> newsmodellist = <NewsQueryModel>[];
  List<NewsQueryModel> newsmodellistprovider = <NewsQueryModel>[];

  bool isloading = true;
  getnewsbyquery(String query) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&apiKey=9561da83005649bb9d198deb8dd116c0";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print(data);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;

          NewsQueryModel recipemodel = new NewsQueryModel();
          recipemodel = NewsQueryModel.fromMap(element);
          newsmodellist.add(recipemodel);
          setState(() {
            isloading = false;
          });
          if (i == 10) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  getnewsbyprovider() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=9561da83005649bb9d198deb8dd116c0";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print(data);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel recipemodel = new NewsQueryModel();
        recipemodel = NewsQueryModel.fromMap(element);
        newsmodellistprovider.add(recipemodel);
        setState(() {
          isloading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Krish NEWS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color.fromARGB(120, 68, 255, 152)),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(2, 0, 5, 0),
                          child: Icon(
                            Icons.search,
                            color: Colors.blue[200],
                          )),
                      onTap: () {
                        newsmodellist.clear();
                        getnewsbyquery(cont.text);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          newsmodellist.clear();
                          getnewsbyquery(value);
                        },
                        controller: cont,
                        decoration: const InputDecoration(
                            hintText: "Search news ", border: InputBorder.none),
                      ),
                    ),
                  ],
                )),
            Container(
              height: 60,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navbaritem.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Category(Query: navbaritem[index])),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            navbaritem[index],
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: isloading
                  ? CircularProgressIndicator()
                  : CarouselSlider(
                      options: CarouselOptions(
                          height: 200, autoPlay: true, enlargeCenterPage: true),
                      items: newsmodellistprovider.map((item) {
                        return Builder(builder: (BuildContext context) {
                          try {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsView(
                                              url: item.newsUrl,
                                            )));
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          item.newsimg,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12
                                                        .withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 0),
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    item.newsHead,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))),
                                        )),
                                  ])),
                            ));
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        });
                      }).toList(),
                    ),
            ),
            Container(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Latest News ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                          try {
                            return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                margin: EdgeInsets.all(10),
                                height: 260,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsView(
                                                  url: newsmodellist[index]
                                                      .newsUrl,
                                                )));
                                  },
                                  child: Card(
                                    elevation: 25,
                                    color: Color.fromARGB(113, 255, 139, 7),
                                    shadowColor: Color.fromARGB(255, 0, 0, 0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                                      Colors.black
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end:
                                                        Alignment.bottomCenter),
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
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  newsmodellist[index]
                                                              .newsDocs
                                                              .length >
                                                          50
                                                      ? "${newsmodellist[index].newsDocs.substring(0, 55)}....."
                                                      : newsmodellist[index]
                                                          .newsDocs,
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
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        }),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Category(Query: "Technology")));
                          },
                          child: Text("Show More"))
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
