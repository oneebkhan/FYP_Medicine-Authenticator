import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Tips extends StatefulWidget {
  Tips({Key key}) : super(key: key);

  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  var width;
  var height;
  //opacity of the background
  double opac;
  //opacity of the image;
  double opac2;
  //The index of the pages
  int index;

  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    index = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        opac2 = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var page = PageController(initialPage: 0);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 248, 252, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            //
            //
            // The backdrop
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: opac,
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/tipsBackground.png'),
                  ),
                ),
              ),
            ),
            //
            //
            // Rest of the page
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: opac2,
              child: Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: height / 30,
                    ),
                    //
                    //
                    // The top Image adn text that needs to be changed
                    Flexible(
                      child: PageView(
                        controller: page,
                        onPageChanged: (i) {
                          setState(() {
                            index = i;
                          });
                        },
                        children: [
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height / 3.2,
                                  child: Lottie.asset(
                                    'assets/lottie/phone.json',
                                    repeat: true,
                                  ),
                                ),
                                SizedBox(
                                  height: width / 5,
                                ),
                                //
                                //
                                // The title text
                                Container(
                                  child: Text(
                                    'Tips',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //
                                //
                                // The explanation text
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Container(
                                    child: Text(
                                      'The application here is meant to make your medicine buying experience easier. Since there are a lot of counterfeit medicine circling around, the app helps you avoid getting fooled. Take special care of the following tips:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: height / 60,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          //
                          // The second page
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height / 2.8,
                                  child: Lottie.asset(
                                    'assets/lottie/medicine_bottle.json',
                                    repeat: true,
                                  ),
                                ),
                                SizedBox(
                                  height: width / 8,
                                ),
                                //
                                //
                                // The title text
                                Container(
                                  child: Text(
                                    'Sealed Bottle Cap',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //
                                //
                                // The explanation text
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Container(
                                    child: Text(
                                      'Make sure the bottle cap of any bottled medicine is sealed. No burn or melted marks can be seen near the bottle cap',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: height / 60,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          //
                          // The third page
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height / 3.2,
                                  child: Lottie.asset(
                                    'assets/lottie/proper_doctor.json',
                                    repeat: true,
                                  ),
                                ),
                                SizedBox(
                                  height: width / 8,
                                ),
                                //
                                //
                                // The title text
                                Container(
                                  child: Text(
                                    'Consult a Professional',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //
                                //
                                // The explanation text
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Container(
                                    child: Text(
                                      'Always make sure to consult a professional when asking for medicine. Make sure the pharmacy you buy medicine from is trusted and has a certificate from a known health authority. Additionaly make sure that the doctor you consult for a prescription also has an active license',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: height / 60,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          //
                          // Fourth tips page
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: height / 2.8,
                                  child: Lottie.asset(
                                    'assets/lottie/phone_use.json',
                                    repeat: true,
                                  ),
                                ),
                                SizedBox(
                                  height: width / 9,
                                ),
                                //
                                //
                                // The title text
                                Container(
                                  child: Text(
                                    'Read Medicine Info',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height / 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //
                                //
                                // The explanation text
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Container(
                                    child: Text(
                                      'Reading the medicine information after scanning can help you identify fake medicine. For example, reading the pharmacy distributed to can help identify where this medicine was supposed to be found. If the medicine was purchased at another pharmacy, the medicine is most probably fake',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: height / 60,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    //
                    // The bottom ROW BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //
                        //
                        // the previous page button
                        IconButton(
                          icon: index == 0
                              ? Container()
                              : Icon(
                                  Icons.arrow_back_ios_outlined,
                                ),
                          onPressed: () {
                            print(page.page);
                            if (index > 0) {
                              page.previousPage(
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeIn);
                              setState(() {
                                index--;
                              });
                            }
                          },
                        ),
                        SizedBox(width: width / 4.5),
                        //
                        //
                        // Grey index indicator
                        GestureDetector(
                          onTap: () {
                            page.animateToPage(0,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.bounceInOut);
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? Color.fromARGB(255, 149, 192, 255)
                                  : Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 25,
                        ),
                        //
                        //
                        // Grey index indicator
                        GestureDetector(
                          onTap: () {
                            page.animateToPage(1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.bounceInOut);
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? Color.fromARGB(255, 149, 192, 255)
                                  : Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 25,
                        ),
                        //
                        //
                        // Grey index indicator
                        GestureDetector(
                          onTap: () {
                            page.animateToPage(2,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.bounceInOut);
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: index == 2
                                  ? Color.fromARGB(255, 149, 192, 255)
                                  : Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 25,
                        ),
                        //
                        //
                        // Grey index indicator
                        GestureDetector(
                          onTap: () {
                            page.animateToPage(3,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.bounceInOut);
                            setState(() {
                              index = 3;
                            });
                          },
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: index == 3
                                  ? Color.fromARGB(255, 149, 192, 255)
                                  : Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: width / 4.5),
                        //
                        //
                        // the next page button
                        IconButton(
                          icon: index == 3
                              ? Container()
                              : Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                          onPressed: () {
                            if (index < 3) {
                              page.nextPage(
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeIn);
                            }
                            print(page.page);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width / 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
