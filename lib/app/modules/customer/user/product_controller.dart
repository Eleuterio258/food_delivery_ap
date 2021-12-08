import 'dart:async';
import 'dart:convert';
import 'package:food_delivery/app/repositories/product/product_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'product_controller.g.dart';

class ProductController {
  final _productRepository = ProductRepository();
  @Route.get('/products')
  Future<Response> find(Request request) async {
    final repository = await _productRepository.findAll();
    final repositoryResponse = repository.map((e) =>
        <String, dynamic>{'id': e.id, 'name': e.name, 'type': e.description});
    return Response.ok(jsonEncode(jsonEncode(repositoryResponse)));
  }

  Router get router => _$ProductControllerRouter(this);
}
