import 'dart:async';
import 'dart:convert';
import 'package:fluttertestweek10/data/network/base_api_service.dart';
import 'package:fluttertestweek10/data/response/app_exception.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertestweek10/shared/shared.dart';
import 'dart:io';

//Implementjasi BasicApiService untuk menanganti request, GET, POST ke API Ongkir

class NetworkApiService implements BaseApiServices {
  //Melakukan GET request ke endpoint
  //Mengembalikan JSON ter-decode atau melempar exception jika terjadi kesalahn

  @override
  Future<dynamic> getApiResponse(String endpoint) async {
    try {
      final uri = Uri.https(Const.baseUrl, Const.subUrl + endpoint);
      //Log request GET untuk debug: URL + Header
      _logRequest('GET', uri, Const.apiKey);
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        },
      );
      return _returnResponse(response);

      //Penanganan response (status code dan decode JSON + pemetaan error)
    } on SocketException {
      //Tidak adak koneksi jaringan internet
      throw NoInternetException('No Internet connection!');
    } on TimeoutException {
      //Waktu request melewati batas timeout
      throw FetchDataException('Network request time out');
    } catch (e) {
      // Error tak terduga saat runtime
      throw FetchDataException('Unexpected error: $e');
    }
  }

  @override
  Future<dynamic> postApiResponse(String endpoint, dynamic data) async {
    try {
      final uri = Uri.https(Const.baseUrl, Const.subUrl + endpoint);

      //Log request POST untuk payload body.
      _logRequest('POST', uri, Const.apiKey, data);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'key': Const.apiKey,
        },
        body: data,
      );

      //Delegasi parsing respons dan pemetaan error
      return _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection!');
    } on TimeoutException {
      throw FetchDataException('Network request time out');
    } catch (e) {
      throw FetchDataException('Unexpected error: $e');
    }
  }

  /// Print debug metadata request (method, URL, header, body)
  void _logRequest(String method, Uri uri, String apiKey, [dynamic data]) {
    print('--- $method Request ---');
    //print ('API Key: {apiKey}');
    print('Fina URL ($method): $uri');
    if (data != null) {
      print('Data body: $data');
    }
    print('');
  }

  /// Print debug detail respons (status, content-type, body)
  void _logResponse(int statusCode, String? contentType, String body) {
    print('Status Code: $statusCode');
    print('Content-Type: ${contentType ?? '-'}');

    if (body.isEmpty) {
      print('Body: <empty>');
    } else {
      String formattedBody;
      try {
        final decoded = jsonDecode(body);
        const encoder = JsonEncoder.withIndent('  ');
        formattedBody = encoder.convert(decoded);
      } catch (_) {
        formattedBody = body;
      }
      const maxLen = 800;
      if (formattedBody.length > maxLen) {
        print(
          'Body (terpotong): ${formattedBody.substring(0, maxLen)}... [${formattedBody.length - maxLen} lebih karakter]',
        );
      } else {
        print('Body: $formattedBody');
      }
    }
    print("");
  }

  //Memetakan HTTP response menjadi JSON terdecode atau melempar exception bertipe
  dynamic _returnResponse(http.Response response) {
    //Log respons untuk debug
    _logResponse(
      response.statusCode,
      response.headers['content-type'],
      response.body,
    );

    switch (response.statusCode) {
      case 200:
        try {
          final decoded = jsonDecode(response.body);
          //decoded null (tidak terjadi di Dart, tetapi tetap dicek untuk keamanan).
          if (decoded == null) throw FetchDataException('Empty JSON');
          return decoded;
        } catch (_) {
          //JSON tidak bisa di-decode pada status sukses
          throw FetchDataException('Invalid JSON');
        }

      case 400:
        // Error dari sisi client: payload/parameter salah
        throw BadRequestException(response.body);

      case 404:
        //Resource atau endpoint tidak ditemukan
        throw NotFoundException('Not Found: ${response.body}');

      case 500:
        //Error dari sisi server
        throw ServerException('Server Error: ${response.body}');

      default:
        //Status lain yang tidak ditanbgani
        throw FetchDataException('Unexpected status: ${response.statusCode}');
    }
  }
}
