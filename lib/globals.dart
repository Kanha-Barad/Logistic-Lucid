import 'package:shared_preferences/shared_preferences.dart';

String CompletedAreaID = "";
var CompleteddataLastIndex = null;
String CompletedTimeAreaLocartion = "";
//1
//4
//Server=103.145.36.186;User id=himsdev;Password=suvarna@123;Database=UAT_LUCID_LIMS
String Connection_String = "1";
String Global_Api_URL = 'https://portal.luciddiagnostics.com/logisticapi/';

String LocationSubmitShiftFromTimeStart = "";
String LocationSubmitShiftTotimeEnd = "";
String Login_User_Name = "";
var Logistic_Global_Route_Area = null;
String Logistic_global_User_Id = "";
String ReachedTimeAreaLocation = "";
var ShowReachedCompletedStartedData = null;
String StartAreaTime = "";
String StartTimeAreaLocation = "";
String Submit_Location_Name = "";
String SubmitLocationID = "";
var SubmitteddataLastIndex = null;
int SubmitTotalSamples = 0;

String pendingTripShiftId = "";

String Total_SampleColectedByArea = "";
var TRFImgPath = null;


late SharedPreferences logindata;

void main() async {
  logindata = await SharedPreferences.getInstance();
  // runApp(new MyApp());
}

var selectedLogin_Data = "";