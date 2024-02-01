import 'package:dio/dio.dart';
import 'package:lab_core/src/constants/local_storage_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


//interceptador para autenticação de token com dio
final class AuthInteceptor extends Interceptor {

  //sobrescreve o método onRequest para adicionar o token de autenticação
  @override
  Future <void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    //desestrutra as opções de o interceptador do dio para extrair os headers e o extra
    final RequestOptions(:headers, :extra) = options;

    //chave do header de autenticação
    const authHeaderKey = 'Authorization';
    
    //remove o header de autenticação ja existente
    headers.remove(authHeaderKey);

    //adiciona o header de autenticação se o extra for verdadeiro
    if (extra case {'DIO_AUTH_KEY': true}) {
      final sp = await SharedPreferences.getInstance();
      headers.addAll({
        authHeaderKey: '${sp.getString(LocalStorageConstants.accesstoken)}'
      });
    }
    //chama o método onRequest do super para continuar a requisição
    super.onRequest(options, handler);
  }
}