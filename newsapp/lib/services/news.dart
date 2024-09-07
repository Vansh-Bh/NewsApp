import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/show_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCategoriesNews(String category) async {
    String? apiKey = dotenv.env["API_KEY"];
    String url =
        "https://gnews.io/api/v4/top-headlines?category=$category&lang=en&country=in&max=10&apikey=$apiKey";
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<dynamic> articles = jsonData["articles"];

        // Cache the data
        await cacheData('categoryNews_$category', articles);

        categories = articles
            .where((element) => element["image"] != null)
            .map((element) => ShowCategoryModel(
                  title: element["title"],
                  description: element["description"],
                  url: element["url"],
                  urlToImage: element["image"],
                  content: element["content"],
                  publishedAt: element["publishedAt"],
                ))
            .toList();
      } else {
        print('HTTP Error: ${response.statusCode}');
        // Load cached data if API call fails
        await loadCachedData(category);
      }
    } catch (e) {
      print('Error fetching data from API: $e');
      // Load cached data if API call fails
      await loadCachedData(category);
    }
  }

  Future<void> cacheData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data);
    await prefs.setString(key, jsonData);
    print('Data cached with key: $key');
  }

  Future<void> loadCachedData(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('categoryNews_$category');
    if (jsonData != null) {
      List<dynamic> articles = jsonDecode(jsonData);
      categories = articles
          .where((element) => element["image"] != null)
          .map((element) => ShowCategoryModel(
                title: element["title"],
                description: element["description"],
                url: element["url"],
                urlToImage: element["image"],
                content: element["content"],
                publishedAt: element["publishedAt"],
              ))
          .toList();
      print('Loaded cached data successfully.');
    } else {
      print('No cached data available.');
    }
  }
}
