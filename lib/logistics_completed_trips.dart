import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './logistics_dashBoard.dart';
import 'package:http/http.dart' as http;
import 'Logistics_Pending_Trips.dart';
import 'globals.dart' as globals;

var cMPROUTEMAPID = "";
var cMPROUTESHIFTID = "";
var cMPROUTENAME = "";
TextEditingController submitRemarksController = TextEditingController();
TextEditingController recievedByController = TextEditingController();
TextEditingController recievedSamplesController = TextEditingController();

class CompletedTripsSubmit extends StatefulWidget {
  CompletedTripsSubmit(cMPRouteMapID, cMPRouteShiftID, cMPRouteName) {
    cMPROUTEMAPID = "";
    cMPROUTESHIFTID = "";
    cMPROUTENAME = "";
    cMPROUTEMAPID = cMPRouteMapID;
    cMPROUTESHIFTID = cMPRouteShiftID;
    cMPROUTENAME = cMPRouteName;
  }

  @override
  State<CompletedTripsSubmit> createState() => _CompletedTripsSubmitState();
}

class _CompletedTripsSubmitState extends State<CompletedTripsSubmit> {
  @override
  Widget build(BuildContext context) {
    Future<List<CompletedTripsModels>> _fetchCompletedTrips() async {
      Uri jobsListAPIUrl;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_ROUTE_ID": cMPROUTEMAPID,
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_SESSION_ID": "1",
        "IP_FLAG": "C",
        "IP_TRIP_SHIFT_ID": cMPROUTESHIFTID,
        "connection": globals.Connection_String
      };
      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.Global_Api_URL + '/Logistics/Routeareas');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonresponse = jsonDecode(response.body);
        // ignore: avoid_print
        print(jsonresponse.containsKey('Data'));
        listresponse = jsonresponse[dsetName];
        globals.CompleteddataLastIndex = jsonDecode(response.body)["Data"];

        return listresponse
            .map((smbtrans) => CompletedTripsModels.fromJson(smbtrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget completedTripsData = FutureBuilder<List<CompletedTripsModels>>(
        future: _fetchCompletedTrips(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (snapshot.data!.isEmpty == true) {
              return const NoContent();
            } else {
              return CompletedTripsDetailsList(data, context);
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
              child: CircularProgressIndicator(
            strokeWidth: 4.0,
          ));
        });

    submitCenterLocationData(BuildContext context) async {
      Map data = {
        "IP_SAMPLES": globals.SubmitTotalSamples.toString(),
        "IP_LOCATION_ID": globals.SubmitLocationID.toString(),
        "IP_REMARKS": submitRemarksController.text.toString(),
        "IP_USER_ID": globals.Logistic_global_User_Id,
        "IP_TRIP_ID": cMPROUTESHIFTID.toString(),
        "IP_RECEIVED_SAMPLES": recievedSamplesController.text.toString(),
        "IP_RECEIVER_NAME": recievedByController.text.toString(),
        "IP_SHIFT_FROM": "",
        "IP_SHIFT_TO": "",
        "connection": globals.Connection_String
      };

      final response = await http.post(
          Uri.parse(globals.Global_Api_URL + '/Logistics/Submitsamples'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        // ignore: avoid_print
        print(resposne["Data"]);
        Map<String, dynamic> user = resposne['Data'][0];

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LogisticDashboard()));
        sUBmitLocationSampleSuccess();
        globals.SubmitTotalSamples = 0;
        globals.SubmitLocationID = "";
        submitRemarksController.text = "";
        recievedByController.text = "";
        recievedSamplesController.text = "";
      } else {
        sUBmitLocationSamplefailed();
      }
    }

    final sUBmitBottomBar = InkWell(
      onTap: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    //  title: const Text('Ordered Sucessfully'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                              child: Card(
                                  elevation: 1.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 219, 218, 218))),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2),
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                image: AssetImage(
                                                    "assets/MapTrackImg.png"),
                                                fit: BoxFit.cover,
                                              ))),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            elevation: 5,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 8, 0, 0),
                                              child: Row(
                                                children: [
                                                  Text(cMPROUTENAME,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 0, 2),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                      "Samples Collected : ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30),
                                                    child: SizedBox(
                                                      height: 25,
                                                      width: 35,
                                                      child: Card(
                                                        elevation: 3.0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        color:
                                                            Colors.green[400],
                                                        child: Center(
                                                          child: Text(
                                                              globals.SubmitTotalSamples
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 5, 0, 4),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "To be Submitted : " +
                                                          globals
                                                              .Submit_Location_Name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]))),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: Row(
                              children: [
                                Row(children: [
                                  const Text("Received Samples : ",
                                      style: TextStyle(fontSize: 14)),
                                  SizedBox(
                                      width: 115,
                                      child: TextFormField(
                                        controller: recievedSamplesController,
                                        decoration: const InputDecoration(
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ))
                                ]),
                              ],
                            ),
                          ),
                          Row(children: [
                            const Text("Received By : ",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                                width: 150,
                                child: TextFormField(
                                  controller: recievedByController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ))
                          ]),
                          Row(
                            children: [
                              Row(children: [
                                const Text("Remarks : ",
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(
                                    width: 170,
                                    child: TextFormField(
                                      controller: submitRemarksController,
                                      decoration: const InputDecoration(
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ))
                              ]),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: SizedBox(
                                          height: 37,
                                          width: 80,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 76, 127, 168))),
                                            color: const Color.fromARGB(
                                                255, 213, 218, 223),
                                            child: const Center(
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (recievedSamplesController.text
                                                .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Enetr the Samples",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (recievedByController.text
                                                .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Enetr the Reciever",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else if (submitRemarksController.text
                                                .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                              msg: "Please Enetr the Remarks",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 238, 26, 11),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          submitCenterLocationData(context);
                                        }
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: 60,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 222, 227, 231))),
                                          color: const Color(0xff123456),
                                          child: const Center(
                                            child: Text("Ok",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]))
                        ]));
              });
            });
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
              Color.fromARGB(255, 229, 228, 233),
              Color.fromARGB(255, 229, 229, 231),
              // Color.fromARGB(255, 233, 233, 235)
            ])),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SizedBox(
              height: 50,
              child: Card(
                  color: const Color(0xff123456),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )))),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff123456),
        title: Text(cMPROUTENAME,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        bottomOpacity: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: completedTripsData),
      bottomNavigationBar: sUBmitBottomBar,
    );
  }
}

class CompletedTripsModels {
  final Comp_Area_ID;
  final Comp_AREA_Name;
  final Comp_Total_Samples;
  final Comp_Start_DT;
  final Comp_Accept_DT;
  final Comp_Reached_DT;
  final Comp_Reject_DT;
  final Comp_Longitude;
  final Comp_Latitude;
  final Comp_Trip_Shift_ID;
  final Comp_Remarks;
  final Comp_TRF_NO;
  final Comp_Completed_DT;

  CompletedTripsModels(
      {required this.Comp_Area_ID,
      required this.Comp_AREA_Name,
      required this.Comp_Total_Samples,
      required this.Comp_Start_DT,
      required this.Comp_Accept_DT,
      required this.Comp_Reached_DT,
      required this.Comp_Reject_DT,
      required this.Comp_Longitude,
      required this.Comp_Latitude,
      required this.Comp_Trip_Shift_ID,
      required this.Comp_Remarks,
      required this.Comp_TRF_NO,
      required this.Comp_Completed_DT});
  factory CompletedTripsModels.fromJson(Map<String, dynamic> json) {
    print(json);
    return CompletedTripsModels(
        Comp_Area_ID: json["AREA_ID"].toString(),
        Comp_AREA_Name: json["AREA_NAME"].toString(),
        Comp_Total_Samples: json["TOTAL_SAMPLES"].toString(),
        Comp_Start_DT: json["START_DT"].toString(),
        Comp_Accept_DT: json["ACCEPT_DT"].toString(),
        Comp_Reached_DT: json["REACHED_DT"].toString(),
        Comp_Reject_DT: json["REJECT_DT"].toString(),
        Comp_Longitude: json["LONGITUDE"].toString(),
        Comp_Latitude: json["LATTITUDE"].toString(),
        Comp_Trip_Shift_ID: json["TRIP_SHIFT_ID"].toString(),
        Comp_Remarks: json["REMARKS"].toString(),
        Comp_TRF_NO: json["TRF_NO"].toString(),
        Comp_Completed_DT: json["COMPLETED_DT"].toString());
  }
}

Widget CompletedTripsDetailsList(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildCompletedTrips(data[index], context, index);
      });
}

Widget _buildCompletedTrips(data, BuildContext context, int index) {
  return GestureDetector(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Color.fromARGB(68, 160, 144, 144))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                      height: 35,
                      width: 300,
                      child: Card(
                          color: Colors.grey[200],
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Color.fromARGB(68, 160, 144, 144))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 3, 0, 3),
                            child: Row(children: [
                              const Icon(
                                Icons.location_pin,
                                size: 22,
                                color: Color.fromARGB(255, 24, 167, 114),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(data.Comp_AREA_Name,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                            ]),
                          )))
                ]),
              ),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Reached :",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Reached_DT,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500))
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Completed : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Completed_DT,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500))
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != globals.CompleteddataLastIndex.length - 1)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text(
                            "Start : ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            data.Comp_Start_DT,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? const Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 1,
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Collected Samples : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Total_Samples,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        children: [
                          const Text("Remarks : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_Remarks,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (index != 0)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 8),
                      child: Row(
                        children: [
                          const Text("TRF NO : ",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(data.Comp_TRF_NO,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    ),
  );
}

sUBmitLocationSampleSuccess() {
  return Fluttertoast.showToast(
      msg: "Saved Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 72, 201, 105),
      textColor: Colors.white,
      fontSize: 16.0);
}

sUBmitLocationSamplefailed() {
  return Fluttertoast.showToast(
      msg: "Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
