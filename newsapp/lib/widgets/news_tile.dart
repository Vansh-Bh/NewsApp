import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/pages/article_view.dart';
import 'package:newsapp/services/layout.dart';

class NewsTiles extends StatelessWidget {
  final ArticleModel article;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  NewsTiles({
    required this.article,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ArticleView(blogUrl: article.url));
      },
      child: Padding(
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
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: article.urlToImage != null
                          ? CachedNetworkImage(
                              imageUrl: article.urlToImage!,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Image.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 'asset/image_not_found_dark.png'
                                  : 'asset/image_not_found_light.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
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
                              DateFormat.yMd().add_jm().format(
                                  DateTime.tryParse(article.publishedAt) ??
                                      DateTime.now()),
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            )),
                        IconButton(
                          onPressed: onBookmark,
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
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
      ),
    );
  }
}
