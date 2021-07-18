// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Helpers:
import '../helpers/_helpers.dart';

// Utilities:
import '../utilities/_utilities.dart';

class FirebaseRealtimeDBHelper {
  // Gets the data by a uri, from a given authority and unencodedPath:
  Future<dynamic> getData({
    String protocol = 'parse',
    String authority,
    String unencodedPath = '',
    Map<String, dynamic> queryParameters = const {},
  }) async {
    Uri uri = _buildUri(protocol: protocol, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  // Posts the data by a uri, from a given authority and unencodedPath:
  Future<dynamic> postData({
    String protocol = 'parse',
    String authority,
    String unencodedPath = '',
    Map<String, dynamic> queryParameters = const {},
    Map<String, String> headers,
    Object body,
    Encoding encoding,
  }) async {
    print('Inside postData');
    Uri uri = _buildUri(protocol: protocol, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    print('uri = $uri');
    print('body = $body');
    Response response = await post(uri, headers: headers, body: body, encoding: encoding);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  // Deletes data on a uri, from a given authority and unencodedPath:
  Future<dynamic> deleteData({
    String protocol = 'parse',
    String authority,
    String unencodedPath = '',
    Map<String, dynamic> queryParameters = const {},
    Map<String, String> headers,
    Object body,
    Encoding encoding,
  }) async {
    Uri uri = _buildUri(protocol: protocol, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    print('Inside deleteData: uri = $uri');
    print('Inside deleteData: body = $body');
    Response response = await delete(uri, headers: headers, body: body, encoding: encoding);

    print('Inside deleteData: response = $response');
    print('Inside deleteData: response.body = ${response.body}');
    print('Inside deleteData: response.statusCode = ${response.statusCode}');

    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body);
    // } else {
    //   print(response.statusCode);
    // }

    return response.statusCode == 200;
  }

  Uri _buildUri({String protocol = 'parse', String authority, String unencodedPath = '', Map<String, dynamic> queryParameters = const {}}) {
    Uri uri;
    switch (protocol) {
      case 'parse':
        uri = Uri.parse('$authority$unencodedPath');
        break;
      case 'http':
        uri = Uri.http(authority, unencodedPath);
        break;
      case 'https':
        uri = Uri.https(authority, unencodedPath);
        break;
      default:
        uri = Uri.parse(authority);
        break;
    }
    return uri;
  }
}
