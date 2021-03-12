import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddDistributor extends StatelessWidget {
  var width;
  var height;
  var safePadding;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    final node = FocusScope.of(context);
    var medName = TextEditingController();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 248),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.grey[700],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Distributor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 16,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ContainerText(
                            hint: 'Name',
                            node: node,
                            controller: medName,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ContainerText(
                            hint: 'Email',
                            node: node,
                            controller: medName,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ContainerText(
                            hint: 'Password',
                            node: node,
                            controller: medName,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ContainerText(
                            hint: 'Company Name',
                            node: node,
                            controller: medName,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ContainerText(
                            hint: 'Location',
                            node: node,
                            controller: medName,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: width / 1.1,
                    height: width / 8,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 149, 192, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerText extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final node;

  const ContainerText({Key key, this.controller, this.hint, this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        decoration: InputDecoration(
          fillColor: Colors.grey[200],
          hintText: hint,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey[200],
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey[200],
            ),
          ),
        ),
      ),
    );
  }
}
