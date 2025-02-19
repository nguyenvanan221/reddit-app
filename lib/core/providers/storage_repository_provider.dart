import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/type_defs.dart';
// import 'package:http/http.dart' as http;

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // FutureEither<String> storeFile1({
  //   required String path,
  //   required File? file,
  // }) async {
  //   try {
  //     final url = Uri.parse(
  //         'https://api.cloudinary.com/v1_1/dicqpt1o5/ml_default/upload');
  //     final request = http.MultipartRequest('POST', url)
  //       ..fields['upload+preset'] = 'reddit_app'
  //       ..files.add(await http.MultipartFile.fromPath(path, file!.path));
  //     var response = await request.send();

  //     var responseData = await response.stream.bytesToString();
  //     var jsonResponse = jsonDecode(responseData);

  //     print(jsonResponse['secure_url']);
  //     return right(jsonResponse['secure_url']);
  //   } catch (e) {
  //     print(e.toString());
  //     return left(Failure(e.toString()));
  //   }
  // }
}
