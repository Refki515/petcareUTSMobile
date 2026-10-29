import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/data/guide_repository.dart';
import 'package:petcare/model/care_guide.dart';

void main() {
  test(
    'JSON lokal berisi delapan panduan lengkap dan aset yang tersedia',
    () async {
      final text = await File('assets/data/guides.json').readAsString();
      final catalog = parseCatalog(text);
      expect(catalog.guides.length, 8);
      expect(catalog.guides.map((guide) => guide.id).toSet().length, 8);
      expect(
        catalog.guides.map((guide) => guide.petType).toSet(),
        catalog.petTypes.toSet(),
      );
      expect(catalog.featuredGuideId, 'anjing-jalan');
      for (final guide in catalog.guides) {
        expect(guide.materials, isNotEmpty);
        expect(guide.steps, isNotEmpty);
        expect(File(guide.imagePath).existsSync(), isTrue);
        expect(guide.note, contains('dokter hewan'));
      }
      expect(() => catalog.guides.clear(), throwsUnsupportedError);
    },
  );

  test(
    'Model membaca JSON, nilai bawaan, dan list yang tidak dapat diubah',
    () {
      final guide = CareGuide.fromJson({
        'id': 'contoh',
        'petType': 'Kucing',
        'category': 'Kebersihan',
        'title': 'Contoh',
        'summary': 'Ringkasan',
        'imagePath': 'assets/images/cat.jpg',
        'materials': ['Sikat'],
        'steps': ['Sikat perlahan'],
        'note': 'Catatan',
      });
      expect(guide.readingMinutes, 4);
      expect(() => guide.steps.add('Ubah'), throwsUnsupportedError);
    },
  );

  test(
    'JSON rusak, ID duplikat, dan referensi unggulan tidak sah ditolak',
    () async {
      expect(() => parseCatalog('{'), throwsFormatException);
      final json =
          jsonDecode(await File('assets/data/guides.json').readAsString())
              as Map<String, dynamic>;
      json['featuredGuideId'] = 'tidak-ada';
      expect(() => GuideCatalog.fromJson(json), throwsFormatException);
      json['featuredGuideId'] = 'anjing-jalan';
      (json['guides'] as List).add((json['guides'] as List).first);
      expect(() => GuideCatalog.fromJson(json), throwsFormatException);
    },
  );
}
