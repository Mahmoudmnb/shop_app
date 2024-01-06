import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:shop_app/core/constant.dart';

import '../../../injection.dart';
import '../featurs/products_view/models/review_model.dart';
import 'data_source.dart';

class RemoteDataSource {
  Future<bool> uploadImage() async {
    // final client = Client()
    //     .setEndpoint('https://cloud.appwrite.io/v1')
    //     .setProject('[PROJECT_ID]');

    // final storage = Storage(client);

    // final file = await storage.createFile(
    //   bucketId: '[BUCKET_ID]',
    //   fileId: ID.unique(),
    //   file: InputFile.fromPath(
    //       path: './path-to-files/image.jpg', filename: 'image.jpg'),
    // );
    return true;
  }

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
      List<Map<String, dynamic>> orderProducts,
      double totalPrice,
      String deliveryAddress,
      String shoppingMethod,
      String latitude,
      String longitude) async {
    List<int> ordersIds = [];
    List<String> colors = [];
    List<String> sizes = [];
    List<int> amounts = [];
    String colorsForLocal = '';
    String sizesForLocal = '';
    String amountsForLocal = '';
    for (var element in orderProducts) {
      ordersIds.add(element['order_id']);
      colors.add(element['color']);
      sizes.add(element['size']);
      amounts.add(element['quantity']);
      colorsForLocal += element['color'] + '|';
      sizesForLocal += element['size'] + '|';
      amountsForLocal += '${element['quantity']}|';
    }
    colorsForLocal = colorsForLocal.substring(0, colorsForLocal.length - 1);
    sizesForLocal = sizesForLocal.substring(0, sizesForLocal.length - 1);
    amountsForLocal = amountsForLocal.substring(0, amountsForLocal.length - 1);
    log(colorsForLocal);
    log(sizesForLocal);
    log(amountsForLocal);
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject(Constant.appWriteProjectId);
    Databases db = Databases(client);
    int id = 0;
    List<Document> data = [];
    try {
      var result = await db.listDocuments(
        databaseId: '65590bfc54fa42e08afd',
        collectionId: "65590c089231c74891b3",
      );
      data = result.documents;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    id = data.length;
    String orderDate = Constant.dateToString(DateTime.now());
    try {
      await db.createDocument(
          databaseId: '65590bfc54fa42e08afd',
          collectionId: '65590c089231c74891b3',
          documentId: ID.unique(),
          data: {
            'email': Constant.currentUser!.email,
            'orders_ids': ordersIds,
            'total_price': totalPrice,
            'delivery_address': deliveryAddress,
            'shopping_method': shoppingMethod,
            'created_at': orderDate,
            'id': ++id,
            'latitude': latitude,
            'longitude': longitude,
            'colors': colors,
            'sizes': sizes,
            'amounts': amounts,
          }).then((value) {
        sl.get<DataSource>().addOrder(
            ordersIds,
            totalPrice,
            orderDate,
            deliveryAddress,
            shoppingMethod,
            id,
            value.$id,
            longitude,
            latitude,
            colorsForLocal,
            sizesForLocal,
            amountsForLocal);
        log(value.data.toString());
        log('created');
      });
    } on AppwriteException catch (e) {
      if (e.message != null &&
          e.message!
              .contains('Document with the requested ID already exists')) {
        addOrderToCloudDataBase(orderProducts, totalPrice, deliveryAddress,
            shoppingMethod, latitude, longitude);
      }
      log(e.message.toString());
    }
  }

  Future<void> getOrdersFromCloud() async {
    List<Document> orders = [];
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Constant.appWriteProjectId);
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '65590bfc54fa42e08afd',
        collectionId: "65590c089231c74891b3",
        queries: [Query.equal('email', Constant.currentUser!.email)],
      );
      orders = result.documents;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    sl.get<DataSource>().insertDataInOrderTableFromCloud(orders);
  }

  Future<void> getReviewsFromCloud() async {
    List<Document> orders = [];
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Constant.appWriteProjectId);
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '65585f55e896c3e87515',
        collectionId: "65966b22308a7832fddc",
      );
      orders = result.documents;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    sl.get<DataSource>().insertDataInReviewTableFromCloud(orders);
  }

  Future<void> addReviewToCloud(ReviewModel reviewModel) async {
    Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject(Constant.appWriteProjectId);
    Databases db = Databases(client);
    Map<String, dynamic> data = {};
    if (reviewModel.userImage == null) {
      data = {
        'description': reviewModel.description,
        'stars': reviewModel.stars,
        'date': reviewModel.date,
        'userName': reviewModel.userName,
        'productId': reviewModel.productId,
        'email': reviewModel.email
      };
    } else {
      data = {
        'description': reviewModel.description,
        'stars': reviewModel.stars,
        'date': reviewModel.date,
        'userName': reviewModel.userName,
        'userImage': reviewModel.userImage,
        'productId': reviewModel.productId,
        'email': reviewModel.email
      };
    }
    try {
      db.createDocument(
          databaseId: '65585f55e896c3e87515',
          collectionId: '65966b22308a7832fddc',
          documentId: ID.unique(),
          data: data);
      log('done');
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
  }
}
