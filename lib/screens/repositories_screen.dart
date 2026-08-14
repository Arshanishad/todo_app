import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/repository_cubit.dart';
import '../cubit/repository_state.dart';

class RepositoriesScreen extends StatefulWidget {
  final String username;

  const RepositoriesScreen({
    super.key,
    required this.username,
  });

  @override
  State<RepositoriesScreen> createState() =>
      _RepositoriesScreenState();
}

class _RepositoriesScreenState
    extends State<RepositoriesScreen> {
  bool sortByStars = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username} Repositories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Stars'),
                  icon: Icon(Icons.star),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Recently Updated'),
                  icon: Icon(Icons.update),
                ),
              ],
              selected: {sortByStars},
              onSelectionChanged: (selection) {
                final selected = selection.first;

                setState(() {
                  sortByStars = selected;
                });

                if (selected) {
                  context
                      .read<RepositoryCubit>()
                      .sortByStars();
                } else {
                  context
                      .read<RepositoryCubit>()
                      .sortByRecentlyUpdated();
                }
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<RepositoryCubit, RepositoryState>(
              builder: (context, state) {
                if (state is RepositoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is RepositoryError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is RepositorySuccess) {
                  if (state.repositories.isEmpty) {
                    return const Center(
                      child: Text('No repositories found'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.repositories.length,
                    itemBuilder: (context, index) {
                      final repo =
                          state.repositories[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                repo.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              if (repo.description != null)
                                Text(
                                  repo.description!,
                                  maxLines: 3,
                                  overflow:
                                      TextOverflow.ellipsis,
                                ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${repo.stars}'),

                                  const SizedBox(width: 20),

                                  const Icon(
                                    Icons.code,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    repo.language ??
                                        'Unknown',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Updated: ${_formatDate(repo.updatedAt)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('No repositories loaded'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Unknown';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}