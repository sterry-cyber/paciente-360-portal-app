import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/app_constants.dart';

class ApiService {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Agregar token de autenticación
          final token = await _secureStorage.read(key: AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Manejar errores de autenticación
          if (error.response?.statusCode == 401) {
            // Intentar refrescar token
            final refreshToken = await _secureStorage.read(key: AppConstants.refreshTokenKey);
            if (refreshToken != null) {
              try {
                final response = await _dio.post('/auth/token/refresh/', data: {
                  'refresh': refreshToken,
                });
                
                if (response.data['access'] != null) {
                  final newToken = response.data['access'];
                  await _secureStorage.write(key: AppConstants.tokenKey, value: newToken);
                  
                  // Reintentar la petición original
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newToken';
                  final retryResponse = await _dio.fetch(options);
                  handler.resolve(retryResponse);
                  return;
                }
              } catch (e) {
                // Si falla el refresh, limpiar tokens
                await _secureStorage.delete(key: AppConstants.tokenKey);
                await _secureStorage.delete(key: AppConstants.refreshTokenKey);
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> uploadFile(String path, String filePath, String fieldName) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post(path, data: formData);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Error de conexión. Verifica tu internet.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) {
            return data['detail'];
          } else if (data.containsKey('message')) {
            return data['message'];
          } else if (data.containsKey('error')) {
            return data['error'];
          }
        }
        
        switch (statusCode) {
          case 400:
            return 'Solicitud inválida';
          case 401:
            return 'No autorizado';
          case 403:
            return 'Acceso denegado';
          case 404:
            return 'Recurso no encontrado';
          case 422:
            return 'Datos inválidos';
          case 500:
            return 'Error del servidor';
          default:
            return 'Error inesperado ($statusCode)';
        }
      case DioExceptionType.cancel:
        return 'Operación cancelada';
      case DioExceptionType.unknown:
        return 'Error de conexión. Verifica tu internet.';
      default:
        return 'Error inesperado';
    }
  }
}
