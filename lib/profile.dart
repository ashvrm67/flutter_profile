import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'ProfileData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Proile Page")),
      body: FutureBuilder<ProfileData?>(
        future:getData(),
        builder: (context, snapData) {

          if(snapData.hasData) {

            ProfileData? obj= snapData.data;
            return Container(
              padding: EdgeInsets.all(30),

              child: Column(
                children: [
                  Card(
                    elevation: 15,
                    child: Column(
                      children: [


                        Text('${obj?.name}'),
                        Text('${obj?.phone}'),
                        Text('${obj?.email}'),



                      ],
                    ),
                  ),

                ],
              ),
            );
          }
          return CircularProgressIndicator();
        }
      ),
    );
  }

  Future<ProfileData?> getData() async
  {

    var phone='9898980000';
    ProfileData profileObj= ProfileData();
    var dio= Dio();
    Response responseObj= await dio.get('https://bazz.techdocklabs.com/api/fetch-testuser/$phone');
    //print("inside getdata");

   if(responseObj.statusCode==200)
     {
       print("response successfully recieved");
       print(responseObj.data);
       List data = responseObj.data['data'];
     profileObj=  ProfileData.fromJson(data[0]);

      return profileObj;

     }
   else {
     return null;
   }
  }
}
