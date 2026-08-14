import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/screens/recent_searches.dart';
import '../providers/user_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  ConsumerState<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends ConsumerState<SearchScreen> {
  final TextEditingController controller =
      TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

void search() {
  final username = controller.text.trim();

  if (username.isEmpty) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a GitHub username',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    return;
  }

  FocusScope.of(context).unfocus();

  ref
      .read(userProvider.notifier)
      .searchUser(username);
}

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Explorer',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              textInputAction:
                  TextInputAction.search,
                  onChanged: (value) {
    if (value.trim().isEmpty) {
      ref.read(userProvider.notifier).clearUser();
    }
  },
              onSubmitted: (_) => search(),
              decoration: InputDecoration(
                hintText: 'GitHub username',
                prefixIcon:
                    const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: search,
                  icon: const Icon(
                    Icons.arrow_forward,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: userState.when(
                loading: () {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                },

                error: (error, _) {
                  return Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          error.toString(),
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: search,
                          child:
                              const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                },

                data: (user) {
                  if (user == null) {
                    return const RecentSearches();
                  }

                  return ProfileCard(
                    username: user.username,
                    name: user.name,
                    bio: user.bio,
                    avatarUrl: user.avatarUrl,
                    followers: user.followers,
                    following: user.following,
                    repositories:
                        user.publicRepos,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}