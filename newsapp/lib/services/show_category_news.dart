import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/show_category.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCategoriesNews(String category) async {
    String? apiKey = dotenv.env["API_KEY"];
    String url =
        "https://gnews.io/api/v4/top-headlines?category=$category&lang=en&country=in&max=10&apikey=$apiKey";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsonData["articles"].forEach((element) {
        if (element["image"] != null) {
          ShowCategoryModel categoryModel = ShowCategoryModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["image"],
            content: element["content"],
            publishedAt: element["publishedAt"],
          );
          categories.add(categoryModel);
        }
      });
    }
  }
}
