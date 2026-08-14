import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/repository_cubit.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../repository/user_repository.dart';
import 'repositories_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller =
      TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _search() {
    context.read<UserCubit>().searchUser(
          controller.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Profile Explorer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Enter GitHub username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _search,
                  icon: const Icon(Icons.arrow_forward),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserInitial) {
                    return _buildInitial();
                  }

                  if (state is UserLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is UserError) {
                    return _buildError(state.message);
                  }

                  if (state is UserSuccess) {
                    return _buildUser(state);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitial() {
    return FutureBuilder<List<String>>(
      future: context.read<UserCubit>().getRecentSearches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Search for a GitHub profile',
            ),
          );
        }

        final searches = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...searches.map(
              (username) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(username),
                onTap: () {
                  controller.text = username;

                  context
                      .read<UserCubit>()
                      .searchUser(username);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _search,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildUser(UserSuccess state) {
    final user = state.user;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              user.avatarUrl,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            user.name ?? user.username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            '@${user.username}',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          if (user.bio != null && user.bio!.isNotEmpty)
            Text(
              user.bio!,
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                title: 'Followers',
                value: user.followers,
              ),
              _StatItem(
                title: 'Following',
                value: user.following,
              ),
              _StatItem(
                title: 'Repos',
                value: user.publicRepos,
              ),
            ],
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => RepositoryCubit(
                        UserRepository(),
                      )..loadRepositories(
                          user.username,
                        ),
                      child: RepositoriesScreen(
                        username: user.username,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.folder),
              label: const Text('View Repositories'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final int value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title),
      ],
    );
  }
}