// Packages:
import '../_inner_packages.dart';
import '../_external_packages.dart';

// Helpers:

class FirebaseRealtimeDBHelper {
  // Gets the data by a uri, from a given authority and unencodedPath:
  Future<dynamic> getData({String flag = 'parse', String authority, String unencodedPath = '', Map<String, dynamic> queryParameters = const {}}) async {
    Uri uri = _buildUri(flag: flag, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  // Posts the data by a uri, from a given authority and unencodedPath:
  Future<dynamic> postData({String flag = 'parse', String authority, String unencodedPath = '', Map<String, dynamic> queryParameters = const {}}) async {
    Uri uri = _buildUri(flag: flag, authority: authority, unencodedPath: unencodedPath, queryParameters: queryParameters);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Uri _buildUri({String flag = 'parse', String authority, String unencodedPath = '', Map<String, dynamic> queryParameters = const {}}) {
    Uri uri;
    switch (flag) {
      case 'parse':
        uri = Uri.parse(authority);
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
