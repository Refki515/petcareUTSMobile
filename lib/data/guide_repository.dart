import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/care_guide.dart';

class GuideCatalog {
  GuideCatalog.fromJson(Map<String, dynamic> json)
    : petTypes = List<String>.unmodifiable(json['petTypes'] as List),
      categories = List<String>.unmodifiable(json['categories'] as List),
      featuredGuideId = json['featuredGuideId'] as String,
      popularGuideIds = List<String>.unmodifiable(
        json['popularGuideIds'] as List,
      ),
      guides = List<CareGuide>.unmodifiable(
        (json['guides'] as List).map(
          (item) => CareGuide.fromJson(item as Map<String, dynamic>),
        ),
      ) {
    final ids = guides.map((guide) => guide.id).toSet();
    if (guides.isEmpty ||
        ids.length != guides.length ||
        !ids.contains(featuredGuideId) ||
        !popularGuideIds.every(ids.contains) ||
        !categories.contains('Semua') ||
        guides.any(
          (guide) =>
              !petTypes.contains(guide.petType) ||
              !categories.contains(guide.category),
        )) {
      throw const FormatException('Isi katalog panduan tidak valid.');
    }
  }

  final List<String> petTypes;
  final List<String> categories;
  final String featuredGuideId;
  final List<String> popularGuideIds;
  final List<CareGuide> guides;
}

class GuideRepository {
  const GuideRepository();

  Future<GuideCatalog> load() async {
    final jsonText = await rootBundle.loadString('assets/data/guides.json');
    return parseCatalog(jsonText);
  }
}

GuideCatalog parseCatalog(String jsonText) {
  final json = jsonDecode(jsonText) as Map<String, dynamic>;
  return GuideCatalog.fromJson(json);
}
