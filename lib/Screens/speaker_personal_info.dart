import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend/firebase.dart';
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
  bool hasChanges = false;

  bool isFirstNameValid = true;
  bool isLastNameValid = true;
  bool isPhoneNumberValid = true;
  bool isOtherRoleValid = true;
  bool isBioValid = true;
  bool isLinkValid = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  String pictureUrl = "";
  String pdfUrl = "";

  Image? imageToView;

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode linkFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData(); // Load data when the widget is initialized
  }

  Future<void> loadData() async {
    await getSpeaker(); // Load speaker info
    setState(() {
      // Set the state to update the UI
    });
  }

  Future<void> getSpeaker() async {
    GetSpeakerInfo speakerInfoGetter = GetSpeakerInfo();
    SpeakerData speaker = await speakerInfoGetter.loadSpeaker();
    setState(() {
      firstNameController.text = speaker.firstName;
      lastNameController.text = speaker.lastName;
      emailController.text = speaker.email;
      phoneNumberController.text = speaker.phoneNumber;
      bioController.text = speaker.bio;
      linkController.text = speaker.link;
      pictureUrl = speaker.pictureUrl;
      pdfUrl = speaker.pdfUrl;
    });
  }

  Future<void> updateSpeaker() async {

    setState(() async {
      formSubmitted = true;
      isFirstNameValid = firstNameController.text.isNotEmpty;
      isLastNameValid = lastNameController.text.isNotEmpty;
      isPhoneNumberValid = phoneNumberController.text.isEmpty ||
        _isValidPhoneNumber(phoneNumberController.text);
      isBioValid = bioController.text.isNotEmpty;
      isLinkValid = linkController.text.isNotEmpty;
      
      // Maintain focus on the field with an empty value
      if (!isFirstNameValid) {
        FocusScope.of(context).requestFocus(firstNameFocus);
      } else if (!isLastNameValid) {
        FocusScope.of(context).requestFocus(lastNameFocus);
      } else if (!isPhoneNumberValid) {
        FocusScope.of(context).requestFocus(phoneNumberFocus);
      } else if (!isBioValid) {
        FocusScope.of(context).requestFocus(bioFocus);
      } else if (!isLinkValid) {
        FocusScope.of(context).requestFocus(linkFocus);
      }

      // Call a method to update user information in Firebase
      else {
        FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
            'phoneNumber': phoneNumberController.text,
          });
        if (_selectedImage != null) {
          UserUploader userUploader = UserUploader();
          try {
            // Generate a unique filename for the new image
            String lastNameWithUniqueExtension = '${lastNameController.text}-${DateTime.now().millisecondsSinceEpoch}';
            String uploadedImageUrl = await userUploader.uploadFile(
              _selectedImage!,
              'profile_pics',
              firstNameController.text,
              lastNameWithUniqueExtension,
            );
            pictureUrl = uploadedImageUrl;
            // Handle the download URL as needed
          } catch (error) {
            // Handle any errors that occur during the upload process
            print('Error uploading image file: $error');
          }
        }
        
        if (_filePath != '') {
          UserUploader userUploader = UserUploader();
          try {
            // Generate a unique filename for the new pdf file
            String lastNameWithUniqueExtension = '${lastNameController.text}-${DateTime.now().millisecondsSinceEpoch}';
            String uploadedPdfUrl = await userUploader.uploadFile(
              File(_filePath),
              'speaker_sheets',
              firstNameController.text,
              lastNameWithUniqueExtension,
            );
            pdfUrl = uploadedPdfUrl;
            // Handle the download URL as needed
          } catch (error) {
            // Handle any errors that occur during the upload process
            print('Error uploading pdf file: $error');
          }
        }

        FirebaseDatabase.instance
          .ref()
          .child("speaker_requests")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'fullName': '${firstNameController.text} ${lastNameController.text}',
            'bio': bioController.text,
            'link': linkController.text,
            'pictureUrl': pictureUrl,
            'pdfUrl': pdfUrl,
          });
        // Show a dialog if update is successful
        setState(() {
          showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Update Successful'),
            content: const Text('Your information has been updated.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        });
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _imagePath = pickedFile != null ? pickedFile.path : "";
      _selectedImage = pickedFile != null ? File(pickedFile.path) : null;
      _imageDownloadUrl = null;
      hasChanges = true;
    });

    if (_selectedImage != null) (print('Image Selected!'));
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
        hasChanges = true;
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
              onPressed: hasChanges ? updateSpeaker : null,
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
        body: Stack (
          children: [
            ListView(
              children: [
                const SizedBox(height: 16),
                // Profile Image
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          imageToView = _selectedImage != null
                              ? Image.file(_selectedImage!)
                              : Image.network(pictureUrl.isNotEmpty && pictureUrl.startsWith('http') ? pictureUrl : '');
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 85,
                                  width: 85,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  pictureUrl.startsWith('http') ? pictureUrl : '',
                                  height: 85,
                                  width: 85,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Trigger the logic to select and upload a new picture
                        _pickImageFromGallery();
                      },
                      child: Container (
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(112, 61, 0, 0),
                        child: SvgPicture.asset(
                          'assets/camera_icon.svg', // Replace 'upload_image.svg' with the path to your SVG file
                          width: 24,
                          height: 24,
                          semanticsLabel: 'Upload Image',
                          color: ColorsReference.lightBlue,),
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // First Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: firstNameController,
                    focusNode: firstNameFocus,
                    onChanged: (value) {
                      setState(() {
                        hasChanges = true;
                        isFirstNameValid = value.isNotEmpty;
                      });
                    },
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter your first name',
                      contentPadding: const EdgeInsets.all(16.0),
                      labelStyle: const TextStyle(
                        color: ColorsReference.textColorBlack, 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: isFirstNameValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: isFirstNameValid
                              ? ColorsReference.borderColorGray
                              : ColorsReference.errorColorRed,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorText:
                        isFirstNameValid ? null : 'Please enter your first name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                // Last Name
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: lastNameController,
                    focusNode: lastNameFocus,
                    onChanged: (value) {
                      setState(() {
                        hasChanges = true;
                        isLastNameValid = value.isNotEmpty; 
                      });
                    },
                    // readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter your last name',
                      contentPadding: const EdgeInsets.all(16.0),
                      labelStyle: const TextStyle(
                        color: ColorsReference.textColorBlack, 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: isLastNameValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: isLastNameValid
                              ? ColorsReference.borderColorGray
                              : ColorsReference.errorColorRed,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorText:
                        isLastNameValid ? null : 'Please enter your last name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                // Email address
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    style: const TextStyle(color: ColorsReference.textColorBlack),
                    controller: emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'You are not alllowed to change your email address',
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
                    controller: phoneNumberController,
                    focusNode: phoneNumberFocus,
                    onChanged: (value) {
                      setState(() {
                        hasChanges = true;
                        isPhoneNumberValid = value.isEmpty || _isValidPhoneNumber(value);
                      });
                    },
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter your phone number',
                      contentPadding: const EdgeInsets.all(16.0),
                      labelStyle: const TextStyle(
                        color: ColorsReference.textColorBlack,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: isPhoneNumberValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: isPhoneNumberValid
                              ? ColorsReference.borderColorGray
                              : ColorsReference.errorColorRed,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorText:
                        isPhoneNumberValid ? null : 'Please a valid phone number',
                      border: OutlineInputBorder(
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
                    onChanged: (value) {
                      setState(() {
                        hasChanges = true;
                        isBioValid = value.isNotEmpty;
                      });
                    },
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
                                backgroundColor: MaterialStateProperty.all<Color>((const Color.fromARGB(250, 240, 240, 240))),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(color: ColorsReference.borderColorGray),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/upload_button.svg',
                                        width: 20,
                                        height: 20,
                                        semanticsLabel: 'vector',
                                        color: ColorsReference.lightBlue,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Upload new speaker sheet',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: ColorsReference.lightBlue),
                                      ),
                                    ],
                                  ),                                  
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap event, e.g., open the URL in a web browser
                                      // You can use launch(url) from the url_launcher package to open the URL
                                      launch(pdfUrl);
                                    },
                                    child: Text(
                                      extractFileNameFromUrl(pdfUrl),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
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
                        )
                ),
                // Video link
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    controller: linkController,
                    focusNode: linkFocus,
                    onChanged: (value) {
                      setState(() {
                        hasChanges = true;
                        isLinkValid = value.isNotEmpty && value.startsWith('http');
                      });
                    },
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Link to video',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter your video link',
                      contentPadding: const EdgeInsets.all(16.0),
                      labelStyle: const TextStyle(
                        color: ColorsReference.textColorBlack, 
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: isLinkValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: isLinkValid
                              ? ColorsReference.borderColorGray
                              : ColorsReference.errorColorRed,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorText:
                        isLinkValid ? null : 'Please enter a valid video link',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                // Change password
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).push(slidingFromLeft(const ChangePassword()));
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.white,
                //       padding: const EdgeInsets.all(16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0),
                //         side: const BorderSide(
                //           width: 2.0,
                //           color: ColorsReference.borderColorGray,
                //         ),
                //       ),
                //       elevation: 0, // Set elevation to 0 to remove the shadow
                //     ),
                //     child: const Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Row(
                //           children: [
                //             Icon(
                //               Icons.lock_outline_rounded,
                //               color: ColorsReference.textColorBlack,
                //               size: 24,
                //             ),
                //             SizedBox(width: 10),
                //             Text(
                //               'Change Password',
                //               style: TextStyle(
                //                 color: ColorsReference.textColorBlack,
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w400,
                //                 fontFamily: 'Poppins',
                //               ),
                //             ),
                //           ],
                //         ),
                //         Icon(
                //           Icons.arrow_forward_ios_rounded,
                //           color: ColorsReference.textColorBlack,
                //           size: 20,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),
              ],
            ),
            if (imageToView != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imageToView = null;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {}, // Prevents dismissing on tap
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          child: Image(
                            image: imageToView!.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Use a regular expression to check the phone number format
    // ^ asserts the start of the string.
    // \+? allows an optional plus sign for the country code.
    // \d{0,3} allows for up to 3 digits for the country code.
    // \d{10} requires exactly 10 digits for the main part of the phone number.
    // $ asserts the end of the string.
    RegExp phoneRegex = RegExp(r'^\+?\d{0,3}?\d{8,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  String extractFileNameFromUrl(String url) {
    // Parse the URL to extract the path
    Uri uri = Uri.parse(url);
    String path = uri.path;

    // Remove the 'speaker_sheets%2F' part from the path
    String cleanedPath = path.replaceAll('speaker_sheets%2F', '');

    // Split the path using '/' as the delimiter
    List<String> pathParts = cleanedPath.split('/');

    // Get the last part of the path which represents the file name
    String fileNamePart = pathParts.last;

    // Decode the URL-encoded characters
    String decodedFileName = Uri.decodeFull(fileNamePart);

    // Extract the file name
    List<String> fileNameParts = decodedFileName.split('?');
    String fileName = fileNameParts.first;

    return fileName;
  }

}
