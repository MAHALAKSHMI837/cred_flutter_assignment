abstract class ApiError implements Exception {
  final String message;
  final int? statusCode;
  
  const ApiError(this.message, [this.statusCode]);
  
  @override
  String toString() => message;
}

class NetworkError extends ApiError {
  const NetworkError() : super('No internet connection');
}

class ServerError extends ApiError {
  const ServerError(int statusCode) : super('Server error', statusCode);
}

class ParseError extends ApiError {
  const ParseError() : super('Failed to parse response');
}

class NotFoundError extends ApiError {
  const NotFoundError() : super('Resource not found', 404);
}

class UnauthorizedError extends ApiError {
  const UnauthorizedError() : super('Unauthorized access', 401);
}