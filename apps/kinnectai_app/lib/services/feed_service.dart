import 'package:flutter/material.dart';
import 'package:getstream_feed/getstream_feed.dart';

class FeedService with ChangeNotifier {
  late Client _client;
  late FlatFeed _feed;

  FeedService() {
    // Initialize GetStream client with your API key and secret
    _client = Client(
      'your-api-key',
      appId: 'your-app-id',
      token: 'your-user-token',
    );
    _feed = _client.flatFeed('timeline', 'user-id');
  }

  Future<List<Activity>> getLineFeed() async {
    final response = await _feed.getActivities();
    return response.results;
  }

  Future<void> postMemory(String content) async {
    final activity = Activity(
      actor: 'user:user-id',
      verb: 'post',
      object: 'memory:$content',
    );
    await _feed.addActivity(activity);
    notifyListeners();
  }
}