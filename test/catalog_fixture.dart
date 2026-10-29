import 'dart:io';

import 'package:petcare/data/guide_repository.dart';

class FileGuideRepository extends GuideRepository {
  const FileGuideRepository();

  @override
  Future<GuideCatalog> load() async {
    // Use the real JSON fixture without a platform asset channel in unit tests.
    final text = await File('assets/data/guides.json').readAsString();
    return parseCatalog(text);
  }
}
