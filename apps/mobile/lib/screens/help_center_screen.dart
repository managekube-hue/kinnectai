import 'package:flutter/material.dart';
import '../theme/colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<HelpTopic> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadHelpTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadHelpTopics() {
    setState(() {
      _topics.addAll([
        HelpTopic(
          category: 'Getting Started',
          icon: Icons.rocket_launch,
          articles: [
            HelpArticle('How to create your first Memory', 'Learn the basics of recording and sharing'),
            HelpArticle('Understanding Kin Score', 'What the percentage means'),
            HelpArticle('Building your Tree', 'Import GEDCOM or add manually'),
          ],
        ),
        HelpTopic(
          category: 'The Line',
          icon: Icons.view_timeline,
          articles: [
            HelpArticle('How The Line algorithm works', 'CR-based ranking explained'),
            HelpArticle('Discovery vs Kinnections', 'Understanding the tabs'),
            HelpArticle('Pulse, Comment, Rewind', 'Interaction features'),
          ],
        ),
        HelpTopic(
          category: 'Memory Box',
          icon: Icons.lock,
          articles: [
            HelpArticle('Creating a Memory Box', 'Sealed delivery system'),
            HelpArticle('Trigger types explained', 'Time, Milestone, Posthumous, Geofence'),
            HelpArticle('Steward designation', 'Appointing a Memory Box manager'),
          ],
        ),
        HelpTopic(
          category: 'Bloom',
          icon: Icons.auto_awesome,
          articles: [
            HelpArticle('How to create a Bloom', 'Animate photos with AI'),
            HelpArticle('Standard vs Premium', 'Quality and processing time'),
            HelpArticle('Voiceprint capture', 'Voice cloning for Blooms'),
          ],
        ),
        HelpTopic(
          category: 'Privacy & Safety',
          icon: Icons.shield,
          articles: [
            HelpArticle('Privacy controls', 'Public vs Private account'),
            HelpArticle('DNA data security', 'How we protect your data'),
            HelpArticle('Reporting content', 'Flag inappropriate Memories'),
          ],
        ),
        HelpTopic(
          category: 'Account',
          icon: Icons.person,
          articles: [
            HelpArticle('Password and Passkey', 'Authentication options'),
            HelpArticle('Download your data', 'GDPR export'),
            HelpArticle('Delete account', 'Permanent deletion process'),
          ],
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Help Center'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: KinnectColors.darkSurface,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: KinnectColors.white),
              decoration: InputDecoration(
                hintText: 'Search help articles',
                hintStyle: const TextStyle(color: KinnectColors.grey60),
                prefixIcon: const Icon(Icons.search, color: KinnectColors.grey60),
                filled: true,
                fillColor: KinnectColors.darkBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _topics.length,
              itemBuilder: (context, index) => _buildTopicCard(_topics[index]),
            ),
          ),
          _buildContactSupport(),
        ],
      ),
    );
  }

  Widget _buildTopicCard(HelpTopic topic) {
    return Card(
      color: KinnectColors.darkSurface,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(topic.icon, color: KinnectColors.amber),
        title: Text(
          topic.category,
          style: const TextStyle(color: KinnectColors.white, fontWeight: FontWeight.bold),
        ),
        iconColor: KinnectColors.amber,
        collapsedIconColor: KinnectColors.grey60,
        children: topic.articles.map((article) => ListTile(
          title: Text(article.title, style: const TextStyle(color: KinnectColors.white, fontSize: 14)),
          subtitle: Text(article.subtitle, style: const TextStyle(color: KinnectColors.grey60, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40, size: 20),
          onTap: () => _showArticle(article),
        )).toList(),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Still need help?',
            style: TextStyle(color: KinnectColors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our support team is here to assist you',
            style: TextStyle(color: KinnectColors.grey60, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _contactSupport('email'),
                  icon: const Icon(Icons.email),
                  label: const Text('Email'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KinnectColors.amber,
                    side: const BorderSide(color: KinnectColors.amber),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactSupport('chat'),
                  icon: const Icon(Icons.chat),
                  label: const Text('Live Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KinnectColors.amber,
                    foregroundColor: KinnectColors.darkBg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showArticle(HelpArticle article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.darkSurface,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        color: KinnectColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: KinnectColors.grey60),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article.subtitle,
                style: const TextStyle(color: KinnectColors.grey60, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: const [
                    Text(
                      'Article content would appear here...',
                      style: TextStyle(color: KinnectColors.white, fontSize: 14, height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Was this helpful?',
                    style: TextStyle(color: KinnectColors.grey60),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.thumb_up_outlined, color: KinnectColors.success),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.thumb_down_outlined, color: KinnectColors.error),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactSupport(String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $method support...'),
        backgroundColor: KinnectColors.success,
      ),
    );
  }
}

class HelpTopic {
  final String category;
  final IconData icon;
  final List<HelpArticle> articles;

  HelpTopic({
    required this.category,
    required this.icon,
    required this.articles,
  });
}

class HelpArticle {
  final String title;
  final String subtitle;

  HelpArticle(this.title, this.subtitle);
}
