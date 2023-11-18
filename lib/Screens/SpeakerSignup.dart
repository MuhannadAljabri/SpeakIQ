import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadImageAndPDF extends StatefulWidget {
  const UploadImageAndPDF({Key? key}) : super(key: key);

  @override
  State<UploadImageAndPDF> createState() => _UploadImageAndPDFState();
}

class _UploadImageAndPDFState extends State<UploadImageAndPDF> {
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _imageUrl = '';
  String _pdfUrl = '';
  bool _isLoading = false;

  Future<void> _uploadImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _isLoading = true;
      });

      final Reference ref = _storage.ref().child('images/${image.name}');
      final UploadTask uploadTask = ref.putFile(image.path as File);

      await uploadTask.whenComplete(() async {
        final url = await ref.getDownloadURL();
        setState(() {
          _imageUrl = url;
          _isLoading = false;
        });

        final imageData = {
          'url': _imageUrl,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        // ignore: deprecated_member_use
        await _database.reference().child('images').push().set(imageData);
      });
    }
  }

  Future<void> _uploadPDF() async {
    final XFile? pdf = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pdf != null) {
      setState(() {
        _isLoading = true;
      });

      final Reference ref = _storage.ref().child('pdfs/${pdf.name}');
      final UploadTask uploadTask = ref.putFile(pdf.path as File);

      await uploadTask.whenComplete(() async {
        final url = await ref.getDownloadURL();
        setState(() {
          _pdfUrl = url;
          _isLoading = false;
        });

        final pdfData = {
          'url': _pdfUrl,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        await _database.reference().child('pdfs').push().set(pdfData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image and PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadPDF,
              child: const Text('Upload PDF'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_imageUrl.isNotEmpty)
              Image.network(_imageUrl),
            if (_pdfUrl.isNotEmpty)
              Text('PDF URL: $_pdfUrl'),
          ],
        ),
      ),
    );
  }
}
