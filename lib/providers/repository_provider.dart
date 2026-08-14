import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/repository_model.dart';
import 'user_provider.dart';

final repositoriesProvider =
    FutureProvider.family<
        List<RepositoryModel>,
        String>((ref, username) async {
  final service =
      ref.read(profileServiceProvider);

  return service.fetchRepositories(
    username,
  );
});