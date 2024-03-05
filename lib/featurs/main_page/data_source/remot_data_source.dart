import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/core/constant.dart';
import 'package:shop_app/featurs/auth/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../../injection.dart';
import '../featurs/products_view/models/review_model.dart';
import 'data_source.dart';

class RemoteDataSource {
  final client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject(Constant.appWriteProjectId);
  Future<List<Document>> getUpdatedReviews(String lastDate) async {
    Databases databases = Databases(client);
    var newReviews = await databases.listDocuments(
      databaseId: '65585f55e896c3e87515',
      collectionId: "65966b22308a7832fddc",
      queries: [
        Query.greaterThan('date', lastDate),
        Query.notEqual('email',
            Constant.currentUser != null ? Constant.currentUser!.email : ''),
      ],
    );
    log(newReviews.documents.toString());
    return newReviews.documents;
  }

  Future<Map<String, List<Document>>> getUpdatedProducts(
      String lastDate) async {
    List<Document> finalNewProducts = [];
    List<Document> finalUpdatedProducts = [];

    Databases databases = Databases(client);
    try {
      var newProducts = await databases.listDocuments(
        databaseId: '65585f55e896c3e87515',
        collectionId: "655860259ae4b331bee6",
        queries: [
          Query.greaterThan('date', lastDate),
        ],
      );
      finalNewProducts = newProducts.documents;

      var updatedProducts = await databases.listDocuments(
        databaseId: '65585f55e896c3e87515',
        collectionId: "655860259ae4b331bee6",
        queries: [
          Query.greaterThan('updatedAt', lastDate),
        ],
      );
      finalNewProducts = newProducts.documents;
      finalUpdatedProducts = updatedProducts.documents;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    return {
      'newProducts': finalNewProducts,
      'updatedProducts': finalUpdatedProducts
    };
  }

  Future<List<Document>> getRecommendedproductsFromCloud() async {
    List<Document> data = [];
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '65590bfc54fa42e08afd',
        collectionId: "65590c089231c74891b3",
      );
      data = result.documents;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    return data;
  }

  Future<Map<String, dynamic>> getPersonalData() async {
    Map<String, dynamic> data = {};
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '655da767bc3f1651db70',
        collectionId: "655da771422b6ac710aa",
        queries: [Query.equal('email', Constant.currentUser!.email)],
      );
      var temp = result.documents;
      data = temp[0].data;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    return data;
  }

  Future<void> uploadProfileSettings(
      String borderProducts, String cartProducts, String borders) async {
    Databases db = Databases(client);

    var data = await db.listDocuments(
      databaseId: '655da767bc3f1651db70',
      collectionId: '655da771422b6ac710aa',
      queries: [Query.equal('email', Constant.currentUser!.email)],
    );
    final userData = data.documents;
    try {
      db.updateDocument(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          documentId: userData[0].$id,
          data: {
            'borderProducts': borderProducts,
            'cartProducts': cartProducts,
            'borders': borders
          });
    } catch (e) {
      log(e.toString());
    }
    log('done');
  }

  Future<void> rateApp(String descrition, double rate) async {
    Databases db = Databases(client);
    log(rate.toString());
    try {
      await db.createDocument(
          databaseId: '65585f55e896c3e87515',
          collectionId: '65b8e5802cb873909d21',
          documentId: ID.unique(),
          data: {
            'description': descrition,
            'rate': rate,
            'email': Constant.currentUser!.email
          });
    } catch (e) {
      log(e.toString());
    }
    log('done');
  }

  Future<void> changePassword(String newPassword) async {
    Databases db = Databases(client);
    var data = await db.listDocuments(
      databaseId: '655da767bc3f1651db70',
      collectionId: '655da771422b6ac710aa',
      queries: [Query.equal('email', Constant.currentUser!.email)],
    );
    final userData = data.documents;
    var d = await db.updateDocument(
        databaseId: '655da767bc3f1651db70',
        collectionId: '655da771422b6ac710aa',
        documentId: userData[0].$id,
        data: {'password': newPassword});
    UserModel user = UserModel(
        email: Constant.currentUser!.email,
        name: Constant.currentUser!.name,
        password: newPassword);
    Constant.currentUser = user;
    sl.get<SharedPreferences>().setString('currentUser', user.toJson());
    log(d.data.toString());
  }

  Future<void> uploadImage(XFile image) async {
    final storage = Storage(client);
    String id = const Uuid().v1();
    if (Constant.currentUser!.imgUrl != null) {
      await storage.deleteFile(
          bucketId: '65969d60114e6c041d20',
          fileId: Constant.currentUser!.cloudImgUrl!);
    }
    await storage.createFile(
      onProgress: (value) {
        log('hi');
        log(value.progress.toString());
      },
      bucketId: '65969d60114e6c041d20',
      fileId: id,
      file: InputFile.fromPath(
          path: image.path, filename: '${Constant.currentUser!.email}.jpg'),
    );
    Constant.currentUser!.cloudImgUrl = id;
  }

  Future<List<Document>> getProducts() async {
    List<Document> data = [];
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
    log('done getting reviews');
  }

  Future<void> addReviewToCloud(ReviewModel reviewModel) async {
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
