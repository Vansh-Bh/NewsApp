class ShowCategoryModel {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String content;
  final String publishedAt;

  ShowCategoryModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
    required this.publishedAt,
  });

  factory ShowCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShowCategoryModel(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['image'],
      content: json['content'],
      publishedAt: json['publishedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'image': urlToImage,
      'content': content,
      'publishedAt': publishedAt,
    };
  }
}
