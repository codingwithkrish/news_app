class NewsQueryModel {
  late String newsHead;
  late String newsDocs;
  late String newsimg;
  late String newsUrl;
  NewsQueryModel(
      {this.newsHead = "NEWS HEADLINE ",
      this.newsDocs = "Some News ",
      this.newsimg = "Some Url",
      this.newsUrl = "Some Url "});

  factory NewsQueryModel.fromMap(Map news) {
    if (news["urlToImage"] == null) {
      return NewsQueryModel(
          newsHead: news["title"],
          newsDocs: news["description"],
          newsimg: news["url"],
          newsUrl: news["url"]);
    } else {
      return NewsQueryModel(
          newsHead: news["title"],
          newsDocs: news["description"],
          newsimg: news["urlToImage"],
          newsUrl: news["url"]);
    }
  }
}
