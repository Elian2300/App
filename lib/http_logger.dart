import 'package:http/http.dart' as base_http;

class _LoggingClient extends base_http.BaseClient {
  final base_http.Client _inner = base_http.Client();

  @override
  Future<base_http.StreamedResponse> send(base_http.BaseRequest request) async {
    print('\n[FRONTEND] Petición \${request.method} -> \${request.url}');
    if (request is base_http.Request && request.body.isNotEmpty) {
      print('[FRONTEND] Payload enviado: \${request.body}');
    }
    final response = await _inner.send(request);
    print('[FRONTEND] Respuesta de \${request.url} | Código Interno: \${response.statusCode}');
    return response;
  }
}

final http = _LoggingClient();
