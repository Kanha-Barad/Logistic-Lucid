import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'Logistics_DashBoard.dart';
import 'globals.dart' as globals;

TextEditingController userNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LogisticsLogin extends StatefulWidget {
  @override
  State<LogisticsLogin> createState() => _LogisticsLoginState();
}

class _LogisticsLoginState extends State<LogisticsLogin> {
  @override
  Widget build(BuildContext context) {
    logisticAppLogin(username, password, BuildContext context) async {
      Map data = {
        "User_name": username,
        "password": password,
        "connection": globals.Connection_String
      };
      // ignore: avoid_print
      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.Global_Api_URL + '/Logistics/Login'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      setState(() {});
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        // ignore: avoid_print
        print(resposne["Data"]);

        globals.Logistic_global_User_Id =
            jsonDecode(response.body)['Data'][0]['USER_ID'].toString();
        globals.Login_User_Name =
            jsonDecode(response.body)['Data'][0]['EMP_NAME'].toString();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LogisticDashboard()));
      } else {
        logisticLoginError();
      }
    }

    return Scaffold(
        body: Container(
      width: double.infinity,
      color: const Color(0xff123456),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome to Logistics",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60))),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        height: 100.0,
                        width: 90.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/logisticsbackground.png"),
                                fit: BoxFit.fitWidth)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(95, 213, 228, 231),
                            ),
                            // BorderSide(
                            //     Color.fromARGB(255, 247, 247, 248)8, 238)),
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(255, 229, 228, 233),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color.fromARGB(43, 0, 0, 0)))),
                              child: TextField(
                                controller: userNameController,
                                decoration: const InputDecoration(
                                    hintText: "Enter UserName",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  // border: Border(
                                  //     bottom: BorderSide(
                                  //         color: Color.fromARGB(
                                  //             255, 238, 238, 238)))
                                  ),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: "Enter Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          if (userNameController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter UserName",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    const Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (passwordController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Password",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    const Color.fromARGB(232, 243, 49, 24),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            logisticAppLogin(userNameController.text,
                                passwordController.text, context);
                          }
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 70),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xff123456)),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                        child: Text(
                            'Powered by \u00a9 Suvarna Technosoft Pvt Ltd.'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

logisticLoginError() {
  return Fluttertoast.showToast(
      msg: "Invalid UserName and Password",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
