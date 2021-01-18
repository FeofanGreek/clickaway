
import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


import 'package:url_launcher/url_launcher.dart';

import 'package:share/share.dart';

import 'main.dart';

//селектор
//SfRangeValues _values1 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
//SfRangeValues _values2 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
//SfRangeValues _values3 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
//SfRangeValues _values4 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
//SfRangeValues _values5 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
//SfRangeValues _values6 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
//SfRangeValues _values7 = SfRangeValues(DateTime(2000, 01, 01, 10, 00, 00), DateTime(2000, 01, 01, 19, 00, 00));
RangeValues _values7 = const RangeValues(10, 19);
RangeValues _values6 = const RangeValues(10, 19);
RangeValues _values5 = const RangeValues(10, 19);
RangeValues _values4 = const RangeValues(10, 19);
RangeValues _values3 = const RangeValues(10, 19);
RangeValues _values2 = const RangeValues(10, 19);
RangeValues _values1 = const RangeValues(10, 19);
//RangeValues timeForCustomer = const RangeValues(20, 40);
double timeForCustomer = 10.0;
//селектор



String text = 'https://koldashev.ru'; // делиться ссылкой
String subject = 'Free ClickAway for friends'; // делиться ссылкой
//для файрбейз
FirebaseMessaging _fcm = FirebaseMessaging();
StreamSubscription iosSubscription;
bool isSwitched = false;
bool firstDay = false;
bool secondDay = false;
bool threeDay = false;
bool foreDay = false;
bool fiveDay = false;
bool sixDay = false;
bool sevenDay = false;


readProfile() async {
  FirebaseMessaging _fcm = FirebaseMessaging();
  token = await _fcm.getToken();
}



class profileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<profileScreen> {
  var _controllerSearchPhone = TextEditingController();
  TextEditingController _controllerShopName, _controllerShopPhone, _controllerShopAddress, _controllerShopTheme ;
  TextEditingController _controllerCustomerName, _controllerCustomerPhone, _controllerCustomerAddress;
  var maskFormatterPhone = new MaskTextInputFormatter(mask: '+## (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState(){

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      _fcm.configure();
    }

    Firebase.initializeApp().whenComplete(() {
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar: AppBar(
        elevation: 0.0,
        title: Image.asset('clickaway.png', height: 50, fit: BoxFit.fill),
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
                    CupertinoPageRoute(builder: (context) => MainScreen()));
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.home, size: 18.0,
                      color: Colors.black), // icon
                  Text("Home", style: TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,), // text
                ],
              ),
            ),
          ),
        ),
        //кнопка перехода в управление заказами если партнерский код комплит
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                    Icon(Icons.ios_share, size: 18.0, color: Colors.black),
                    // icon
                    Text("Share", style: TextStyle(color: Colors.black87)),
                    // text
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),

          child: Center(
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Покупатель",
                      style: TextStyle(color: !isSwitched?Colors.black87:Colors.white),
                      textAlign: TextAlign.center,),
                        Switch(
                          value: isSwitched,
                          onChanged: (value){
                            setState(() {
                              isSwitched=value;
                              //print(isSwitched);
                            });
                          },
                          activeTrackColor: Colors.grey,
                          inactiveTrackColor: Colors.grey,
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.green,
                        ),
                    Text("Продавец",
                      style: TextStyle(color: isSwitched?Colors.black87:Colors.white),
                      textAlign: TextAlign.center,),
                    ]),
                    isSwitched?Column(
                     children: <Widget>[
                    SizedBox(height: 20.0),
                    Text("Информация о магазине",
                      style: TextStyle(fontSize: 20.0,color: Colors.black87),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 20.0),
                    Container(
                        child: TextFormField(
                            //initialValue: "Название магазина",
                            maxLines: 1,
                            decoration: InputDecoration(hintText: "Название", focusedBorder: OutlineInputBorder(
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
                            ),),
                            // ignore: deprecated_member_use
                            onChanged: (value){}),
                        padding: EdgeInsets.fromLTRB(40,10,40,5)
                    ),
                       Container(
                           child: TextFormField(
                             //initialValue: "Адрес магазина",
                               maxLines: 3,
                               decoration: InputDecoration(hintText: "Что продаете",
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                   borderSide: BorderSide(
                                     color: Colors.blue,
                                   ),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                   borderSide: BorderSide(
                                     color: Colors.grey,
                                     width: 1.0,
                                   ),
                                 ),),
                               // ignore: deprecated_member_use
                               onChanged: (value){}),
                           padding: EdgeInsets.fromLTRB(40,10,40,5)
                       ),

                    Container(
                      child: TextFormField(
                      //initialValue: "Адрес магазина",
                      maxLines: 3,
                      decoration: InputDecoration(hintText: "Адрес и почтовый код",
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                        color: Colors.blue,
                        ),
                      ),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                        color: Colors.grey,
                       width: 1.0,
                        ),
                      ),),
                      // ignore: deprecated_member_use
                      onChanged: (value){}),
                      padding: EdgeInsets.fromLTRB(40,10,40,5)
                    ),

                    Container(
                        padding: EdgeInsets.fromLTRB(40,10,40,5),
                    //margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                      child: TextFormField(
                        enabled: true,
                        inputFormatters: [maskFormatterPhone],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                        hintText: "Τηλεφωνικό νούμερο",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                            enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        suffixIcon: IconButton(
                        onPressed: () => _controllerSearchPhone.clear(),
                          icon: Icon(Icons.clear),
                          ),
                        ),
                        /*validator: (value) {
                        if (value.isEmpty) {
                          return 'Ξεκινήστε να εισάγετε τον αριθμό τηλεφώνου του επιθυμητού καταστήματος';
                          }
                          return null;
                        },*/
                        onChanged: (value) {
                        if ((value.length > 16) & (value.length < 19)) {
                        //функция поиска без опций администрирования
                        //searchStaff(value);
                          }
                        },
                        // ignore: deprecated_member_use
                        autovalidate: true,
                        controller: _controllerSearchPhone,
                      ),

                    ),
                    SizedBox(height: 30.0),
                    Text("Время работы",
                      style: TextStyle(fontSize: 20.0,color: Colors.black87),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 10.0),
                       Container(
                           margin: EdgeInsets.fromLTRB(5,5,5,10),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(7.0),
                             color: Colors.white,
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.withOpacity(0.5),
                                 spreadRadius: 5,
                                 blurRadius: 7,
                                 offset: Offset(0, 3), // changes position of shadow
                               ),
                             ],
                           ),
                           child:Column(
                               children: <Widget>[
                       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Δευτέρα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.right,),

                             firstDay?Text(" απο ${_values1.start.round().toString()} ορα ως ${_values1.end.round().toString()} ορα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,):Text(" не работает",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,),
                             Switch(
                               value: firstDay,
                               onChanged: (value){
                                 setState(() {
                                   firstDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                           ]),
                       firstDay?
                       RangeSlider(
                         values: _values1,
                         min: 7,
                         max: 21,
                         divisions: 13,
                         labels: RangeLabels(
                           _values1.start.round().toString(),
                           _values1.end.round().toString(),
                         ),
                         onChanged: (RangeValues values) {
                           setState(() {
                             _values1 = values;
                           });
                         },
                       ):Container(),
                      ])),
                       Container(
                         margin: EdgeInsets.fromLTRB(5,5,5,10),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.0),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: Offset(0, 3), // changes position of shadow
                             ),
                           ],
                         ),
                         child:Column(
                             children: <Widget>[
                       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Τετάρτη",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.right,),

                             secondDay?Text(" απο ${_values2.start.round().toString()} ορα ως ${_values2.end.round().toString()} ορα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,):Text(" не работает",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,),
                             Switch(
                               value: secondDay,
                               onChanged: (value){
                                 setState(() {
                                   secondDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                           ]),
                       secondDay?
                       RangeSlider(
                         values: _values2,
                         min: 7,
                         max: 21,
                         divisions: 13,
                         labels: RangeLabels(
                           _values2.start.round().toString(),
                           _values2.end.round().toString(),
                         ),
                         onChanged: (RangeValues values) {
                           setState(() {
                             _values2 = values;
                           });
                         },
                       ):Container(),
                    ])),
                       Container(
                         margin: EdgeInsets.fromLTRB(5,5,5,10),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.0),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: Offset(0, 3), // changes position of shadow
                             ),
                           ],
                         ),
                         child:Column(
                             children: <Widget>[
                       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Πέμπτη",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.right,),

                             threeDay?Text(" απο ${_values3.start.round().toString()} ορα ως ${_values3.end.round().toString()} ορα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,):Text(" не работает",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,),
                             Switch(
                               value: threeDay,
                               onChanged: (value){
                                 setState(() {
                                   threeDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                           ]),
                       threeDay?
                       RangeSlider(
                         values: _values3,
                         min: 7,
                         max: 21,
                         divisions: 13,
                         labels: RangeLabels(
                           _values3.start.round().toString(),
                           _values3.end.round().toString(),
                         ),
                         onChanged: (RangeValues values) {
                           setState(() {
                             _values3 = values;
                           });
                         },
                       ):Container(),
                      ])),
                       Container(
                         margin: EdgeInsets.fromLTRB(5,5,5,10),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.0),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: Offset(0, 3), // changes position of shadow
                             ),
                           ],
                         ),
                         child:Column(
                             children: <Widget>[
                       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Πέμπτη",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.right,),

                             foreDay?Text(" απο ${_values4.start.round().toString()} ορα ως ${_values4.end.round().toString()} ορα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,):Text(" не работает",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,),
                             Switch(
                               value: foreDay,
                               onChanged: (value){
                                 setState(() {
                                   foreDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                           ]),
                       foreDay?
                       RangeSlider(
                         values: _values4,
                         min: 7,
                         max: 21,
                         divisions: 13,
                         labels: RangeLabels(
                           _values4.start.round().toString(),
                           _values4.end.round().toString(),
                         ),
                         onChanged: (RangeValues values) {
                           setState(() {
                             _values4 = values;
                           });
                         },
                       ):Container(),
                       ])),
                       Container(
                         margin: EdgeInsets.fromLTRB(5,5,5,10),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.0),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: Offset(0, 3), // changes position of shadow
                             ),
                           ],
                         ),
                         child:Column(
                             children: <Widget>[
                       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Παρασκευή",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.right,),

                             fiveDay?Text(" απο ${_values5.start.round().toString()} ορα ως ${_values5.end.round().toString()} ορα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,):Text(" не работает",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,),
                             Switch(
                               value: fiveDay,
                               onChanged: (value){
                                 setState(() {
                                   fiveDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                           ]),
                       fiveDay?
                       RangeSlider(
                         values: _values5,
                         min: 7,
                         max: 21,
                         divisions: 13,
                         labels: RangeLabels(
                           _values5.start.round().toString(),
                           _values5.end.round().toString(),
                         ),
                         onChanged: (RangeValues values) {
                           setState(() {
                             _values5 = values;
                           });
                         },
                       ):Container(),
                       ])),
                       Container(
                         margin: EdgeInsets.fromLTRB(5,5,5,10),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.0),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: Offset(0, 3), // changes position of shadow
                             ),
                           ],
                         ),
                         child:Column(
                             children: <Widget>[
                       Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Σάββατο",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.right,),

                             sixDay?Text(" απο ${_values6.start.round().toString()} ορα ως ${_values6.end.round().toString()} ορα",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,):Text(" не работает",
                               style: TextStyle(color: Colors.black87),
                               textAlign: TextAlign.left,),
                             Switch(
                               value: sixDay,
                               onChanged: (value){
                                 setState(() {
                                   sixDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                           ]),
                       sixDay?
                       RangeSlider(
                         values: _values6,
                         min: 7,
                         max: 21,
                         divisions: 13,
                         labels: RangeLabels(
                           _values6.start.round().toString(),
                           _values6.end.round().toString(),
                         ),
                         onChanged: (RangeValues values) {
                           setState(() {
                             _values6 = values;
                           });
                         },
                       ):Container(),
                       ])),
                       Container(
                         margin: EdgeInsets.fromLTRB(5,5,5,10),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.0),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: Offset(0, 3), // changes position of shadow
                             ),
                           ],
                         ),
                         child:Column(
                             children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                       Text("Κυριακή",
                         style: TextStyle(color: Colors.black87),
                         textAlign: TextAlign.right,),

                 sevenDay?Text(" απο ${_values7.start.round().toString()} ορα ως ${_values7.end.round().toString()} ορα",
                         style: TextStyle(color: Colors.black87),
                         textAlign: TextAlign.left,):Text(" не работает",
                   style: TextStyle(color: Colors.black87),
                   textAlign: TextAlign.left,),
                           Switch(
                               value: sevenDay,
                               onChanged: (value){
                                 setState(() {
                                   sevenDay=value;
                                 });
                               },
                               activeTrackColor: Colors.grey,
                               inactiveTrackColor: Colors.grey,
                               activeColor: Colors.blue,
                               inactiveThumbColor: Colors.green,
                             ),
                       ]),
                       sevenDay?
                       RangeSlider(
                               values: _values7,
                               min: 7,
                               max: 21,
                               divisions: 13,
                               labels: RangeLabels(
                                 _values7.start.round().toString(),
                                 _values7.end.round().toString(),
                               ),
                               onChanged: (RangeValues values) {
                                 setState(() {
                                   _values7 = values;
                                 });
                               },
                        ):Container(),
                      ])),

                    SizedBox(height: 30.0),
                       Text("Время на одного покупателя " + timeForCustomer.round().toString() + ' minute',
                         style: TextStyle(fontSize: 20.0,color: Colors.black87),
                         textAlign: TextAlign.center,),

                       SliderTheme(
                         data: SliderTheme.of(context).copyWith(
                           activeTrackColor: timeForCustomer<30?Colors.green:timeForCustomer<50?Colors.orange:Colors.red,
                           inactiveTrackColor: timeForCustomer<30?Colors.green:timeForCustomer<50?Colors.orange:Colors.red,
                           trackShape: RoundedRectSliderTrackShape(),
                           trackHeight: 4.0,
                           thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                           thumbColor: timeForCustomer<30?Colors.green:timeForCustomer<50?Colors.orange:Colors.red,
                           overlayColor: timeForCustomer<30?Colors.green.withAlpha(32):timeForCustomer<50?Colors.orange.withAlpha(32):Colors.red.withAlpha(32),
                           overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                           tickMarkShape: RoundSliderTickMarkShape(),
                           activeTickMarkColor: Colors.white,
                           inactiveTickMarkColor: Colors.white,
                           valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                           valueIndicatorColor: timeForCustomer<30?Colors.green:timeForCustomer<50?Colors.orange:Colors.red,
                           valueIndicatorTextStyle: TextStyle(
                             color: Colors.white,
                           ),
                         ),
                         child: Slider(
                           value: timeForCustomer,
                           min: 10,
                           max: 60,
                           divisions: 5,
                           label: timeForCustomer.round().toString()+' min',
                           onChanged: (value) {
                             setState(
                                   () {
                                     timeForCustomer = value;
                               },
                             );
                           },
                         ),
                       ),

                    SizedBox(height: 30.0),
                   ]):Column(
                      children: <Widget>[
                      SizedBox(height: 20.0),
                      Text("Информация о Вас",
                      style: TextStyle(fontSize: 20.0,color: Colors.black87),
                      textAlign: TextAlign.center,),

                      Container(
                          child: TextFormField(
                              //initialValue: "Имя и Фамилия",
                              maxLines: 1,
                              decoration: InputDecoration(hintText: "Как вас зовут?", focusedBorder: OutlineInputBorder(
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
                              ),),
                              // ignore: deprecated_member_use
                              onChanged: (value){}),
                          padding: EdgeInsets.fromLTRB(40,10,40,5)
                      ),

                      Container(
                          child: TextFormField(
                              //initialValue: "Ваш адрес или почтовый код",
                              maxLines: 3,
                              decoration: InputDecoration(hintText: "Необходимо для отправки СМС на 13033",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),),
                              // ignore: deprecated_member_use
                              onChanged: (value){}),
                          padding: EdgeInsets.fromLTRB(40,10,40,5)
                      ),

                        Container(
                          padding: EdgeInsets.fromLTRB(40,10,40,5),
                          //margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                          child: TextFormField(
                            enabled: true,
                            inputFormatters: [maskFormatterPhone],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Τηλεφωνικό νούμερο",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => _controllerSearchPhone.clear(),
                                icon: Icon(Icons.clear),
                              ),
                            ),
                            /*validator: (value) {
                        if (value.isEmpty) {
                          return 'Ξεκινήστε να εισάγετε τον αριθμό τηλεφώνου του επιθυμητού καταστήματος';
                          }
                          return null;
                        },*/
                            onChanged: (value) {
                              if ((value.length > 16) & (value.length < 19)) {
                                //функция поиска без опций администрирования
                                //searchStaff(value);
                              }
                            },
                            // ignore: deprecated_member_use
                            autovalidate: true,
                            controller: _controllerSearchPhone,
                          ),

                        ),

                      SizedBox(height: 30.0),
                    ]),
                    RaisedButton.icon(
                      onPressed: (){},
                      icon: Icon(Icons.save),
                      label: Text("Сохранить"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.blue,
                      disabledTextColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(50,10,50,10),
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),

                    ),
                    Text("\n\n\n\n",
                      style: TextStyle(fontSize: 20.0,color: Colors.black87),
                      textAlign: TextAlign.center,),

                  ]
              )
          )
      ),

    );
  }}