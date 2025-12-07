//Kelas abstrak sebagai kontrak layer jaringan yang kemudian diimplementasi oleh kelas turunan

abstract class BaseApiServices {
  /// Melakukan request GET ke endpoint dan mengembalikan respon dinamis
  /// Berjalan secara asinkron dan tipe dataya bisa apapun (json map, list, dll)
  Future<dynamic> getApiResponse(String endpoint);
  Future<dynamic> getApiResponseWithQuery(String endpoint, Map<String, dynamic> query);
  /// Melakukan request POST ke endpoint dengan data tertentu dan mengembalikan respon dinamis
  Future<dynamic> postApiResponse(String url, dynamic data);
}
