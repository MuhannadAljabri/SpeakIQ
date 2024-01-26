import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import './change_password.dart';
import '../Style/route_animation.dart';
import '../Style/style.dart';
import '../Style/colors.dart';

class SpeakerPersonalInfo extends StatefulWidget {
  const SpeakerPersonalInfo({Key? key}) : super(key: key);

  @override
  State<SpeakerPersonalInfo> createState() => SpeakerPersonalInfoState();
}

class SpeakerPersonalInfoState extends State<SpeakerPersonalInfo> {

  File? _selectedFile;
  File? _selectedImage;
  String _fileName = '';
  String _imageName = '';
  String _filePath = '';
  String _imagePath = '';
  String? _fileDownloadUrl;
  String? _imageDownloadUrl;
  
  bool formSubmitted = false;

  TextEditingController bioController = TextEditingController(text: 'This is my bio!');
  TextEditingController linkController = TextEditingController(text: 'http://youtube.com/dfaswr');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Personal Information',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // Handle save button click
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: ColorsReference.lightBlue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: () {
                  //_pickImageFromGallery();
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
              )
            ),
            const SizedBox(height: 16),
            // First Name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: firstNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Dan',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Last Name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: lastNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'John',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Email address
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'john@mail.com',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Phone number
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: phoneNumberController,
                //readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '+1 1234567890',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Bio input box
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                },
                controller: bioController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: ColorsReference.textColorBlack),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: ColorsReference.borderColorGray),
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _selectedFile == null
                  ? Column(children: [
                      Container(
                        height: 100,
                        width: 500,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                (Color.fromARGB(250, 240, 240, 240))),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side:
                                    BorderSide(color: ColorsReference.borderColorGray),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          onPressed: () {
                            //_choosePdfFile();
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
                                    //_deletePdfFile();
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
                    )
            ),
            // Video link
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: linkController,
                //readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Link to Video',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Enter a link to video',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Change password
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(slidingFromLeft(const ChangePassword()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(
                      width: 2.0,
                      color: ColorsReference.borderColorGray,
                    ),
                  ),
                  elevation: 0, // Set elevation to 0 to remove the shadow
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: ColorsReference.textColorBlack,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: ColorsReference.textColorBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorsReference.textColorBlack,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
