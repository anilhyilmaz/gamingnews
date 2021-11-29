import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'mymodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future? myfuture;
  var data = [];
  Future httpget() async {
    var response = await http
        .get(Uri.parse('https://gaming-news.p.rapidapi.com/news'), headers: {
      'x-rapidapi-host': 'gaming-news.p.rapidapi.com',
      'x-rapidapi-key': '97b288ecddmsh3e2342e7c35ee67p18e085jsn64da772ea0bb'
    });
    var convertJsonData = jsonDecode(response.body);
    data = convertJsonData;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture = httpget();
  }

  @override
  Widget build(BuildContext context) {

    String addedurl = "";
    void _launchURL(addedurl) async {
      if (!await launch(addedurl)) throw 'Could not launch $addedurl';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: myfuture,
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none) {
            return const Text("veri yok");
          } else if (projectSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Row(children: [Expanded(
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      child: ListTile(

                        onTap: (){
                          print(index);
                          var url = data[index]["url"];
                          if(data[index]["source"] == "theverge"){
                            var split = url.split("https://www.theverge.com");
                            addedurl = "https://www.theverge.com${split[2]}";
                            print("addedurl : $addedurl");
                            print(data[index]["title"]);
                            _launchURL(addedurl);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => Details(url: addedurl)));
                          }
                          else{
                            var url = data[index]["url"];
                            print(url);
                            print(data[index]["title"]);
                            _launchURL(url);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => Details(url: url)));
                          }
                        },
                      leading: CircleAvatar(
                      child: Text(
                      data[index]["source"][0],
                      )),
                      title: Text(data[index]["title"]),
                      ),
                    ),
                  ),const Divider(height: 50,)],);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
