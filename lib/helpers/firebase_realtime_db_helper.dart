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
    return response;
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
    Uri uri = _buildUri(protocol: protocol, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    Response response = await post(uri, headers: headers, body: body, encoding: encoding);
    return response;
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
    Response response = await delete(uri, headers: headers, body: body, encoding: encoding);
    return response;
  }

  // Deletes data on a uri, from a given authority and unencodedPath:
  Future<dynamic> updateData({
    String protocol = 'parse',
    String authority,
    String unencodedPath = '',
    Map<String, dynamic> queryParameters = const {},
    Map<String, String> headers,
    Object body,
    Encoding encoding,
  }) async {
    Uri uri = _buildUri(protocol: protocol, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    Response response = await put(uri, headers: headers, body: body, encoding: encoding);
    return response;
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
        uri = Uri.parse('$authority$unencodedPath');
        break;
    }
    return uri;
  }
}
