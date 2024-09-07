import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/model/category_model.dart';
import 'package:newsapp/pages/bookmark.dart';
import 'package:newsapp/services/theme_changer.dart';
import 'package:newsapp/widgets/catefory_tile.dart';
import 'package:newsapp/widgets/news_tile.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/widgets/search.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

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
  List<ArticleModel> bookmarkedArticles = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedArticles();
    fetchData();
  }

  Future<void> fetchData() async {
    String? apiKey = dotenv.env["API_KEY"];
    final apiUrl =
        'https://gnews.io/api/v4/top-headlines?lang=en&country=in&max=10&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          articles = (data['articles'] as List)
              .map((article) => ArticleModel(
                    url: article['url'],
                    title: article['title'],
                    description: article['description'],
                    urlToImage: article['image'],
                    publishedAt: article['publishedAt'],
                  ))
              .toList();
          _loading = false;
        });
        await cacheData('newsData', data['articles']);
        print('Data fetched from API and cached successfully.');
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from API: $e');
      final cachedData = await getCachedData('newsData');
      if (cachedData != null) {
        setState(() {
          articles = (cachedData as List)
              .map((article) => ArticleModel(
                    url: article['url'],
                    title: article['title'],
                    description: article['description'],
                    urlToImage: article['image'],
                    publishedAt: article['publishedAt'],
                  ))
              .toList();
          _loading = false;
        });
        print('Loaded cached data successfully.');
      } else {
        print('No cached data available.');
      }
    }
  }

  Future<void> cacheData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data);
    await prefs.setString(key, jsonData);
    print('Data cached with key: $key');
  }

  Future<dynamic> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);
    if (jsonData != null) {
      print('Data retrieved from cache with key: $key');
      return jsonDecode(jsonData);
    }
    print('No data found in cache with key: $key');
    return null;
  }

  Future<void> _loadBookmarkedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bookmarkedArticlesJson = prefs.getString('bookmarked_articles');
    if (bookmarkedArticlesJson != null) {
      List<dynamic> jsonList = jsonDecode(bookmarkedArticlesJson);
      setState(() {
        bookmarkedArticles = jsonList
            .map(
                (jsonArticle) => ArticleModel.fromJson(jsonDecode(jsonArticle)))
            .toList();
      });
    }
  }

  Future<void> _saveBookmarkedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = bookmarkedArticles
        .map((article) => jsonEncode(article.toJson()))
        .toList();
    await prefs.setString('bookmarked_articles', jsonEncode(jsonList));
  }

  void _toggleBookmark(String url) {
    setState(() {
      final index = bookmarkedArticles.indexWhere((a) => a.url == url);
      if (index != -1) {
        bookmarkedArticles.removeAt(index);
      } else {
        final article = articles.firstWhere((a) => a.url == url);
        bookmarkedArticles.add(article);
      }
      _saveBookmarkedArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
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
              Get.to(
                Bookmark(
                  bookmarkedArticles: bookmarkedArticles,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(
                  articles,
                  bookmarkedArticles.map((article) => article.url).toList(),
                  _toggleBookmark,
                ),
              );
            },
          ),
          Obx(() => IconButton(
                icon: Icon(themeService.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode),
                onPressed: () {
                  themeService.switchTheme();
                },
              )),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
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
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                    const SizedBox(
                      height: 10.0,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        return NewsTiles(
                          article: articles[index],
                          isBookmarked: bookmarkedArticles
                              .any((a) => a.url == articles[index].url),
                          onBookmark: () =>
                              _toggleBookmark(articles[index].url),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
