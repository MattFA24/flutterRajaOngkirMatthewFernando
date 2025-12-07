/// Kelas dasar untuk exception handling, menyimpan pesan dan prefix
library;

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_message$_prefix';
  }
}

//Dilempar saat gagal mengambil data dari server (timeout, format salah. dll)

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Invalid Request");
}

//Dilempar saat tidak ada koneksi internet terdeteksi
class NoInternetException extends AppException {
  NoInternetException([String? message])
    : super(message, "No Internet Connection");
}

// Dilempar saat permintaan tidak valid (400 / data input salah).
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid Request");
}

//Dilempar saat resource/endpoint tidak ditemukan (404)
class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, "Not Found");
}

//Dilempar saat terjadi kesalahan internal server (500+)
class ServerException extends AppException {
  ServerException([String? message]) : super(message, "Internal Server Error");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
    : super(message, "Unauthorised Request");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input");
}
