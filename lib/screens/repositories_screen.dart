import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/repository_model.dart';
import '../providers/repository_provider.dart';

class RepositoriesScreen
    extends ConsumerStatefulWidget {
  final String username;

  const RepositoriesScreen({
    super.key,
    required this.username,
  });

  @override
  ConsumerState<RepositoriesScreen> createState() =>
      _RepositoriesScreenState();
}

class _RepositoriesScreenState
    extends ConsumerState<RepositoriesScreen> {
  bool sortByStars = true;

  @override
  Widget build(BuildContext context) {
    final repositories = ref.watch(
      repositoriesProvider(widget.username),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.star),
                  label: Text('Stars'),
                ),
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.update),
                  label: Text('Updated'),
                ),
              ],
              selected: {sortByStars},
              onSelectionChanged: (value) {
                setState(() {
                  sortByStars = value.first;
                });
              },
            ),
          ),

          Expanded(
            child: repositories.when(
              loading: () {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              },

              error: (error, _) {
                return Center(
                  child: Text(
                    error.toString(),
                  ),
                );
              },

              data: (data) {
                final list =
                    List<RepositoryModel>.from(
                  data,
                );

                if (sortByStars) {
                  list.sort(
                    (a, b) => b.stars.compareTo(
                      a.stars,
                    ),
                  );
                } else {
                  list.sort(
                    (a, b) {
                      if (a.updatedAt == null) {
                        return 1;
                      }

                      if (b.updatedAt == null) {
                        return -1;
                      }

                      return b.updatedAt!
                          .compareTo(
                        a.updatedAt!,
                      );
                    },
                  );
                }

                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'No repositories found.',
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder:
                      (context, index) {
                    return RepositoryCard(
                      repository: list[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RepositoryCard extends StatelessWidget {
  final RepositoryModel repository;

  const RepositoryCard({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repository.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              repository.description ??
                  'No description',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text('${repository.stars}'),

                const SizedBox(width: 20),

                const Icon(
                  Icons.code,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  repository.language ?? 'Unknown',
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Updated: ${formatDate(repository.updatedAt)}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Unknown';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}