import 'Section.dart';

class HomepageFeeds {
  final List<Section> sections;
  final String? continuation;
  final Map<String, dynamic> client;

  HomepageFeeds({
    required this.sections,
    this.continuation,
    required this.client,
  });
}