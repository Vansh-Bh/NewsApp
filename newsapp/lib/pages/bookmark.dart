// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/services/layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmark extends StatefulWidget {
  final List<ArticleModel> bookmarkedArticles;

  const Bookmark({super.key, required this.bookmarkedArticles});

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[600]),
        ),
      ),
      body: widget.bookmarkedArticles.isEmpty
          ? const Center(
              child: Text('No Bookmarked Articles'),
            )
          : ListView.builder(
              itemCount: widget.bookmarkedArticles.length,
              itemBuilder: (context, index) {
                return BlogTile(
                  article: widget.bookmarkedArticles[index],
                  onBookmark: () {
                    setState(() {
                      widget.bookmarkedArticles.removeAt(index);
                      _saveBookmarkedArticles();
                    });
                  },
                );
              },
            ),
    );
  }

  void _saveBookmarkedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = widget.bookmarkedArticles
        .map((article) => jsonEncode(article.toJson()))
        .toList();
    await prefs.setString('bookmarked_articles', jsonEncode(jsonList));
  }
}


class BlogTile extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onBookmark;

  const BlogTile({super.key, required this.article, required this.onBookmark});

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
          children: [
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
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    article.title ?? 'No Title Available',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                    width: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Layout.iconText(
                          const Icon(Icons.timer_outlined),
                          Text(
                            article.publishedAt,
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                          )),
                      IconButton(
                        onPressed: onBookmark,
                        icon: const Icon(
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
