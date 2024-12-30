abstract class DataState<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  const DataState({
    this.data,
    this.message,
    this.statusCode,
  });
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data, String message)
      : super(data: data, message: message);
}

class DataFailure<T> extends DataState<T> {
  DataFailure(String message, int statusCode)
      : super(message: message, statusCode: statusCode);
}
