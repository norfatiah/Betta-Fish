import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'detailscreen.dart';
import 'fish.dart';
import 'fishcartscreen.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List fishlist;
  double screenHeight, screenWidth;
  int quantity = 1;
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadFish();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Betta Fish Collection'),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _fishCartScreen();
          
        },
        icon: Icon(Icons.shopping_cart),
        label: Text("Cart"),
      ),
      body: Column(
        children: [
          Divider(color: Colors.green),
          fishlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: RefreshIndicator(
                      key: refreshKey,
                      color: Colors.red,
                      onRefresh: () async {
                        _loadFish();
                      },
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(fishlist.length, (index) {
                          return Padding(
                              padding: EdgeInsets.all(1),
                              child: Card(
                                  child: InkWell(
                                onTap: () => _loadFishDetail(index),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                              height: screenHeight / 4.5,
                                              width: screenWidth / 1.2,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "http://seriouslaa.com/bettafish//images/${fishlist[index]['fishimage']}.png",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth / 2,
                                                ),
                                              )),
                                          Positioned(
                                            child: Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        fishlist[index]
                                                            ['rating'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Icon(Icons.star,
                                                        color: Colors.black),
                                                  ],
                                                )),
                                            bottom: 10,
                                            right: 10,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        fishlist[index]['fishname'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "RM " + fishlist[index]['fishprice']),
                                    
                                      MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              minWidth: 100,
                                              height: 30,
                                              child: Text(
                                                'Add to Cart',
                                              ),
                                              color: Color.fromRGBO(
                                                  101, 255, 218, 50),
                                              textColor: Colors.black,
                                              elevation: 10,
                                              onPressed: () =>
                                                  _addtocartdialog(index),
                                            ),
                                    ],
                                  ),
                                ),
                              )));
                        }),
                      )))
        ],
      ),
    ));
  }

  Future<void> _loadFish() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("http://seriouslaa.com/bettafish/php/load_fish.php",
        body: {}).then((res) {
      if (res.body == "nodata") {
        fishlist = null;
        setState(() {
          titlecenter = "No Fish Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          fishlist = jsondata["fish"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadFishDetail(int index) {
    print(fishlist[index]['fishid']);
    Fish fish = new Fish(
      fishid: fishlist[index]['fishid'],
      fishname: fishlist[index]['fishname'],
      fishprice: fishlist[index]['fishprice'],
      fishqty: fishlist[index]['fishqrt'],
      fishimage: fishlist[index]['fishimage'],
      rating: fishlist[index]['rating'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(
                  fish: fish,
                )));
  }
  void _fishCartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                FishCartScreen(user: widget.user)));
  }

    _addtocartdialog(int index) {
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "You want add " + fishlist[index]['fishname'] + " to Cart?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please set quantity of fish",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(fishlist[index]['fishqrt']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )),
              ],
            );
          });
        });
  }
  void _addtoCart(int index) {
    try {
      int fishqty = int.parse(fishlist[index]["fishqrt"]);
      print(fishqty);
      print(fishlist[index]["id"]);
      print(widget.user.email);
      if (fishqty > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        http.post("http://seriouslaa.com/bettafish/php/insert_cart.php", body: {
          "email": widget.user.email,
          "id": fishlist[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              quantity = respond[1];
              widget.user.name = '';
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          
        }).catchError((err) {
          print(err);
    
        });
    
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
