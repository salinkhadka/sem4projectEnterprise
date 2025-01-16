import 'package:http/http.dart' as http;

class GoogleHttpClient extends http.BaseClient {
  Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleHttpClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  Future<http.Response> head(Object url, {Map<String, String>? headers}) => super.head(url as Uri, headers: headers?..addAll(_headers));
}
