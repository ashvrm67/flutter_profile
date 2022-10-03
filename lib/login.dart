import 'dart:io';

import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);


  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final ImagePicker _picker= ImagePicker();


  File? file;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Form'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 35),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Text(
                      "Welcome to Signup Page",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * .08),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value != null) {
                          if (value.length == 0)
                            return "Name no is blank";
                          else
                            return null;
                        } else
                          return "Name can not be blank";
                      },
                      decoration: InputDecoration(labelText: "Enter Name"),
                    ),
                    SizedBox(height: height * .03),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value != null) {
                          if (value.length == 0)
                            return "Phone no is blank";
                          else
                            return null;
                        } else
                          return "Phone no can not be blank";
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Phone",
                      ),
                    ),
                    SizedBox(height: height * .03),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (!emailValid)
                          return "Email is not valid";
                        else
                          return null;
                      },
                      decoration: InputDecoration(labelText: "Enter Email"),
                    ),
                    SizedBox(height: height * .03),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value != null) {
                          if (value.length == 0) {
                            return "Password can not be Blank";
                          } else
                            return null;
                        } else
                          return "Password is Blank";
                      },
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Enter Password"),
                    ),
                    SizedBox(height: height * .04),
                    InkWell(
                        child: file != null
                            ? CircleAvatar(
                          foregroundImage: FileImage(file!),
                          radius: 80,
                          // child: file!=null ?Image.file(file!) : Image.asset('assets/user.png'),
                        )
                            : CircleAvatar(
                          foregroundImage: AssetImage('assests/images/profile.png'),
                          radius: 80,
                        ),
                    //     child: Container(
                    //   width: 80,
                    //   height: 80,
                    //   child: Text("Upload Image"),
                    //   padding: EdgeInsets.all(4),
                    //   decoration: BoxDecoration(shape: BoxShape.circle ,border: Border.all(color: Colors.grey, width: 4))
                    //
                    // ),
                        onTap:() async {
                          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                        file=File(image!.path);
                        setState(() {
                          file;
                        });
                        }

                    ),
                    SizedBox(height: height * .04),

                    Row(
                      children: [
                        ElevatedButton(

                            onPressed: ( ) {

                              bool isValid=formkey.currentState?.validate()??false;
                              if(isValid){
                               // postData();
                              savePreferences();    //post in preferences
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Text("Sign up"),
                            )),
                      SizedBox(width: 30),

                        ElevatedButton(
                            onPressed: ( ) {
                              getPreferences();


                            },
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Text("Fetch Data"),
                            )),



                      ],
                    ),
                    SizedBox(height:30,),
                    ElevatedButton(
                        onPressed: ( ) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder:(context)=>ProfilePage()));

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text("Profile Page"),
                        )),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void savePreferences() async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('name', nameController.text);
    await prefs.setInt('phone',   int.parse(phoneController.text));
    await prefs.setString("image_path", file?.path??'');     //this is null check operator if file?.path ki value null hogi to '' return karega

  }
  void getPreferences() async
  {
    final prefs = await SharedPreferences.getInstance();
    final int? phone = prefs.getInt('phone');
    final String? email = prefs.getString('email');
    final String? name = prefs.getString('name');

    //final XFile? imageFile = await _picker.pickImage(source:);
    String? filepath=prefs.getString('image_path');
    if(filepath!=null)
     file=File(filepath);
    else
      file=null;


    setState(() {
      file;
    });
    //file?.path=;
    print (phone);
    print(email);
    print(name);
    emailController.text=email!;
    phoneController.text="$phone";
    nameController.text=name!;

  }

  void postData() async
  {
    var body={"name":nameController.text,
              "phone":phoneController.text,
              "email":emailController.text,
              "password":passwordController.text};
    var dio= Dio();

Response response=  await dio.post("https://bazz.techdocklabs.com/api/register-testuser", data: body);
print(response.data);

  }
}


// nullable variable - Type willhave ? viz String?
//assignment of null value in nonnullable variable    viz late String name ;   assigment  name= "ABC";  other way String name= varibalevalue??'';