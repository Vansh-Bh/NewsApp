import 'package:flutter/material.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:newsapp/widgets/news_tile.dart';

class DataSearch extends SearchDelegate<String> {
  final List<ArticleModel> articles;
  final List<String> bookmarkedArticleIds;
  final Function(String) onBookmarkToggle;

  DataSearch(this.articles, this.bookmarkedArticleIds, this.onBookmarkToggle);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<ArticleModel> results = articles
        .where((article) =>
            article.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final ArticleModel article = results[index];
        return NewsTiles(
          article: article,
          isBookmarked: bookmarkedArticleIds.contains(article.url),
          onBookmark: () => onBookmarkToggle(article.url),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<ArticleModel> suggestions = query.isEmpty
        ? articles.take(10).toList()
        : articles
            .where((article) =>
                article.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final ArticleModel article = suggestions[index];
        return NewsTiles(
          article: article,
          isBookmarked: bookmarkedArticleIds.contains(article.url),
          onBookmark: () => onBookmarkToggle(article.url),
        );
      },
    );
  }
}
