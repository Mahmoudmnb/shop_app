import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:shop_app/core/constant.dart';

class RemoteDataSource {
  getProducts() async {
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Constant.appWriteProjectId);
    Databases databases = Databases(client);
    try {
      databases.createDocument(
          databaseId: '65590bfc54fa42e08afd',
          collectionId: '65590c089231c74891b3',
          documentId: '2',
          data: {
            'email': 'mm@gmail.com',
            'orders_ids': [1, 5, 7]
          }).then((value) {
        log(value.$collectionId);
      });
      // databases
      //     .listDocuments(
      //   databaseId: '65585f55e896c3e87515',
      //   collectionId: "655860259ae4b331bee6",
      // )
      //     .then((value) {
      //   log(value.documents.toString());
      // });
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
  }
}
