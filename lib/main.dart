import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:simplifly/services/notification_service.dart';
import 'package:simplifly/screens/register.dart';
import 'package:simplifly/screens/chat_screen.dart';
import 'classes/introcls.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CarouselDemo());
}
final Widget placeholder = Container(color: Colors.grey);
final List<Intro> imgList = [
  new Intro('images/rotat1.png', 'Concur your fears'),
  new Intro('images/rotat2.png', 'Anticipate your anxiety'),
  new Intro('images/rotat3.png', 'We are here for you'),
];
final List child = map<Widget>(
  imgList,
  (index, Intro i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.asset(i.img, fit: BoxFit.fitHeight),
          Positioned(
            bottom: 0,
            left: 0.0,
            right: 0.0,
            child: Container(
              //  padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              child: Center(
                child: Text(
                  i.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  void initState()  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: child,
        autoPlay: true,
        //  enlargeCenterPage: true,
        aspectRatio: 0.92,
        viewportFraction: 0.88,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          imgList,
          (index, Intro url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 230, 159, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
    ]);
  }
}

class CarouselDemo extends StatelessWidget {
  NotificationScreen notificationScreen =NotificationScreen();


  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<String>(
        future: notificationScreen.configureFirebaseListeners(), // a previously-obtained Future<String> or null
        builder:(BuildContext context, AsyncSnapshot<String> snapshot) {
          return MaterialApp(
              title: 'demo',
              home: Scaffold(
                body: SafeArea(child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints constraints) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                color: Colors.white,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.11,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "SimliFly",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35),
                                  ),
                                )),
                            Expanded(
                                child: Container(
                                  color: Colors.white,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.7,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: CarouselWithIndicator(),
                                )),
                            Container(
                                color: Colors.white,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.15,
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    ButtonTheme(
                                      minWidth: double.infinity,
                                      child: RaisedButton(
                                        color: Color.fromRGBO(59, 65, 74, 100),
                                        onPressed: () {
                                          if (loggedInUser == null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Register()));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatScreen()));
                                          }
                                        },
                                        child: Text(
                                          'CREATE YOUR PROFILE',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    ButtonTheme(
                                      minWidth: double.infinity,
                                      child: RaisedButton(
                                        color: Color.fromRGBO(59, 65, 74, 100),
                                        onPressed: null,
                                        child: Text(
                                          'Already have an account? Login',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ]);
                    })),
              ));
        } );
  }
}
