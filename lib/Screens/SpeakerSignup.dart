import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpeakerSignUp extends StatefulWidget {
  const SpeakerSignUp({super.key});

  @override
  State<SpeakerSignUp> createState() => _SpeakerSignUpState();
}

class _SpeakerSignUpState extends State<SpeakerSignUp> {
  File? _selectedFile;
  File? _selectedImage;
  String _fileName = '';
  String _imageName = '';
  String _fileDownloadUrl = '';
  String _imageDownloadUrl = '';
  final Reference _storageReference = FirebaseStorage.instance.ref();
  List<String> roles = ['Event Planner', 'Speaker', 'Other'];
  String selectedRole = 'None'; // Set a default role
  bool passwordVisible = true;
  Color primaryColorGray = const Color.fromRGBO(206, 206, 206, 0.5);
  Color primaryColorGreen = const Color(0xFF2CA6A4);

  // Declare controllers for each text field
  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Future<void> _choosePdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = _selectedFile!.path.split('/').last;
      });
    }
  }

  Future<void> _deletePdfFile() async {
    setState(() {
      _selectedFile = null;
      _fileName = '';
    });
  }

  Future<void> _submitPdfFile() async {
    if (_selectedFile != null) {
      try {
        String fileName = _selectedFile!.path.split('/').last;
        final storageReference = _storageReference.child('pdfs/$fileName');
        await storageReference.putFile(_selectedFile!);

        String downloadUrl = await storageReference.getDownloadURL();

        setState(() {
          _fileDownloadUrl = downloadUrl;
        });

        // Add any additional logic you need after the upload is complete

        // Reset the state after successful upload
        _deletePdfFile();
      } catch (e) {
        print('Error during file upload: $e');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitImage() async{
    if (_selectedImage != null){
    String ImageName = _selectedImage!.path.split('/').last;
    final storageReference = _storageReference.child('images/$ImageName');
        await storageReference.putFile(_selectedImage!);

        String downloadUrl = await storageReference.getDownloadURL();

        setState(() {
          _imageDownloadUrl = downloadUrl;
        });
        _selectedImage = null;
  }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (Logo, Text, Back Button, background)
            Stack(
              //alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Container(
                            width: 65,
                            height: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const Image(
                                  image:
                                      AssetImage('assets/MicDropLogoMain.png')),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Register new account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ]),
                ),
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: IconButton(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30, top: 50),
                    iconSize: 28,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate back to the previous screen
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
              ],
            ),
            if(_selectedImage == null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: () {
                  _pickImageFromGallery();
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(250, 240, 240, 240),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                        
                    child: SvgPicture.asset(
                      'assets/camera_icon.svg',
                      height: 24,
                      width: 24,
                      color: primaryColorGreen,
                    ),
                  ),
                ),
              ),
            ),
            if(_selectedImage != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: () {
                  _pickImageFromGallery();
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(250, 240, 240, 240),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                        
                    child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          height: 85,
          width: 85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Image.file(_selectedImage!,fit: BoxFit.cover,)
                  ),
                ),
              ),
            ),)),


            // Name Text Field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Container(
                height: 59,
                child: TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'First Name*',
                    hintText: 'Enter your first name',
                    contentPadding: const EdgeInsets.only(top: 20, left: 25),

                    //prefixText: prefixText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            // Last name text field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                height: 59,
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Last Name*',
                    hintText: 'Enter your last name',
                    contentPadding: const EdgeInsets.only(top: 20, left: 25),

                    //prefixText: prefixText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            // Email text field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                height: 59,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Email*',
                    hintText: 'Enter your email',
                    contentPadding: const EdgeInsets.only(top: 20, left: 25),

                    //prefixText: prefixText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            // Phone number text field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                height: 59,
                child: TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    contentPadding: const EdgeInsets.only(top: 20, left: 25),

                    //prefixText: prefixText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            // Password text field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: passwordController,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2.0,
                              color: Color.fromRGBO(206, 206, 206, 0.5)),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2.0,
                              color: Color.fromRGBO(206, 206, 206, 0.5)),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Password*',
                        hintText: 'Enter your password',
                        contentPadding:
                            const EdgeInsets.only(top: 20, left: 25),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            // Bio input box
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color.fromRGBO(206, 206, 206, 0.5), // Border color
                      width: 2,
                    )), // Border width
                height: 211,
                child: TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.only(top: 25, left: 25, right: 47),
                      hintMaxLines: 5,
                      hintText:
                          "Enter your bio here! Please describe yourself as professional and nice as possible. "),
                ),
              ),
            ),
            // Sheet upload button
            if (_selectedFile == null)
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Container(
                    height: 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            (Color.fromARGB(250, 240, 240, 240))),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side:
                                BorderSide(color: Color.fromRGBO(0, 0, 0, 0.4)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _choosePdfFile();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/upload_button.svg',
                              width: 20, height: 20, semanticsLabel: 'vector'),
                          SizedBox(height: 10),
                          Text(
                            "Upload your speaker’s sheet as PDF",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF2CA6A4)),
                          )
                        ],
                      ),
                    ),
                  )),
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Pdf_icon.png',
                          height: 70,
                          width: 70,
                        ),
                        SizedBox(width: 20),
                        Text(
                          '$_fileName',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            _deletePdfFile();
                          },
                          // ignore: deprecated_member_use
                          child: SvgPicture.asset(
                            'assets/delete_button.svg',
                            color: const Color.fromRGBO(236, 0, 0, 1),
                          ),
                        ),
                      ],
                    )),
              ),

            // Register button
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF2CA6A4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) =>
                              Navigator.pushReplacementNamed(context, '/home'));
                      _submitPdfFile();

                      FirebaseDatabase.instance
                          .ref()
                          .child("speaker_requests")
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'first name': fullNameController.text,
                        'last name': lastNameController.text,
                        'email': emailController.text,
                        'bio': bioController.text,
                        'image': _imageDownloadUrl,
                        'speaker_sheet': _fileDownloadUrl,
                        'approval_state': 'pending'
                      });
                      _submitPdfFile();
                      _submitImage();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Congratulations!'),
                            content: const Text(
                                'You have successfully created an account!'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                      print("Full Name: ${fullNameController.text}");
                      print("Last Name: ${lastNameController.text}");
                      print("Email: ${emailController.text}");
                      print("Phone Number: ${phoneNumberController.text}");
                      print("Password: ${passwordController.text}");
                      //print("Role: ${roleController.text}");
                    },
                    child: Text('Register'),
                  ),
                )),
            // Navigate to login page
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the login page
                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Color(0xFF2CA6A4),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
