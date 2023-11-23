import 'package:flutter/material.dart';

// Text field for required cases ex. email, password. A parent widget Form() will need to be used for this to to be functional

class RequiredTextField extends StatefulWidget {
   final String hintText;
  final String labelText;
  final TextEditingController textController;
  final bool optional;

  RequiredTextField(
      {super.key, required this.hintText,
      required this.labelText,
      required this.textController, this.optional = false});

  @override
  State<RequiredTextField> createState() => _RequiredTextFieldState();
}

class _RequiredTextFieldState extends State<RequiredTextField> {
    Color textColorBlack = Color.fromARGB(255, 66, 66, 66);

    String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      
      validator: (value) {
        if (value == null || value.isEmpty &&  !widget.optional)  {
          return 'This field is required';
        }
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(color: textColorBlack),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2.0, color: Color.fromRGBO(44, 44, 44, 0.494)),
          borderRadius: BorderRadius.circular(50.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.labelText,
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.only(top: 20, left: 25),

        //prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );}
   
  }
