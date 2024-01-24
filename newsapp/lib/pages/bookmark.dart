import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/services/layout.dart';

class Bookmark extends StatefulWidget {
  final List<String> bookmarkedArticleIds;
  final List<ArticleModel> allArticles;

  Bookmark({required this.bookmarkedArticleIds, required this.allArticles});

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    List<ArticleModel> bookmarkedArticles = widget.allArticles
        .where((article) => widget.bookmarkedArticleIds.contains(article.url))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Articles'),
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(
              child: Text('No Bookmarked Articles'),
            )
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                return BlogTile(
                  article: bookmarkedArticles[index],
                  onBookmark: () {
                    _toggleBookmark(bookmarkedArticles[index].url);
                  },
                );
              },
            ),
    );
  }

  void _toggleBookmark(String articleUrl) {
    setState(() {
      if (widget.bookmarkedArticleIds.contains(articleUrl)) {
        widget.bookmarkedArticleIds.remove(articleUrl);
      } else {
        widget.bookmarkedArticleIds.add(articleUrl);
      }
      // Save updated bookmarkedArticleIds to storage if necessary
    });
  }
}

class BlogTile extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onBookmark;

  BlogTile({required this.article, required this.onBookmark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        surfaceTintColor: Colors.white30,
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage ??
                        'https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    article.title ?? 'No Title Available',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                    width: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Layout.iconText(
                          Icon(Icons.timer_outlined),
                          Text(
                            article.publishedAt ?? '',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          )),
                      IconButton(
                        onPressed: onBookmark,
                        icon: Icon(
                          Icons.bookmark,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Article {
//   final String url;
//   final String title;
//   final String description;
//   final String urlToImage;
//   final String publishedAt;

//   Article({
//     required this.url,
//     required this.title,
//     required this.description,
//     required this.urlToImage,
//     required this.publishedAt,
//   });
// }
