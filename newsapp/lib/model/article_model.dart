class ArticleModel {
  String? author;
  String? title;
  String? description;
  late String url;
  String? urlToImage;
  String? content;
  String? publishedAt;

  ArticleModel(
      {this.author,
      this.content,
      this.description,
      this.title,
      required this.url,
      this.urlToImage,
      this.publishedAt});
}
