import 'package:food_delivery/app/core/database/database.dart';
import 'package:food_delivery/app/core/exceptions/email_already_registered.dart';
import 'package:food_delivery/app/core/exceptions/user_notfound_exception.dart';
import 'package:food_delivery/app/core/helpers/cripty_helper.dart';
import 'package:food_delivery/app/entities/user.dart';
import 'package:mysql1/mysql1.dart';

class UserRepository {
  Future<User> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.query(''' 
          select * from users
          where email = ?
          and password = ?
         ''', [
        email,
        CriptyHelper.generatedSha256Hash(password),
      ]);

      if (result.isEmpty) {
        throw UserNotfoundException();
      }

      final userData = result.first;

      return User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        password: userData['password'],
        phone: userData['phone'],
      );
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Erro ao realizar login');
    } finally {
      await conn?.close();
    }
  }

  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      final isUserRegiser = await conn
          .query('select * from users where email = ? ', [user.email]);

      if (isUserRegiser.isEmpty) {
        await conn.query(''' 
          insert into users
          values(?,?,?,?,?)
        ''', [
          null,
          user.name,
          user.email,
          CriptyHelper.generatedSha256Hash(user.password),
          user.phone
        ]);
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
