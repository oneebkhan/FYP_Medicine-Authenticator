import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MedicineInfo extends StatefulWidget {
  final String medicineName;
  final List<String> imageUrls;
  final String description;
  final int price;
  final String quantity;
  final bool authenticity;
  final String barcode;
  final List<String> sideEffects;
  final List<String> distributors;
  final List<String> pharmacies;
  final String company;
  final List<String> use;
  final String dose;

  MedicineInfo({
    Key key,
    this.medicineName,
    this.imageUrls,
    this.description,
    this.price,
    this.quantity,
    this.authenticity,
    this.barcode,
    this.sideEffects,
    this.distributors,
    this.pharmacies,
    this.company,
    this.use,
    this.dose,
  }) : super(key: key);

  @override
  _MedicineInfoState createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  double width;
  double height;
  double safePadding;
  //opacity of the normal text
  double opac;
  //opacity of the image;
  double opac2;
  int index;

  var page = PageController();
  var page2 = PageController();

  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    index = 0;

    Future.delayed(Duration(milliseconds: 300), () {
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

  //
  //
  // These two functions make the page scroll up even when the page has a singlechildscrollview
  _scrollUp() async {
    await page.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  _scrollDown() async {
    await page.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    page2 = PageController(initialPage: 0);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.compare_arrows_rounded),
        onPressed: () {
          if (index == 1) {
            page.previousPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            page.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: page,
        children: [
          Stack(
            children: [
              //
              //
              // The image behind the info
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: opac,
                child: PageView(
                  controller: page2,
                  onPageChanged: (i) {
                    setState(() {
                      index = i;
                    });
                  },
                  children: [
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.fitWidth,
                          image: CachedNetworkImageProvider(
                            'https://i-cf5.gskstatic.com/content/dam/cf-consumer-healthcare/panadol/en_ie/ireland-products/panadol-tablets/MGK5158-GSK-Panadol-Tablets-455x455.png?auto=format',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.fitWidth,
                          image: CachedNetworkImageProvider(
                            'https://pentagonenterprises.com/wp-content/uploads/2020/11/panadol-600x600.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //
              //
              // The top page info
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: opac2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Panadol',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width / 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            width: 15,
                          ),
                          //
                          //
                          // The Green tick for medicine authentication
                          Container(
                            child: Icon(
                              Icons.check_circle,
                              size: width / 13,
                              color: Color.fromARGB(255, 130, 255, 159),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //
                      //
                      // indicator of the number of pictures
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 10,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: (2),
                            itemBuilder: (BuildContext context, int ind) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  margin: EdgeInsets.all(0),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == ind
                                        ? Colors.blue[200]
                                        : Colors.grey[700],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. 100/500mg Leaf',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doses:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '500/1000 mg',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: width / 7,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //
          //
          // function to allow for scroll in the single child scroll view
          NotificationListener(
            onNotification: (notification) {
              if (notification is OverscrollNotification) {
                if (notification.overscroll > 0) {
                  _scrollDown();
                } else {
                  _scrollUp();
                }
              }
            },
            //
            //
            // The bottom page info
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'A simple pain relief medicine meant to be taken with water. Can cure headaches or body aches with relative ease. Meant to be taken after a meal, the usual dosage being 2 tablets of 500mg for an average adult.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Company Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'GSK, Pakistan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Distributors',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'GSK, Pakistan\nGSK, Pakistan\nGSK, Pakistan\nGSK, Pakistan\nGSK, Pakistan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pharmacies with Medicine',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'GSK, Pakistan\nGSK, Pakistan\nGSK, Pakistan\nGSK, Pakistan\nGSK, Pakistan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //
                      //
                      // To be removed if there is no barcode search
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width / 2.3,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Barcode Number',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'ABC25678-421',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: width / 2.3,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 104, 204, 127),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: width / 7,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Medicine is Authentic',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uses',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Panadol can be used for relieving fever and/or for the treatment of mild to moderate pain including headache, migraine, muscle ache, dysmenorrhea, sore throat, musculoskeletal pain and pain after dental procedures/ tooth extraction, toothache and pain of osteoarthritis.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 50, 50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Side Effects',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Nausea, vomiting, stomach upset, trouble falling asleep, or a shaky/nervous feeling may occur.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width / 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
