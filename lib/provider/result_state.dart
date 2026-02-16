// Base class buat represent semua kemungkinan state (loading, success, error)
sealed class ResultState {}

// State ini dipakai saat data masih dalam proses loading
class Loading extends ResultState {}

// State ini dipakai kalau data berhasil didapat dari API
class HasData<T> extends ResultState {
  // Variabel buat nyimpen data hasil fetch
  final T data;

  // Constructor untuk set data yang diterima
  HasData(this.data);
}

// State ini dipakai kalau terjadi error saat fetch data
class Error extends ResultState {
  // Variabel buat nyimpen pesan error
  final String message;

  // Constructor untuk set pesan error
  Error(this.message);
}
