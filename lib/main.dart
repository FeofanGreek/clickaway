
import 'package:click_away/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:share/share.dart';
import 'package:flutter_sms/flutter_sms.dart';

String text = 'https://koldashev.ru'; // делиться ссылкой
String subject = 'Free ClickAway for friends'; // делиться ссылкой
String token, _message, _canSendSMSMessage;

void main(){
  runApp(clickAway());
  readProfile();

}

readProfile() async {
  FirebaseMessaging _fcm = FirebaseMessaging();
  token = await _fcm.getToken();
}

class clickAway extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(title: ''),
    );
  }

}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();

}


class _MainScreenState extends State<MainScreen> {

  var _controllerSearchPhone = TextEditingController();
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+## (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState(){
    super.initState();
  }

  callClient(url) async {
    if (await canLaunch('tel://$url')) {
      await launch('tel://$url');
    } else {
      throw 'Невозможно набрать номер $url';
    }
    print('пробуем позвонить');  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar:AppBar(
        elevation: 0.0,
        title: Image.asset('clickaway.png',  height: 50, fit:BoxFit.fill),
        centerTitle: true,
        backgroundColor: Color(0xFFffffff),
        brightness: Brightness.light,
        leading: Container(
          child: Material(
            color: Colors.white, // button color
            child: InkWell(
              splashColor: Colors.green, // splash color
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => profileScreen()));
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_box_outlined, size: 18.0, color: Colors.black), // icon
                  Text("My profile", style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,), // text
                ],
              ),
            ),
          ),
        ), //кнопка перехода в управление заказами если партнерский код комплит
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0,0,10,0),
            child: Material(
              color: Colors.white, // button color
              child: InkWell(
                splashColor: Colors.green, // splash color
                onTap: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(text,
                        subject: subject,
                        sharePositionOrigin:
                        box.localToGlobal(Offset.zero) &
                        box.size);
                }, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.ios_share, size: 18.0, color: Colors.black), // icon
                    Text("Share", style: TextStyle(color: Colors.black87)), // text
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body:SingleChildScrollView(
          physics: ScrollPhysics(),

          child:Center(
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text("Αίτηση για επίσκεψη σε νέο κατάστημα", style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,),
                    SizedBox(height: 20.0),
                    //форма поиска
                    //при вводе номера по достижении 10 цифр искать и выводить список, его можно отредактить на условия
                    Container(
                      margin: EdgeInsets.fromLTRB(30,0,30,30),
                      child:TextFormField(
                        enabled: true,
                        inputFormatters: [maskFormatterPhone],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Τηλεφωνικό νούμερο",
                          suffixIcon: IconButton(
                            onPressed: () => _controllerSearchPhone.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ), enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),), validator: (value) {
                        if (value.isEmpty) {
                          return 'Ξεκινήστε να εισάγετε τον αριθμό τηλεφώνου του επιθυμητού καταστήματος';
                        }
                        return null;
                      },
                        onChanged: (value){
                          if((value.length>16) & (value.length<19)){
                            //функция поиска без опций администрирования
                            //searchStaff(value);
                          }
                        },
                        // ignore: deprecated_member_use
                        autovalidate: true,
                        controller: _controllerSearchPhone,
                      ),

                    ),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width - 80,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    //форма поиска
                    SizedBox(height: 20.0),
                    Text("Υποβλήθηκαν προηγούμενες αιτήσεις για επίσκεψη", style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,),
              RaisedButton.icon(
                  onPressed: () {
                    String message = "This is a test message!";
                    List<String> recipents = ["1234567890", "5556787676"];
                    _sendSMS(message, recipents);
                  },
                  icon: Icon(Icons.check), label: Text("Send SMS"),color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.blue,
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(10,10,10,10),
                  splashColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),

              ),]
                            )
                      )
              ),

    );
  }


  void _sendSMS(String message, List<String> recipents) async {
    try {
      String _result = await sendSMS(
          message: message, recipients: recipents);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
    print(_message);
  }

}




