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
    required String phoneNum,
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
          await _database // If both fies were uploaded
              .child('speaker_requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'firstName': firstName,
            'lastName': lastName,
            'phoneNumber': phoneNum,
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
          // If picture only provided without the pdf file
          // Store user information in Realtime Database without PDF URL
          await _database
              .child('speaker_requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'firstName': firstName,
            'lastName': lastName,
            'phoneNumber': phoneNum,
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
        // If pdf only provided without the picture
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
          'phoneNumber': phoneNum,
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
        // If none of the files was uploaded
        await _database
            .child('speaker_requests')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNum,
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

  // funcrion to upload the image or pdf file to firebase storage
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

Future<Map<String, dynamic>> getUserInfoByUID(String uid) async {
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref();

  try {
    DatabaseEvent userSnapshot =
        await usersRef.child('users').child(uid).once();

    if (userSnapshot.snapshot.value != null) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(
          userSnapshot.snapshot.value as Map<String, dynamic>);

      // Example: Extracting the first name
      String firstName = userData['firstName'];

      return {'success': true, 'userData': userData, 'firstName': firstName};
    } else {
      return {'success': false, 'message': 'User not found'};
    }
  } catch (error) {
    print('Error fetching user info: $error');
    return {'success': false, 'message': 'Error fetching user info'};
  }
}

void main() async {
  // Replace 'your_uid_here' with the actual UID you want to retrieve
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic> result = await getUserInfoByUID(uid);

  if (result['success']) {
    print('User Data: ${result['userData']}');
    print('First Name: ${result['firstName']}');
  } else {
    print('Error: ${result['message']}');
  }
}
