import 'package:fluttertestweek10/data/response/status.dart';

class ApiResponse<T> {
  //Menyimpan status permintaan
  Status? status;
  //Data hasil ketika perminataan berhasil
  T? data;
  //Pesan penjelasan ataua error
  String? message;

  //Konstruktor fleksibel (dapat diisi manual)
  ApiResponse(this.status, this.data, this.message);

  //Menandai permintaan belum dimulai
  ApiResponse.notStarted() : status = Status.notStarted;
  //Menandai sedan memuat/proses
  ApiResponse.loading() : status = Status.loading;
  //Menandai selesai sukses dengan data
  ApiResponse.completed(this.data) : status = Status.completed;
  //Menandai terjadi error dengan pesan
  ApiResponse.error(this.message) : status = Status.error;

  //Untuk debug isi respons
  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
