import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/model/category_model.dart';
import 'package:newsapp/pages/article_view.dart';
import 'package:newsapp/pages/bookmark.dart';
import 'package:newsapp/pages/category_news.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/services/layout.dart';
import 'package:newsapp/services/theme_changer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [
    CategoryModel(categoryName: 'Business'),
    CategoryModel(categoryName: 'Technology'),
    CategoryModel(categoryName: 'Sports'),
    CategoryModel(categoryName: 'Entertainment'),
    CategoryModel(categoryName: 'Health'),
  ];

  List<ArticleModel> articles = [];
  List<String> bookmarkedArticleIds = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadBookmarkedArticleIds();
  }

  Future<void> fetchData() async {
    // Replace with your News API key
    final apiUrl =
        'http://newsapi.org/v2/top-headlines?country=in&apiKey=54145bc9681c42de9a6cc831aa90502b';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          articles = (data['articles'] as List)
              .map((article) => ArticleModel(
                    url: article['url'],
                    title: article['title'],
                    description: article['description'],
                    urlToImage: article['urlToImage'],
                    publishedAt: article['publishedAt'],
                  ))
              .toList();
          _loading = false;
        });
      } else {
        print('API Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  }

  _loadBookmarkedArticleIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedArticleIds =
          prefs.getStringList('bookmarked_article_ids') ?? [];
    });
  }

  _saveBookmarkedArticleIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarked_article_ids', bookmarkedArticleIds);
  }

  _toggleBookmark(String articleUrl) {
    setState(() {
      if (bookmarkedArticleIds.contains(articleUrl)) {
        bookmarkedArticleIds.remove(articleUrl);
      } else {
        bookmarkedArticleIds.add(articleUrl);
      }
      _saveBookmarkedArticleIds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "News",
              textAlign: TextAlign.center,
            ),
            Text(
              "Waves",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Bookmark(
                    bookmarkedArticleIds: bookmarkedArticleIds,
                    allArticles: articles,
                  ),
                ),
              );
            },
          ),
          ChangeThemeButton()
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      height: 40,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              categoryName: categories[index].categoryName,
                            );
                          }),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Headlines!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                            article: articles[index],
                            isBookmarked: bookmarkedArticleIds
                                .contains(articles[index].url),
                            onBookmark: () =>
                                _toggleBookmark(articles[index].url),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final image, categoryName;
  CategoryTile({this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.blue[600],
              ),
              child: Center(
                  child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final ArticleModel article;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  BlogTile({
    required this.article,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: article.url),
          ),
        );
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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage ??
                          'https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png',
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

class MyAppThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
