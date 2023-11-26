import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:shop_app/core/constant.dart';
import 'package:uuid/uuid.dart';

class RemoteDataSource {
  Future<List<Document>> getProducts() async {
    List<Document> data = [];
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Constant.appWriteProjectId);
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '65585f55e896c3e87515',
        collectionId: "655860259ae4b331bee6",
      );
      data = result.documents;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    return data;
  }

  Future<void> addOrderToCloudDataBase(
      List<Map<String, dynamic>> orderProducts, double totalPrice,String deliveryAddress) async {
    log(orderProducts.toString());
    List<int> ordersIds = [];
    for (var element in orderProducts) {
      ordersIds.add(element['id']);
    }
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject(Constant.appWriteProjectId);
    Databases db = Databases(client);
    String id = const Uuid().v1();
    db.createDocument(
        databaseId: '65590bfc54fa42e08afd',
        collectionId: '65590c089231c74891b3',
        documentId: id,
        data: {
          'email': Constant.currentUser!.email,
          'orders_ids': ordersIds,
          'total_price': totalPrice,
          'delivery_address':deliveryAddress
        }).then((value) {

      log('created');
    });
  }
}
