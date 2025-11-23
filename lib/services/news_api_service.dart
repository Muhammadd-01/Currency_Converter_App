import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final String source;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String? ?? 'No title',
      description: json['description'] as String? ?? 'No description',
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String?,
      source: json['source']['name'] as String? ?? 'Unknown',
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class NewsApiService {
  // NewsAPI.org - requires free API key
  // Get your free API key from: https://newsapi.org/
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey =
      'YOUR_NEWS_API_KEY_HERE'; // Replace with your API key

  // Get currency and finance news
  Future<List<NewsArticle>> getCurrencyNews({
    int pageSize = 20,
    String language = 'en',
  }) async {
    try {
      // If no API key is set, return mock data
      if (_apiKey == 'YOUR_NEWS_API_KEY_HERE') {
        return _getMockNews();
      }

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything?q=currency OR forex OR exchange rate&sortBy=publishedAt&pageSize=$pageSize&language=$language&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;

        return articles
            .map((article) => NewsArticle.fromJson(article))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception(
            'Invalid API key. Please get a free key from newsapi.org');
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data if API fails
      return _getMockNews();
    }
  }

  // Get financial news
  Future<List<NewsArticle>> getFinancialNews({
    int pageSize = 20,
    String language = 'en',
  }) async {
    try {
      if (_apiKey == 'YOUR_NEWS_API_KEY_HERE') {
        return _getMockNews();
      }

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything?q=finance OR economy OR markets&sortBy=publishedAt&pageSize=$pageSize&language=$language&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;

        return articles
            .map((article) => NewsArticle.fromJson(article))
            .toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      return _getMockNews();
    }
  }

  // Get top business headlines
  Future<List<NewsArticle>> getBusinessHeadlines({
    String country = 'us',
    int pageSize = 20,
  }) async {
    try {
      if (_apiKey == 'YOUR_NEWS_API_KEY_HERE') {
        return _getMockNews();
      }

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/top-headlines?category=business&country=$country&pageSize=$pageSize&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;

        return articles
            .map((article) => NewsArticle.fromJson(article))
            .toList();
      } else {
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } catch (e) {
      return _getMockNews();
    }
  }

  // Mock news data for testing without API key
  List<NewsArticle> _getMockNews() {
    return [
      NewsArticle(
        title: 'Dollar Strengthens Against Major Currencies',
        description:
            'The US dollar gained ground against major currencies as investors await key economic data.',
        url: 'https://example.com/news1',
        imageUrl: null,
        source: 'Financial Times',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        title: 'Euro Zone Inflation Hits Record High',
        description:
            'Inflation in the euro zone reached a new record, putting pressure on the European Central Bank.',
        url: 'https://example.com/news2',
        imageUrl: null,
        source: 'Reuters',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NewsArticle(
        title: 'Cryptocurrency Market Shows Signs of Recovery',
        description:
            'Major cryptocurrencies are showing signs of recovery after weeks of decline.',
        url: 'https://example.com/news3',
        imageUrl: null,
        source: 'Bloomberg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      NewsArticle(
        title: 'Asian Markets Rally on Positive Economic Data',
        description:
            'Asian stock markets rallied following better-than-expected economic indicators.',
        url: 'https://example.com/news4',
        imageUrl: null,
        source: 'CNBC',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NewsArticle(
        title: 'Central Banks Consider Interest Rate Changes',
        description:
            'Several central banks are considering adjusting interest rates in response to inflation.',
        url: 'https://example.com/news5',
        imageUrl: null,
        source: 'Wall Street Journal',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
