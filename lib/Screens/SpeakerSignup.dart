import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/Style/style.dart';
import 'package:speak_iq/backend/firebase.dart';
import 'package:speak_iq/style/colors.dart';
import 'package:speak_iq/Style/route_animation.dart';

import 'package:speak_iq/Screens/login.dart';
import 'package:speak_iq/Screens/home.dart';

class SpeakerSignUp extends StatefulWidget {
  const SpeakerSignUp({super.key});

  @override
  State<SpeakerSignUp> createState() => _SpeakerSignUpState();
}

class _SpeakerSignUpState extends State<SpeakerSignUp> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  File? _selectedImage;
  String _fileName = '';
  String _imageName = '';
  String _filePath = '';
  String _imagePath = '';
  String? _fileDownloadUrl;
  String? _imageDownloadUrl;
  final Reference _storageReference = FirebaseStorage.instance.ref();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  Color borderColorGray = const Color.fromRGBO(206, 206, 206, 0.5);
  Color textColorBlack = Color.fromARGB(255, 66, 66, 66);
  Color primaryColorGreen = const Color(0xFF2CA6A4);

  // Declare the lists of topics and spoken languages
  List<String> availableTopics = [
    'Finance',
    'Entrepreneurship',
    'Politics',
    'Environment'
  ]; // Your list of words
  List<String> selectedTopics = [];
  List<String> availableLanguages = [
    'Arabic',
    'Chinese',
    'Spanish',
    'French'
  ]; // Your list of words
  List<String> selectedLanguages = [];

  // Declare controllers for each text field
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  Future<void> submission() async {
    try {
      // Validate the form
      if (!_formKey.currentState!.validate()) {
        return;
      }

      // Create the user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // If user creation is successful, proceed with submission
      User? user = userCredential.user;
      if (user != null) {
        UserUploader userUploader = UserUploader();
        String firstName = firstNameController.text;
        String lastName = lastNameController.text;
        String email = emailController.text;
        File pictureFile = File(_imagePath);
        File pdfFile = File(_filePath);
        // Upload the speaker information to the database
        await userUploader.uploadUserData(
            firstName: firstName,
            lastName: lastName,
            email: email,
            bio: bioController.text,
            link: linkController.text,
            topics: selectedTopics,
            languages: selectedLanguages,
            picture: pictureFile,
            pdfFile: pdfFile);

        // Example: printing user information
        print("User ID: ${user.uid}");
        print("Full Name: ${firstNameController.text}");
        print("Last Name: ${lastNameController.text}");
        print("Email: ${emailController.text}");
        // ... (other print statements)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Congratulations!'),
              content: const Text(
                  'You have successfully created an account! You will be notified once your request as a speaker is approved.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.of(context).push(slidingFromLeft(HomePage()));
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle authentication error
      print('Error creating user: $e');

      // Check if the error is due to the email already being in use
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account Exists'),
              content: const Text(
                'An account with this email already exists. Please login or use a different email.',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _choosePdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
        _selectedFile = File(result.files.single.path!);
        _fileName = _selectedFile!.path.split('/').last;
      });
    }
  }

  Future<void> _deletePdfFile() async {
    setState(() {
      _filePath = '';
      _selectedFile = null;
      _fileName = '';
    });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _imagePath = pickedFile != null ? pickedFile.path : "";
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
      _imageDownloadUrl = null;
    });

    if (_selectedImage != null) (print('Image Selected!'));
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
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/speaksy_blue_logo.svg',
                              height: 100,
                              width: 200,
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
                        Navigator.of(context)
                            .push(slidingFromRight(LoginScreen()));
                      },
                    ),
                  ),
                ],
              ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    )),
                              )
                            : SvgPicture.asset(
                                'assets/camera_icon.svg',
                                height: 24,
                                width: 24,
                                color: ColorsReference.lightBlue,
                              ),
                      ),
                    ),
                  )),
              // Name Text Field
              Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 14),
                      child: RequiredTextField(
                          hintText: 'Enter your first name',
                          labelText: 'First Name',
                          textController: firstNameController)),
                  // Last name text field
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: RequiredTextField(
                          hintText: 'Enter your last name',
                          labelText: 'Last Name',
                          textController: lastNameController)),
                  // Email text field
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: RequiredTextField(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          textController: emailController)),
                  // Password text field
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Container(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'The password should be at least 6 characters';
                          }
                        },
                        controller: passwordController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: textColorBlack),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(206, 206, 206, 0.5)),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(44, 44, 44, 0.494)),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          contentPadding:
                              const EdgeInsets.only(top: 20, left: 25),
                          suffixIcon: IconButton(
                            color: textColorBlack,
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
                  // Confirm Password text field
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Container(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                        },
                        controller: confirmPasswordController,
                        obscureText: confirmPasswordVisible,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: textColorBlack),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(206, 206, 206, 0.5)),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(44, 44, 44, 0.494)),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          contentPadding:
                              const EdgeInsets.only(top: 20, left: 25),
                          suffixIcon: IconButton(
                            color: textColorBlack,
                            icon: Icon(confirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  confirmPasswordVisible =
                                      !confirmPasswordVisible;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Phone number text field
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: RequiredTextField(
                        hintText: "Enter your phone number",
                        labelText: "Phone Number (optional)",
                        textController: phoneNumberController,
                        optional: true,
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 41, right: 16, top: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Topics (select all that applies)',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Wrap(
                      spacing: 8.0,
                      children: availableTopics.map((word) {
                        return FilterChip(
                          label: Text(word),
                          selected: selectedTopics.contains(word),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedTopics.add(word);
                              } else {
                                selectedTopics.remove(word);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 41, right: 16, top: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Spoken Languages (select all that applies)',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Wrap(
                      spacing: 8.0,
                      children: availableLanguages.map((word) {
                        return FilterChip(
                          label: Text(word),
                          selected: selectedLanguages.contains(word),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedLanguages.add(word);
                              } else {
                                selectedLanguages.remove(word);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  // Bio input box
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 30),
                    child: TextFormField(
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                      },
                      controller: bioController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: textColorBlack),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(206, 206, 206, 0.5)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(44, 44, 44, 0.494)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Bio (Maximum 5 Lines of Text)',
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              top: 20, left: 25, right: 47, bottom: 40),
                          hintMaxLines: 5,
                          hintText:
                              "Enter your bio here! Please describe yourself as professional and nice as possible. "),
                    ),
                  ),

                  // Sheet upload button
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: _selectedFile == null
                          ? Column(children: [
                              Container(
                                height: 100,
                                width: 350,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        (Color.fromARGB(250, 240, 240, 240))),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        side:
                                            BorderSide(color: borderColorGray),
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
                                      SvgPicture.asset(
                                        'assets/upload_button.svg',
                                        width: 20,
                                        height: 20,
                                        semanticsLabel: 'vector',
                                        color: ColorsReference.lightBlue,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Upload your speaker’s sheet as PDF",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: ColorsReference.lightBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ])
                          : Column(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/Pdf_icon.png',
                                          height: 70,
                                          width: 70,
                                        ),
                                        SizedBox(width: 20),
                                        Flexible(
                                          child: Text(
                                            '$_fileName',
                                            style: TextStyle(
                                                fontFamily: 'Poppins'),
                                          ),
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
                                            color: const Color.fromRGBO(
                                                236, 0, 0, 1),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            )),

                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                    child: RequiredTextField(
                        hintText: "Paste here a link to your video",
                        labelText: "Link to Video",
                        textController: linkController),
                  ),
                ]),
              ),

              // Register button
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Container(
                    height: 48,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorsReference.darkBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submission();
                        }
                      },
                      child: Text('Register'),
                    ),
                  )),
              // Navigate to login page
              Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 14)),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: ColorsReference.lightBlue,
                              ),
                            ))
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
