import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserUploader {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final Reference _storageRoot = FirebaseStorage.instance.ref();

  Future<void> uploadUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String bio,
    required String link,
    required File picture,
    required File pdfFile,
    required List<String> topics,
    required List<String> languages,
  }) async {
    try {
      // Check if picture file exists and is not empty
      if (picture.existsSync() && picture.lengthSync() > 0) {
        // Upload picture to Firebase Storage
        String pictureDownloadUrl =
            await _uploadFile(picture, 'profile_pics', firstName, lastName);

        // Check if pdf file exists and is not empty
        if (pdfFile.existsSync() && pdfFile.lengthSync() > 0) {
          // Upload PDF file to Firebase Storage
          String pdfDownloadUrl =
              await _uploadFile(pdfFile, 'speaker_sheets', firstName, lastName);

          // Store user information in Realtime Database
          await _database
              .child('speaker_requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'bio': bio,
            'link': link,
            'topics': topics,
            'languages': languages,
            'pictureUrl': pictureDownloadUrl,
            'pdfUrl': pdfDownloadUrl,
          });

          print('User data uploaded successfully.');
        } else {
          print('PDF file is empty or does not exist. Uploading only picture.');
          // Store user information in Realtime Database without PDF URL
          await _database
              .child('speaker_requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'bio': bio,
            'link': link,
            'topics': topics,
            'languages': languages,
            'pictureUrl': pictureDownloadUrl,
            'pdfUrl': 'Not provided'
          });

          print('User data uploaded with only picture.');
        }
      } else if (pdfFile.existsSync() && pdfFile.lengthSync() > 0) {
        // Upload PDF file to Firebase Storage
        String pdfDownloadUrl =
            await _uploadFile(pdfFile, 'speaker_sheets', firstName, lastName);

        print('Picture file is empty or does not exist. Uploading only PDF.');
        // Store user information in Realtime Database without picture URL
        await _database
            .child('speaker_requests')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'bio': bio,
          'link': link,
          'topics': topics,
          'languages': languages,
          'pictureUrl': 'Not provided',
          'pdfUrl': pdfDownloadUrl,
        });

        print('User data uploaded with only PDF.');
      } else {
        await _database
            .child('speaker_requests')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'bio': bio,
          'link': link,
          'topics': topics,
          'languages': languages,
          'pictureUrl': 'Not provided',
          'pdfUrl': 'Not provided',
        });
        print(
            'Both picture and PDF files are empty or do not exist. Aborting upload.');
      }
    } catch (error) {
      print('Error uploading user data: $error');
    }
  }

  Future<String> _uploadFile(File file, String storageFolder, String firstName,
      String lastName) async {
    try {
      if (storageFolder == 'speaker_sheets') {
        String fileName = file!.path.split('.').last;
        final storageReference =
            _storageRoot.child('speaker_sheets/$firstName-$lastName.$fileName');
        await storageReference.putFile(file!);
        return await storageReference.getDownloadURL();
      } else {
        String fileName = file!.path.split('.').last;
        final storageReference =
            _storageRoot.child('profile_pics/$firstName-$lastName.$fileName');
        await storageReference.putFile(file!);
        return await storageReference.getDownloadURL();
      }
    } catch (error) {
      print('Error uploading file: $error');
      rethrow; // Rethrow the error to handle it in the calling function
    }
  }
}
