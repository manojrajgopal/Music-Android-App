import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cadence/core/errors/app_exception.dart';
import 'package:cadence/data/services/url_import_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Serves canned responses keyed by URL, so no real network is used.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.routes);

  final Map<String, ResponseBody Function()> routes;
  final requested = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requested.add(options.uri.toString());
    final route = routes[options.uri.toString()];
    return route == null ? ResponseBody.fromString('', 404) : route();
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody bytes(List<int> data, {String type = 'audio/mpeg', int status = 200}) => ResponseBody.fromBytes(
  data,
  status,
  headers: {
    Headers.contentTypeHeader: [type],
    Headers.contentLengthHeader: ['${data.length}'],
  },
);

ResponseBody redirect(String to) => ResponseBody.fromString(
  '',
  302,
  headers: {
    'location': [to],
  },
);

void main() {
  group('link classification', () {
    test('requires https and a host', () {
      expect(checkLink('http://example.com/a.mp3').kind, LinkKind.invalid);
      expect(checkLink('ftp://example.com/a.mp3').kind, LinkKind.invalid);
      expect(checkLink('not a url').kind, LinkKind.invalid);
      expect(checkLink('https://user:pw@example.com/a.mp3').kind, LinkKind.invalid);
      expect(checkLink('https://example.com/a.mp3').kind, LinkKind.directAudio);
    });

    test('recognises YouTube links in all common forms', () {
      for (final url in [
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'https://youtu.be/dQw4w9WgXcQ',
        'https://m.youtube.com/watch?v=dQw4w9WgXcQ&t=10',
        'https://music.youtube.com/watch?v=dQw4w9WgXcQ',
        'https://www.youtube.com/shorts/dQw4w9WgXcQ',
        'http://youtube.com/embed/dQw4w9WgXcQ',
      ]) {
        final check = checkLink(url);
        expect(check.kind, LinkKind.youtube, reason: url);
        expect(check.youtubeVideoId, 'dQw4w9WgXcQ', reason: url);
      }
      expect(checkLink('https://www.youtube.com/@channel').kind, LinkKind.youtube);
      expect(checkLink('https://www.youtube.com/@channel').youtubeVideoId, isNull);
    });

    test('refuses streaming services', () {
      expect(checkLink('https://open.spotify.com/track/123').kind, LinkKind.streamingService);
      expect(checkLink('https://soundcloud.com/a/b').kind, LinkKind.streamingService);
    });

    test('identifies private and local addresses', () {
      for (final ip in [
        '127.0.0.1',
        '10.1.2.3',
        '172.16.0.1',
        '192.168.1.1',
        '169.254.1.1',
        '100.64.0.1',
        '0.0.0.0',
        '::1',
        'fd00::1',
        '::ffff:192.168.0.1',
      ]) {
        expect(isPrivateAddress(InternetAddress(ip)), isTrue, reason: ip);
      }
      for (final ip in ['93.184.216.34', '8.8.8.8', '2606:4700::1111']) {
        expect(isPrivateAddress(InternetAddress(ip)), isFalse, reason: ip);
      }
    });
  });

  group('download validation', () {
    final mp3 = [...'ID3'.codeUnits, 4, 0, 0, 0, 0, 0, 0, ...List.filled(500, 1)];
    Future<List<InternetAddress>> publicResolver(String host) async => [
      InternetAddress(host == 'internal.example' ? '10.0.0.5' : '93.184.216.34'),
    ];

    UrlImportService service(Map<String, ResponseBody Function()> routes) {
      final dio = Dio()..httpClientAdapter = FakeAdapter(routes);
      return UrlImportService(tempPaths(), dio: dio, resolver: publicResolver);
    }

    test('accepts real audio and downloads it atomically', () async {
      final s = service({'https://cdn.example/song.mp3': () => bytes(mp3)});
      final info = await s.inspect(Uri.parse('https://cdn.example/song.mp3'));
      expect(info.fileName, 'song.mp3');
      final file = await s.download(info);
      expect(file.existsSync(), isTrue);
      expect(file.lengthSync(), mp3.length);
      expect(file.parent.listSync().where((f) => f.path.endsWith('.part')), isEmpty);
    });

    test('a .mp3 URL serving HTML is rejected', () async {
      final s = service({'https://cdn.example/song.mp3': () => bytes(utf8.encode('<html></html>'), type: 'text/html')});
      expect(
        s.inspect(Uri.parse('https://cdn.example/song.mp3')),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'not_audio')),
      );
    });

    test('octet-stream that is not audio is rejected by sniffing', () async {
      final s = service({
        'https://cdn.example/x.mp3': () => bytes(List.filled(100, 0), type: 'application/octet-stream'),
      });
      expect(s.inspect(Uri.parse('https://cdn.example/x.mp3')), throwsA(isA<AppException>()));
    });

    test('redirects to private networks, http or streaming services are rejected', () async {
      final s = service({
        'https://cdn.example/a.mp3': () => redirect('https://internal.example/a.mp3'),
        'https://cdn.example/b.mp3': () => redirect('http://cdn.example/b.mp3'),
        'https://cdn.example/c.mp3': () => redirect('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
      });
      await expectLater(
        s.inspect(Uri.parse('https://cdn.example/a.mp3')),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'private')),
      );
      await expectLater(
        s.inspect(Uri.parse('https://cdn.example/b.mp3')),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'insecure')),
      );
      await expectLater(
        s.inspect(Uri.parse('https://cdn.example/c.mp3')),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'streaming')),
      );
    });

    test('literal private IPs are rejected without any request', () async {
      final adapter = FakeAdapter({});
      final s = UrlImportService(tempPaths(), dio: Dio()..httpClientAdapter = adapter, resolver: publicResolver);
      await expectLater(s.inspect(Uri.parse('https://192.168.0.10/a.mp3')), throwsA(isA<AppException>()));
      expect(adapter.requested, isEmpty);
    });

    test('authorization failures and redirect loops are reported', () async {
      final s = service({
        'https://cdn.example/private.mp3': () => ResponseBody.fromString('', 403),
        'https://cdn.example/loop.mp3': () => redirect('https://cdn.example/loop.mp3'),
      });
      await expectLater(
        s.inspect(Uri.parse('https://cdn.example/private.mp3')),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'forbidden')),
      );
      await expectLater(
        s.inspect(Uri.parse('https://cdn.example/loop.mp3')),
        throwsA(isA<AppException>().having((e) => e.code, 'code', 'redirects')),
      );
    });

    test('unsafe file names are sanitized', () async {
      final s = service({
        'https://cdn.example/dl': () => ResponseBody.fromBytes(
          mp3,
          200,
          headers: {
            Headers.contentTypeHeader: ['audio/mpeg'],
            'content-disposition': ['attachment; filename="../../etc/passwd.mp3"'],
          },
        ),
      });
      final info = await s.inspect(Uri.parse('https://cdn.example/dl'));
      expect(info.fileName, 'passwd.mp3');
    });
  });
}
