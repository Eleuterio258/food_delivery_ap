import 'package:food_delivery/app/core/database/database.dart';
import 'package:food_delivery/app/entities/product.dart';
import 'package:mysql1/mysql1.dart';

class ProductRepository {
  Future<List<Product>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await Database().openConnection();
      final result = await conn.query('select * from products');
      final userData = result.fields;

      print(userData);
    } on MySqlException catch (e, s) {
      print('Erro ao buscar as categorias do fornecedor $e, $s');
      throw Exception();
    } finally {
      await conn?.close();
    }

    return <Product>[];
  }
}
