import 'dart:async';
import 'package:bettafish/detailscreen.dart';
import 'package:flutter/material.dart';
import 'billscreen.dart';
import 'fish.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';


class FishCartScreen extends StatefulWidget {
  final User user;

  const FishCartScreen({Key key, this.user}) : super(key: key);

  @override
  _FishCartScreenState createState() => _FishCartScreenState();
}

class _FishCartScreenState extends State<FishCartScreen> {
  List fishlist;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Cart...";
  final formatter = new NumberFormat("#,##");
  double totalPrice = 0.0;
  double payable = 0.0;
  int numcart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              createHeader(),
              createSubTitle(),
              createCartList(),
              footer(context)
            ],
          );
        },
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "0",
                  
                ),
              ),
            ],
          ),
         SizedBox(height: 5),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => BillScreen()));
            },
            color: Colors.green,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Checkout",
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total Items",
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createCartListItem();
      },
      itemCount: 5,
    );
  }

  createCartListItem() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(fishlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            child: InkWell(
                          onTap: () => _loadFishDetails(index),
                          onLongPress: () => _deleteOrderDialog(index),
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: screenHeight / 6,
                                    width: screenWidth / 4,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://seriouslaa.com/bettafish//images/${fishlist[index]['fishimage']}.png",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fishlist[index]['fishname'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("RM " +
                                        fishlist[index]['fishprice'] +
                                        " x " +
                                        fishlist[index]['fishqrt']
                                        ),
                                    Text("Total RM " +
                                        (double.parse(fishlist[index]
                                                    ['fishprice']) *
                                                int.parse(
                                                    fishlist[index]['fishqrt']))
                                            .toStringAsFixed(2))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )));
                  }),
                )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "\$299.00",
                              
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      "1",
                                      
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              
            
          
        
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.green),
          ),

          
        )
      ],
    );

  }
  
  _loadFishDetails(int index) async {
    print(fishlist[index]['fishid']);
     Fish fish = new Fish(
        fishid: fishlist[index]['fishid'],
        fishname: fishlist[index]['fishname'],
        fishprice: fishlist[index]['fishprice'],
        fishqty: fishlist[index]['fishqrt'],
        fishimage: fishlist[index]['fishimage'],
        rating: fishlist[index]['rating'],
        );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailScreen(
                  fish: fish,
                  user: widget.user,
                )));
    _loadCart();
  }

  void _loadCart() {
    http.post("http://seriouslaa.com/bettafish/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        fishlist = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        totalPrice = 0;
        numcart = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          fishlist = jsondata["cart"];
          for (int i = 0; i < fishlist.length; i++) {
            totalPrice = totalPrice +
                double.parse(fishlist[i]['fishprice']) *
                    int.parse(fishlist[i]['fishqrt']);
            numcart = numcart + int.parse(fishlist[i]['fishqrt']);
          }
         
          _calculatePayment();
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteOrderDialog(int index) {
    print("Delete " + fishlist[index]['fishname']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete order " + fishlist[index]['fishname'] + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteCart(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCart(int index) {
    http.post("http://seriouslaa.com/bettafish/php/delete_cart.php", body: {
      "email": widget.user.email,
      "fishid": fishlist[index]['fishid'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadCart();
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Delete failed!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
   _calculatePayment() {
    setState(() {
      
        payable = totalPrice ;
     
    });
  }
}
