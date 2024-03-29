import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

// The following class is for uploading speakers info to firebase storage and firebase database

class UserUploader {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final Reference _storageRoot = FirebaseStorage.instance.ref();

  Future<void> uploadSpeakerInfo({
    required String firstName,
    required String lastName,
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
            await uploadFile(picture, 'profile_pics', firstName, lastName);

        // Check if pdf file exists and is not empty
        if (pdfFile.existsSync() && pdfFile.lengthSync() > 0) {
          // Upload PDF file to Firebase Storage
          String pdfDownloadUrl =
              await uploadFile(pdfFile, 'speaker_sheets', firstName, lastName);

          // Store user information in Realtime Database
          await _database // If both fies were uploaded
              .child('speaker_requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'fullName': "$firstName $lastName",
            'bio': bio,
            'link': link,
            'topics': topics,
            'languages': languages,
            'pictureUrl': pictureDownloadUrl,
            'pdfUrl': pdfDownloadUrl,
            'status': 'pending'
          });

          print('User data uploaded successfully.');
        } else {
          // If picture only provided without the pdf file
          // Store user information in Realtime Database without PDF URL
          await _database
              .child('speaker_requests')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'fullName': "$firstName $lastName",
            'bio': bio,
            'link': link,
            'topics': topics,
            'languages': languages,
            'pictureUrl': pictureDownloadUrl,
            'pdfUrl': 'Not provided',
            'status': 'pending'
          });

          print('User data uploaded with only picture.');
        }
      } else if (pdfFile.existsSync() && pdfFile.lengthSync() > 0) {
        // If pdf only provided without the picture
        // Upload PDF file to Firebase Storage
        String pdfDownloadUrl =
            await uploadFile(pdfFile, 'speaker_sheets', firstName, lastName);

        print('Picture file is empty or does not exist. Uploading only PDF.');
        // Store user information in Realtime Database without picture URL
        await _database
            .child('speaker_requests')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'fullName': "$firstName $lastName",
          'bio': bio,
          'link': link,
          'topics': topics,
          'languages': languages,
          'pictureUrl': 'Not provided',
          'pdfUrl': pdfDownloadUrl,
          'status': 'pending'
        });

        print('User data uploaded with only PDF.');
      } else {
        // If none of the files was uploaded
        await _database
            .child('speaker_requests')
            .child(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'fullName': "$firstName $lastName",
          'bio': bio,
          'link': link,
          'topics': topics,
          'languages': languages,
          'pictureUrl': 'Not provided',
          'pdfUrl': 'Not provided',
          'status': 'pending'
        });
        print(
            'Both picture and PDF files are empty or do not exist. Aborting upload.');
      }
    } catch (error) {
      print('Error uploading user data: $error');
    }
  }

  // function to upload the image or pdf file to firebase storage
  Future<String> uploadFile(File file, String storageFolder, String firstName,
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

  Future<void> uploadUserInfo({
    required String firstName,
    required String lastName,
    required String phoneNum,
    required String email,
  }) async {
    await _database // If both fies were uploaded
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNum,
      'email': email,
      'role': 'pending speaker approval'
    });
  }
}

final DatabaseReference _userssRef =
    FirebaseDatabase.instance.ref().child('users');

final DatabaseReference _speakersRef =
    FirebaseDatabase.instance.ref().child('speaker_requests');

class Speaker {
  final String userID;
  final String firstName;
  final String pictureUrl;

  Speaker(this.userID, this.firstName, this.pictureUrl);
}


// Get the user information from Firebase Database

class UserData {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  //final String otherRole;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    //required this.otherRole,
  });
}

class SpeakerData {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  //final String otherRole;
  final String bio;
  final String link;
  final String pdfUrl;
  final String pictureUrl;
  final String status;
  final List<String> languages;
  final List<String> topics;

  SpeakerData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    //required this.otherRole,
    required this.bio,
    required this.link,
    required this.pdfUrl,
    required this.pictureUrl,
    required this.status,
    required this.languages,
    required this.topics,
  });
}

class GetUserInfo {
  String firstName = "";
  String lastName = "";
  String email = "";
  String phoneNumber = "";
  String role = "";

  Future<bool> isUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await _userssRef.child(user!.uid).once();
    return snapshot.snapshot.value != null;
  }

  Future<String> loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (await isUser()) {
      final snapshot = await _userssRef.child(user!.uid).once();
      Map<dynamic, dynamic> userData =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      firstName = userData["firstName"];

      return firstName;
    } else {
      final snapshot = await _speakersRef.child(user!.uid).once();
      Map<dynamic, dynamic> userData =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      firstName = userData["firstName"];
      return firstName;
    }
  }

  Future<UserData> loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await _userssRef.child(user!.uid).once();
    Map<dynamic, dynamic> userData =
        snapshot.snapshot.value as Map<dynamic, dynamic>;

    // Extract user information from the retrieved data
    String firstName = userData['firstName'] ?? '';
    String lastName = userData['lastName'] ?? '';
    String email = userData['email'] ?? '';
    String phoneNumber = userData['phoneNumber'] ?? '';
    String role = userData['role'] ?? '';
    //String otherRole = userData['otherRole'] ?? ';

    // Create a UserData object with the extracted information
    UserData userInfo = UserData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
      //otherRole: otherRole,
    );

    return userInfo;
  }
}

class GetSpeakerInfo {
  String firstName = "";
  String lastName = "";
  String email = "";
  String phoneNumber = "";
  String role = "";
  String bio = "";
  String link = "";
  String pdfUrl = "";
  String pictureUrl = "";
  String status = "";
  List<String> languages = [];
  List<String> topics = [];

  Future<SpeakerData> loadSpeaker() async {
    final user = FirebaseAuth.instance.currentUser;
    final userSnapshot = await _userssRef.child(user!.uid).once();
    Map<dynamic, dynamic> userData =
        userSnapshot.snapshot.value as Map<dynamic, dynamic>;

    final speakerSnapshot = await _speakersRef.child(user!.uid).once();
    Map<dynamic, dynamic> speakerData =
        speakerSnapshot.snapshot.value as Map<dynamic, dynamic>;

    // Extract user information from the retrieved data
    String firstName = userData['firstName'] ?? '';
    String lastName = userData['lastName'] ?? '';
    String email = userData['email'] ?? '';
    String phoneNumber = userData['phoneNumber'] ?? '';
    String role = userData['role'] ?? '';
    //String otherRole = userData['otherRole'] ?? ';
    String bio = speakerData['bio'] ?? '';
    String link = speakerData['link'] ?? '';
    String pdfUrl = speakerData['pdfUrl'] ?? '';
    String pictureUrl = speakerData['pictureUrl'] ?? '';
    String status = speakerData['status'] ?? '';
    List<String> languages = List<String>.from(speakerData['languages'] ?? []);
    List<String> topics = List<String>.from(speakerData['topics'] ?? []);

    // Create a UserData object with the extracted information
    SpeakerData speakerInfo = SpeakerData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
      //otherRole: otherRole,
      bio: bio,
      link: link,
      pdfUrl: pdfUrl,
      pictureUrl: pictureUrl,
      status: status,
      languages: languages,
      topics: topics,
    );
    return speakerInfo;
  }
}
