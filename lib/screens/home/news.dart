import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/news_api_service.dart';
import '../../widgets/glass_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _newsService = NewsApiService();
  List<NewsArticle>? _articles;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    try {
      final articles = await _newsService.getCurrencyNews();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading news: $e')),
        );
      }
    }
  }

  Future<void> _openArticle(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open article')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Currency News'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.arrow_clockwise),
            onPressed: _loadNews,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _articles == null || _articles!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.newspaper,
                        size: 64,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No news available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _articles!.length,
                    itemBuilder: (context, index) {
                      final article = _articles![index];
                      return GlassCard(
                        margin: const EdgeInsets.only(bottom: 16),
                        onTap: () => _openArticle(article.url),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Article Image
                            if (article.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  article.imageUrl!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF4A00E0),
                                            Color(0xFF8E2DE2)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          PhosphorIcons.newspaper,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            if (article.imageUrl != null)
                              const SizedBox(height: 12),

                            // Article Title
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Article Description
                            Text(
                              article.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),

                            // Source and Time
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4A00E0),
                                        Color(0xFF8E2DE2)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    article.source,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  article.timeAgo,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  PhosphorIcons.arrow_square_out,
                                  size: 16,
                                  color: Color(0xFF8E2DE2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
