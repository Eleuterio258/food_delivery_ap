import 'dart:async';
import 'dart:convert';
import 'package:food_delivery/app/core/exceptions/email_already_registered.dart';
import 'package:food_delivery/app/core/exceptions/user_notfound_exception.dart';
import 'package:food_delivery/app/core/helpers/jwt_helper.dart';
import 'package:food_delivery/app/entities/user.dart';
import 'package:food_delivery/app/repositories/user/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();
  @Route.post('/')
  Future<Response> login(Request request) async {
    final jsonRQ = jsonDecode(await request.readAsString());

    try {
      final user = await _userRepository.login(
        jsonRQ['email'],
        jsonRQ['password'],
      );

      //final userResult = await _userRepository.login(jsonRQ);
      // return Response.ok(
      //   user.toJson(),
      //   headers: {
      //     'content-type': 'application/json',
      //   },
      // );

      return Response.ok(
          jsonEncode({
            'token_type': 'Bearer',
            'access_token': JwtHelper.generateJWT(user.id!),
          }),
          headers: {'content-type': 'application/json'});
    } on UserNotfoundException catch (e, s) {
      print(e);
      print(s);
      return Response(403, headers: {
        'content-type': 'application/json',
      });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  @Route.post('/register')
  Future<Response> regiter(Request request) async {
    try {
      final userRest = User.fromJson(await request.readAsString());
      await _userRepository.save(userRest);
      return Response(
        200,
        body: jsonEncode({'message': 'usuario cadastrodo com sucesso'}),
        headers: {'content-type': 'application/json'},
      );
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(400,
          body: jsonEncode(
            {'error': 'E-mail já utilizado por outro usuário'},
          ),
          headers: {'content-type': 'application/json'});
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
