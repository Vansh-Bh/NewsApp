class ArticleModel {
  String? author;
  String? title;
  String? description;
  late String url;
  String? urlToImage;
  String? content;
  late String publishedAt;

  ArticleModel(
      {this.author,
      this.content,
      this.description,
      this.title,
      required this.url,
      this.urlToImage,
      required this.publishedAt});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      url: json['url'],
      title: json['title'],
      description: json['description'],
      urlToImage: json['image'],
      publishedAt: json['publishedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'description': description,
      'image': urlToImage,
      'publishedAt': publishedAt,
    };
  }
}
