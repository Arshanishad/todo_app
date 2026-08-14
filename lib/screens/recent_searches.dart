import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/user_provider.dart';
import 'package:todo/screens/repositories_screen.dart';

class RecentSearches extends ConsumerWidget {
  const RecentSearches({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent =
        ref.watch(recentSearchesProvider);

    return recent.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, _) {
        return const Center(
          child: Text(
            'Unable to load recent searches.',
          ),
        );
      },
      data: (searches) {
        if (searches.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_search,
                  size: 70,
                ),
                SizedBox(height: 15),
                Text(
                  'Search for a GitHub profile',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...searches.map(
              (username) {
                return Card(
                  child: ListTile(
                    leading:
                        const Icon(Icons.history),
                    title: Text(username),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    onTap: () {
                      ref
                          .read(
                            userProvider
                                .notifier,
                          )
                          .searchUser(
                            username,
                          );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}


class ProfileCard extends StatelessWidget {
  final String username;
  final String? name;
  final String? bio;
  final String avatarUrl;
  final int followers;
  final int following;
  final int repositories;

  const ProfileCard({
    super.key,
    required this.username,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.followers,
    required this.following,
    required this.repositories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          CircleAvatar(
            radius: 60,
            backgroundImage:
                NetworkImage(avatarUrl),
          ),

          const SizedBox(height: 15),

          Text(
            name?.isNotEmpty == true
                ? name!
                : username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            '@$username',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          if (bio?.isNotEmpty == true) ...[
            const SizedBox(height: 15),
            Text(
              bio!,
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 25),

          Row(
            children: [
              StatCard(
                title: 'Followers',
                value: followers,
              ),
              StatCard(
                title: 'Following',
                value: following,
              ),
              StatCard(
                title: 'Repos',
                value: repositories,
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RepositoriesScreen(
                      username: username,
                    ),
                  ),
                );
              },
              child: const Text(
                'View Repositories',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final int value;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}