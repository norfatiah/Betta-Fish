import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'fish.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Fish fish;
  final User user;
  const DetailScreen({Key key, this.fish,this.user}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

 class _DetailScreenState extends State<DetailScreen>{
  double screenHeight, screenWidth;
  List fishlist;
  String titlecenter = "Loading Fish...";
  String type = "Fish";
  GlobalKey<RefreshIndicatorState> refreshKey;

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
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Betta Fish Collection'),
        backgroundColor: Colors.black,  
            
      ),
      body: Column(
        children: [
        Row(
          children: List.generate(fishlist.length, (index) {
          return Padding(
              padding: EdgeInsets.all(1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                              height: screenHeight / 2,
                              width: screenWidth / 1,
                    child: CachedNetworkImage(
                                       imageUrl:
                                               "http://seriouslaa.com/bettafish/images/${widget.fish.fishimage}.png",
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth/2,
                                                  
                                                ),
                                              )),
                      Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Fish Id: " +
                            fishlist[index]
                            ['fishid'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                         Text(
                            fishlist[index]
                            ['fishname'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),   
                        Text("RM " +
                            fishlist[index]['fishprice']
                             ),  
                        Text( "Fish quantity" +
                            fishlist[index]['fishqty'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                        
                        Text("Rating fish : " +
                            fishlist[index]['rating'],
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                         ],
                    ),
                  ],
                ),
              ));
          }), 
        ),
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
        body: {
          
        }).then((res) {
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
        description: fishlist[index]['description'],
        );

  }

}

