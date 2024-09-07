// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/model/show_category.dart';
import 'package:newsapp/pages/article_view.dart';
import 'package:newsapp/services/layout.dart';
import 'package:newsapp/services/show_category_news.dart';

class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({super.key, required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoriesNews(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ShowCategory(
                  image: categories[index].urlToImage,
                  title: categories[index].title,
                  url: categories[index].url,
                  publishedAt: categories[index].publishedAt,
                );
              }),
        ));
  }
}

class ShowCategory extends StatelessWidget {
  String image, title, url, publishedAt;
  ShowCategory(
      {super.key, required this.image,
      required this.title,
      required this.url,
      required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ArticleView(blogUrl: url));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          surfaceTintColor: Colors.white24,
          elevation: 8,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Layout.iconText(
                        const Icon(Icons.timer_outlined),
                        Text(
                          DateFormat.yMd().add_jm().format(
                              DateTime.tryParse(publishedAt) ?? DateTime.now()),
                          style: const TextStyle(fontSize: 15.0),
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.bookmark_border),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
