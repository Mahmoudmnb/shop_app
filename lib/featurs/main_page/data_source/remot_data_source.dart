import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant.dart';
import '../../../injection.dart';
import '../../auth/models/user_model.dart';
import '../featurs/check_out/models/address_model.dart';
import '../featurs/products_view/models/review_model.dart';
import 'data_source.dart';

class RemoteDataSource {
  final client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject(Constant.appWriteProjectId);
  Future<bool> updatePersonalData(UserModel user) async {
    Databases db = Databases(client);
    try {
      var users = await db.listDocuments(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa');
      String dId = '';
      for (var element in users.documents) {
        if (element.data['email'] == Constant.currentUser!.email) {
          dId = element.$id;
        }
      }
      await db.updateDocument(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          documentId: dId,
          data: {
            'name': user.name,
            'email': user.email,
            'phone_number': user.phoneNumber
          });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Either<Uint8List, bool>> downloadProfileImage(
      String cloudImageUrl) async {
    Storage storage = Storage(client);
    try {
      Uint8List profileImage = await storage.getFileDownload(
          bucketId: '65969d60114e6c041d20', fileId: cloudImageUrl);
      return Left(profileImage);
    } catch (e) {
      return Right(false);
    }
  }

  Future<Either<List<Document>, bool>> downloadLoactionsFromCloud() async {
    Databases databases = Databases(client);

    try {
      var locations = await databases.listDocuments(
        databaseId: '65585f55e896c3e87515',
        collectionId: "65ec7d873aa0c21fdeab",
        queries: [
          Query.equal('owner_email', Constant.currentUser!.email),
        ],
      );
      for (var element in locations.documents) {
        var d = element.data;
        await sl.get<DataSource>().addNewLocation(
            AddressModel(
                id: d['\$id'],
                fullName: d['fullName'],
                lastName: d['fullName'],
                phoneNumber: d['phoneNumber'],
                emailAddress: d['emailAddress'],
                addressName: d['addressName'],
                longitude: d['longitude_code'],
                latitude: d['latitude_code'],
                city: d['city'],
                country: d['country'],
                address: d['address']),
            'update');
      }
      log('done gettting locations');
      return Left(locations.documents);
    } catch (e) {
      log(e.toString());
      return Right(false);
    }
  }

  Future<bool> updateLocationInCloud(AddressModel address) async {
    Databases db = Databases(client);
    try {
      db.updateDocument(
          databaseId: '65585f55e896c3e87515',
          collectionId: '65ec7d873aa0c21fdeab',
          documentId: address.id!,
          data: {
            'fullName': address.fullName,
            'phoneNumber': address.phoneNumber,
            'emailAddress': address.emailAddress,
            'addressName': address.addressName,
            'longitude_code': address.longitude,
            'latitude_code': address.latitude,
            'city': address.city,
            'country': address.country,
            'address': address.address,
            'owner_email': Constant.currentUser!.email
          });
      log('done updating address data');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteLocationFromCloud(AddressModel address) async {
    Databases db = Databases(client);
    try {
      db.deleteDocument(
        databaseId: '65585f55e896c3e87515',
        collectionId: '65ec7d873aa0c21fdeab',
        documentId: address.id!,
      );
      log('done deleting location');
      return true;
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<String> addLoationToCloude(AddressModel address) async {
    Databases db = Databases(client);
    try {
      var d = await db.createDocument(
          databaseId: '65585f55e896c3e87515',
          collectionId: '65ec7d873aa0c21fdeab',
          documentId: ID.unique(),
          data: {
            'fullName': address.fullName,
            'phoneNumber': address.phoneNumber,
            'emailAddress': address.emailAddress,
            'addressName': address.addressName,
            'longitude_code': address.longitude,
            'latitude_code': address.latitude,
            'city': address.city,
            'country': address.country,
            'address': address.address,
            'owner_email': Constant.currentUser!.email
          });
      log('done upload location');
      return d.$id;
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return '';
    }
  }

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

  Future<Either<Map<String, List<Document>>, bool>> getUpdatedProducts(
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
          Query.equal('isAvailable', true),
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
      return Left({
        'newProducts': finalNewProducts,
        'updatedProducts': finalUpdatedProducts
      });
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return Right(false);
    }
  }

  Future<Either<List<Document>, bool>> getRecommendedproductsFromCloud() async {
    List<Document> data = [];
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '65590bfc54fa42e08afd',
        collectionId: "65590c089231c74891b3",
      );
      data = result.documents;
      return Left(data);
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return Right(false);
    }
  }

  Future<Either<Map<String, dynamic>, bool>> getPersonalData() async {
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
      return Left(data);
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return Right(false);
    }
  }

  Future<bool> uploadProfileSettings(
      String borderProducts, String cartProducts, String borders) async {
    Databases db = Databases(client);
    try {
      var data = await db.listDocuments(
        databaseId: '655da767bc3f1651db70',
        collectionId: '655da771422b6ac710aa',
        queries: [Query.equal('email', Constant.currentUser!.email)],
      );
      final userData = data.documents;
      db.updateDocument(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          documentId: userData[0].$id,
          data: {
            'borderProducts': borderProducts,
            'cartProducts': cartProducts,
            'borders': borders,
            'defaultLocation':
                sl.get<SharedPreferences>().getString('defaultLocation')
          });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> rateApp(String descrition, double rate) async {
    Databases db = Databases(client);
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
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    Databases db = Databases(client);
    try {
      var data = await db.listDocuments(
        databaseId: '655da767bc3f1651db70',
        collectionId: '655da771422b6ac710aa',
        queries: [Query.equal('email', Constant.currentUser!.email)],
      );
      final userData = data.documents;
      await db.updateDocument(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          documentId: userData[0].$id,
          data: {'password': newPassword});
      UserModel user = UserModel(
          email: Constant.currentUser!.email,
          name: Constant.currentUser!.name,
          password: newPassword);
      Constant.currentUser = user;
      await sl.get<SharedPreferences>().setString('currentUser', user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadImage(XFile image) async {
    final storage = Storage(client);
    try {
      if (Constant.currentUser!.cloudImgUrl != null) {
        await storage.deleteFile(
            bucketId: '65969d60114e6c041d20',
            fileId: Constant.currentUser!.cloudImgUrl!);
      }
      var d = await storage.createFile(
        bucketId: '65969d60114e6c041d20',
        fileId: ID.unique(),
        file: InputFile.fromPath(
            path: image.path, filename: '${Constant.currentUser!.email}.jpg'),
      );
      Databases db = Databases(client);
      var temp = await db.listDocuments(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa');
      List<Document> users = temp.documents;
      String dId = '';
      for (var element in users) {
        if (element.data['email'] == Constant.currentUser!.email) {
          log(element.data.toString());
          dId = element.$id;
          break;
        }
      }
      db.updateDocument(
          databaseId: '655da767bc3f1651db70',
          collectionId: '655da771422b6ac710aa',
          documentId: dId,
          data: {
            'imgUrl': d.$id
            // 'https://cloud.appwrite.io/v1/storage/buckets/65969d60114e6c041d20/files/$id/view?project=655083f2b78dc8c2d628&mode=admin'
          });
      Constant.currentUser!.cloudImgUrl = d.$id;
      sl
          .get<SharedPreferences>()
          .setString('currentUser', Constant.currentUser!.toJson());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Either<List<Document>, bool>> getProducts() async {
    List<Document> data = [];
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
          databaseId: '65585f55e896c3e87515',
          collectionId: "655860259ae4b331bee6",
          queries: [Query.equal('isAvailable', true)]);
      data = result.documents;
      var finalData =
          data.where((element) => element.data['isAvailable']).toList();
      return Left(finalData);
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return Right(false);
    }
  }

  Future<bool> addOrderToCloudDataBase(
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
      id = data.length;
      String orderDate = Constant.dateToString(DateTime.now());
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
      });
      return true;
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<bool> getOrdersFromCloud() async {
    List<Document> orders = [];
    Databases databases = Databases(client);
    bool isSuccess = false;
    try {
      var result = await databases.listDocuments(
        databaseId: '65590bfc54fa42e08afd',
        collectionId: "65590c089231c74891b3",
        queries: [Query.equal('email', Constant.currentUser!.email)],
      );
      orders = result.documents;
      var s =
          await sl.get<DataSource>().insertDataInOrderTableFromCloud(orders);
      if (!s) {
        isSuccess = false;
      }
      isSuccess = true;
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
    return isSuccess;
  }

  Future<bool> getReviewsFromCloud() async {
    List<Document> orders = [];
    Databases databases = Databases(client);
    try {
      var result = await databases.listDocuments(
        databaseId: '65585f55e896c3e87515',
        collectionId: "65966b22308a7832fddc",
      );
      orders = result.documents;
      if (!await sl
          .get<DataSource>()
          .insertDataInReviewTableFromCloud(orders)) {
        return false;
      }
      log('done getting reviews');
      return true;
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<bool> addReviewToCloud(ReviewModel reviewModel) async {
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
      return true;
    } on AppwriteException catch (_) {
      return false;
    }
  }
}
