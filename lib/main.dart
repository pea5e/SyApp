// import 'dart:ffi';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

void main() {
  
  runApp(Syapp());
}


String rand_pin()
{
    Random random = new Random();
    String s="";
    for(var i=0;i<8;i++)
    {
      s += "abcdefghijklmnopkrstuvwxyz"[random.nextInt(26)];
    }
    return s;
}
Future<String> totalincome() async
{
  var uri = "https://mydatabase.salimalaoui.repl.co/?query=select sum(price) as total from (select (sum(num)*(select price from produit where ref=produit_ref)) as price from achat group by produit_ref)";
  final response =  await http.Client().get(Uri.parse(uri));
  var rep;
  if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        // print(rep);
        }
      }
    return rep[0]["total"].toString()+'\$';

}


Future<String> totalcommande() async
{
  var uri = "https://mydatabase.salimalaoui.repl.co/?query=select count(*) as count from commande";
  final response =  await http.Client().get(Uri.parse(uri));
  var rep;
  if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        // print(rep);
        }
      }
    return rep[0]["count"].toString();

}

Future<String> totalclient() async
{
  var uri = "https://mydatabase.salimalaoui.repl.co/?query=select count(*) as count from client";
  final response =  await http.Client().get(Uri.parse(uri));
  var rep;
  if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        // print(rep);
        }
      }
    return rep[0]["count"].toString();

}

Future<String> totalsold() async
{
  var uri = "https://mydatabase.salimalaoui.repl.co/?query=select sum(num) as solds  from achat";
  final response =  await http.Client().get(Uri.parse(uri));
  var rep;
  if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        // print(rep);
        }
      }
    return rep[0]["solds"].toString();

}

Future<List> allproducts(String order) async
  {
    var uri;
    if (order=="last")
      uri ='https://mydatabase.salimalaoui.repl.co/?query=select *,(select sum(num) from achat where produit_ref =ref) as sold,(select count(num) from achat where produit_ref =ref) as times from produit';
    else
      uri = 'https://mydatabase.salimalaoui.repl.co/?query=select *,(select sum(num) from achat where produit_ref =ref) as sold,(select count(num) from achat where produit_ref =ref) as times from produit order by $order';

    final response = await http.Client().get(Uri.parse(uri));
        List le=[];
    var rep ;
    // Map p ={};
    var s;
    // print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        // print(rep);
        }
      }
    
    product.allsaled = int.parse(await totalsold());
        // print(rep);

    for(var element in rep)
    {
      // s = 0;
      //final resp = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select sum(num) as score from achat where produit_ref ='+element["ref"].toString()));
      // if (resp.statusCode == 200) 
      // {
      //   if (resp.body.indexOf("<b>Warning</b>")==-1)
      //       s = jsonDecode(parser.parse(resp.body).body.text)[0]["score"];
      //       // print(s);
      //       if(s.toString()=="")
      //       {
      //         s = 0;
      //       }
      // }
      
      List emp = await request("select user from employe join produit on(employe.pin = produit.qualified_by) where ref="+element["ref"].toString());
      // p["owner"] = emp[0]["user"];
      // element["sold"]=s;
      // p["product"] = product(element);
      print(element);
      le.add([product(element),emp[0]["user"]]);
      // p.clear();
      // print(le);
    }
    
    //  print("function:");
    // print(le);
    return le ;
  }

// 
Future<List<product>> best_selling() async
{
  List<product> l =[];
  final response1 = await http.Client().get(Uri.parse("https://www.amazon.com/Best-Sellers-Electronics/zgbs/electronics/ref=zg_bs_pg_1?_encoding=UTF8&pg=1"));
  final response2 = await http.Client().get(Uri.parse("https://www.amazon.com/Best-Sellers-Electronics/zgbs/electronics/ref=zg_bs_pg_2?_encoding=UTF8&pg=2"));
    //print(response.statusCode);
    var pr;
    Map p={};
    if (response1.statusCode == 200) {
      if (response1.body.indexOf("<b>Warning</b>")==-1)
      { 
        var rep = parser.parse(response1.body);
        var articels  = rep.getElementsByClassName("p13n-grid-content");
        
        // print("articels len :"+articels.length.toString());
        for(var ele in articels)
        {
          try{
          // print(ele.text);
          p["imageurl"]=ele.getElementsByTagName('img')[0].attributes["src"];
          // print(ele.getElementsByTagName("span")[1].text);
          p["desc"] = ele.getElementsByTagName("span")[1].text;
          // try{
          //   p["desc"]=ele.getElementsByClassName("_cDEzb_p13n-sc-css-line-clamp-3_g3dy1")[0].text;
          // }
          // catch(e)
          // {
          //   p["desc"]=ele.getElementsByClassName("_cDEzb_p13n-sc-css-line-clamp-4_2q2cc")[0].text;
          // }
          // print(p);
          // try{
          //   p["price"]=double.parse(ele.getElementsByClassName("p13n-sc-price")[0].text.substring(1));
          // }
          // catch(e)
          // {
          //   p["price"]=double.parse(ele.getElementsByClassName("_cDEzb_p13n-sc-price_3mJ9Z")[0].text.substring(1));
          // }
          pr = (double.parse(ele.getElementsByTagName("span")[5].text.substring(1))*1.2).toString();
          // print(pr);
          p["price"] =  double.parse(pr.substring(0,pr.indexOf('.')+3));
          p["visited"]=0;
          p["sold"]=0;
          p["ref"]=0;
          p["times"]=0;
          l.add(product(p));
          p.clear();
          }
          catch(e){
            continue;
          }
        }
        }

      // print(l);
      }
      if (response2.statusCode == 200) {
      if (response2.body.indexOf("<b>Warning</b>")==-1)
      { 
        var rep = parser.parse(response2.body);
        var articels  = rep.getElementsByClassName("p13n-grid-content");
        // print("articels len :"+articels.length.toString());
        for(var ele in articels)
        {
          // print(ele.innerHtml);
          try{
          p["imageurl"]=ele.getElementsByTagName('img')[0].attributes["src"];
          // print(ele.getElementsByTagName("span")[1].text);
          p["desc"] = ele.getElementsByTagName("span")[1].text;
          // print(ele.text);
          // try{
          //   p["desc"]=ele.getElementsByClassName("_cDEzb_p13n-sc-css-line-clamp-3_g3dy1")[0].text;
          // }
          // catch(e)
          // {
          //   p["desc"]=ele.getElementsByClassName("_cDEzb_p13n-sc-css-line-clamp-4_2q2cc")[0].text;
          // }
          // try{
          //   p["price"]=double.parse(ele.getElementsByClassName("p13n-sc-price")[0].text.substring(1));
          // }
          // catch(e)
          // {
          //   p["price"]=double.parse(ele.getElementsByClassName("_cDEzb_p13n-sc-price_3mJ9Z")[0].text.substring(1));
          // }
          pr = (double.parse(ele.getElementsByTagName("span")[5].text.substring(1))*1.2).toString();
          print(pr);
          p["price"] =  double.parse(pr.substring(0,pr.indexOf('.')+3));
          p["visited"]=0;
          p["sold"]=0;
          p["ref"]=0;
          p["times"]=0;
          // print(p);
          l.add(product(p));
          p.clear();
          }
          catch(e){
            continue;
          }
        }
        }
      }
      // print("result"+l.toString());
      return l;
}


Future<List> request(query) async
  {
    // print(query);
    final response = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=$query'));
    //print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        // print(parser.parse(response.body).body.text);
        var rep = jsonDecode(parser.parse(response.body).body.text);
        // print("request result:"+rep.toString());
        return rep;
        }
      }
      return [];
  } 

class product{
  static var allsaled ;
  var imageurl,desc,price,visited,sold,ref,times;  
  product(Map obj)
  {
    this.imageurl = obj["imageurl"];
    this.desc = obj["desc"];
    this.price = obj["price"];
    this.visited = obj["views"];
    if(obj["sold"]!='')
      this.sold = obj["sold"];
    else
      this.sold = 0;
    this.ref = obj["ref"];
    // print(obj["times"]);
    this.times = obj["times"];
  }


}

class employe{

  var pin,user,type,score;

  employe(Map obj,{int score=0})
  {
    pin = obj['pin'];
    user = obj['user'];
    type = obj['type'];
    this.score = score;
  }

  String username()
  {
    return user;
  }

  Future<List<employe>> allemployees() async
  {
    final response = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select * from employe where not pin="$pin"'));
    List<employe> le=[];
    var rep =[];
    var s;
    // print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        }
      }
    for(var element in rep)
    {
      // print(element);
      s = 0;
      final resp = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select sum(num) as score from achat where produit_ref in (select ref from produit where qualified_by = "'+element["pin"]+'")'));
      if (resp.statusCode == 200) 
      {
        if (resp.body.indexOf("<b>Warning</b>")==-1)
            s = jsonDecode(parser.parse(resp.body).body.text)[0]["score"];
            // print(s);
            if(s.toString()=="")
            {
              s = 0;
            }
      }
      le.add(employe(element,score:s ));
      // print(le);
    }
    return le ;
  }
  Future<List<product>> empproducts(String order) async
  {
    var uri;
    if (order=="last")
      uri ='https://mydatabase.salimalaoui.repl.co/?query=select *,(select sum(num) from achat where produit_ref =ref) as sold from produit';
    else
      uri = 'https://mydatabase.salimalaoui.repl.co/?query=select *,(select sum(num) from achat where produit_ref =ref) as sold from produit order by $order';

    final response = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select * from produit where qualified_by="$pin"'));
    List<product> le=[];
    var rep =[];
    var s;
    // print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.indexOf("<b>Warning</b>")==-1)
      { 
        rep = jsonDecode(parser.parse(response.body).body.text);
        // print(rep);
        }
      }
      product.allsaled = int.parse(await totalsold());
    for(var element in rep)
    {
      s = 0;
      final resp = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select sum(num) as score,count(*) as times from achat where produit_ref ='+element["ref"].toString()));
      if (resp.statusCode == 200) 
      {
        if (resp.body.indexOf("<b>Warning</b>")==-1)
            s = jsonDecode(parser.parse(resp.body).body.text)[0];
            if(s["score"].toString()=="")
            {
              element["sold"]=0;
            }
            else
            {
              element["sold"]=s["score"];
            }
      }
      // print(element);
      element["times"]=s["times"];
      print(element);
      le.add(product(element));
      // print(le);
    }
    
    //  print("function:");
    // print(le);
    return le ;
  }

}



class Syapp extends StatelessWidget {
  static var emp;
  static var pro;
  static var fil;
  static var maincolor =Color.fromARGB(255, 254, 241, 0);
  const Syapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("hello");
    //print(request("select * from employe"));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const login(),
          '/home': (context) => const home(),
          '/home/profile' :(context) =>  const profile(),
          '/home/products' :(context) =>  const products(),
          '/home/employees' :(context) =>  const employees(),
          '/home/stats' :(context) =>  const stats(),
          '/home/employees/add' : (context) => const add(),
          '/home/products/add' :(context) => const addpro(),
        },
    );
    }
  
}



class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String error_mess=''; 
  TextEditingController pin = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Syapp.maincolor,
        body : SafeArea( 
          child : Center(
            child:Column(children: [
              const SizedBox(
                  height: 100.0,
              ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/syapplogo.png"),
              ),
              const SizedBox(
                  height: 100.0,
              ),
              SizedBox(
                  width: 300.0,
                  child: TextField(
                      onChanged: (text) { setState(() {
                        error_mess='';
                      });},
                      controller: pin,
                      decoration: const InputDecoration(  
                        border: OutlineInputBorder(),  
                        labelText: 'Enter Your Pin',
                      ),  
                  ),
              ),
              Text(
                error_mess,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,color: Colors.red,),
                ),
              ElevatedButton(
                onPressed: () async{

                  var p = pin.value.text;
                  // print(p);
                  final response = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select * from employe where pin="$p"'));
                  // print(response.statusCode);
                  // print(p);
                  if (response.statusCode == 200) {
                      if (response.body.indexOf("<b>Warning</b>")==-1)
                       { 
                        var rep = jsonDecode(parser.parse(response.body).body.text);
                        final resp = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select sum(num) as score from achat where produit_ref in (select ref from produit where qualified_by = "'+rep[0]["pin"]+'")'));
                        var s;
                        if (resp.statusCode == 200) 
                        {
                          if (resp.body.indexOf("<b>Warning</b>")==-1)
                              s = jsonDecode(parser.parse(resp.body).body.text)[0]["score"];
                        }
                        // print("score"+s.toString());
                        Syapp.emp = new employe(rep[0],score: s);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home');
                       }
                       else{
                        setState(() {
                          error_mess = "invalid pin";
                        });
                       }
                  }
                  else{
                    setState(() {
                          error_mess = "Connection Error :"+response.statusCode.toString();
                      });
                  }
                },
                child: const Text(
                'LOG IN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
                ),
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
          ]
          ,)
          ),
        )
      )
    );
  }
}
class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        backgroundColor: Color.fromARGB(255, 254, 241, 0),
        body: SafeArea(
          child : Center(
                child:Column( children: [
                  const SizedBox(
                          height: 100.0,
                  ),
                  SizedBox(
                        width: 300.0,
                        child :Card(
                          child:ElevatedButton(
                          style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home/profile');
                                },
                                child: const ListTile(
                              leading: Icon(Icons.account_circle_outlined,
                              color: Colors.black,
                              size: 24.0,
                                    ),
                              title: Text(
                                "PROFILE"
                                ),
                                ),
                          ),
                        ),
                    ),
                    const SizedBox(
                          height: 50.0,
                    ),
                    SizedBox(
                        width: 300.0,
                        child :Card(
                          child:ElevatedButton(
                          style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home/products');
                                },
                                child: const ListTile(
                              leading: Icon(Icons.computer,
                              color: Colors.black,
                              size: 24.0,
                                    ),
                              title: Text(
                                "PRODUCTS"
                                ),
                                ),
                          ),
                        ),
                    ),
                    const SizedBox(
                          height: 50.0,
                  ),
                    if (Syapp.emp.type == 'admin') 
                      SizedBox(
                        width: 300.0,
                        child :Card(
                          child:ElevatedButton(
                          style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home/employees');
                                },
                                child: const ListTile(
                              leading: Icon(Icons.group_remove_outlined,
                              color: Colors.black,
                              size: 24.0,
                                    ),
                              title: Text(
                                "EMPLOYEES"
                                ),
                                ),
                          ),
                        ),
                    ),const SizedBox(
                          height: 50.0,
                    ),
                    if (Syapp.emp.type == 'admin') 
                    SizedBox(
                        width: 300.0,
                        child :Card(
                          child:ElevatedButton(
                          style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home/stats');
                                },
                                child: const ListTile(
                              leading: Icon(Icons.analytics_outlined,
                              color: Colors.black,
                              size: 24.0,
                                    ),
                              title: Text(
                                "ACTIVTY"
                                ),
                                ),
                          ),
                        ),
                    ),
                    const SizedBox(
                          height: 50.0,
                  ),
                  //if (emp.type == "admin")
                ]),
          ),
        ),
      ),
    );
  }
}



class profile extends StatelessWidget{

  
  const profile({Key? key}) : super(key: key);

  static var pro;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Scaffold(
            backgroundColor: Syapp.maincolor,
            body: SafeArea(
                child:Center(child:Column(
                    children: [
                        SizedBox(
                          height: 300.0-(100.0*(Syapp.emp.type=='admin' ? 0 : 1)),
                        ),
                        SizedBox(
                            width: 300.0,
                            child: ListTile(
                                  leading: const Icon(Icons.account_circle_outlined,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                    title: Text(
                                      Syapp.emp.user
                                    ),
                              )
                          ),
                          if (Syapp.emp.type!='admin') SizedBox(
                            width: 300.0,
                            child: ListTile(
                                  leading: Text("Votre Score:"+Syapp.emp.score.toString()),
                                    title: Text(
                                      Syapp.emp.user
                                    ),
                              )
                          ),
                      ],
                )) 
            ),
            
          )
    );
  }
}

class employees extends StatefulWidget {
  const employees({Key? key}) : super(key: key);

  @override
  State<employees> createState() => _employeesState();
}

class _employeesState extends State<employees> {
  
  @override
  Widget build(BuildContext context) {
    // print(Syapp.emp.user);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Scaffold(
            backgroundColor: Syapp.maincolor,
            body: SafeArea(
                child: 
                    FutureBuilder(
                        future: Syapp.emp.allemployees(),
                        builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                                case ConnectionState.waiting: return Text('Loading....');
                                default:
                                      if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                      else{
                                          List<employe> emps = snapshot.data as List<employe>;
                                          // print("listtile");
                                          // print(emps.length);
                                          return ListView.builder(itemBuilder: (context, index) {
                                            if(index<emps.length){
                                          return ListTile(
                                              leading : Text(emps[emps.length-index-1].score.toString()),
                                              title: Text(emps[emps.length-index-1].user+" / "+emps[emps.length-index-1].type),
                                              subtitle: Text(emps[emps.length-index-1].pin),
                                              trailing: IconButton(icon: Icon(Icons.delete_forever_outlined),onPressed: () {
                                               request('delete from employe where pin="'+emps[emps.length-index-1].pin+'"');
                                              Navigator.pop(context);
                                              Navigator.pushNamed(context, '/home/employees');
                                              //  Navigator.pushAndRemoveUntil(
                                              //   context,
                                              //   MaterialPageRoute(builder: (context) => employees()),
                                              //   (Route<dynamic> route) => false,);
                                              },),
                                              //TextButton(child: Text("sqlim"),),
                                                //IconButton(icon:Icon(Icons.delete_forever_outlined)),
                                            );
                                            }
                                            else{
                                                return SizedBox(height:10);
                                            }
                                      }
                                    );
                                  }
                          };
                        }
                      
                      ),
                      
                      // ]
                    ),
                    floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      Navigator.pushNamed(context, "/home/employees/add");
                      // Add your onPressed code here!
                    }),
                ) ,
              
            // ),
            
          );

  }
}


class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  
  TextEditingController user = TextEditingController();
  //  var type ;
  String error="";
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Scaffold(
            backgroundColor: Syapp.maincolor, body:Column(children: [
                      SizedBox(
                                height: 100.0,
                            ),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.end,a
                            children: [ 
                          //     DropdownButton(
                          //   value: type,
                          //   items: ['admin','employe'].map((String items) {
                          //   return DropdownMenuItem(
                          //     value: items,
                          //     child: Text(items),
                          //   );
                          // }).toList(),
                          //   onChanged: ((String v) {
                          //           type = v;
                          //   })),
                            SizedBox(
                                width: 200.0,
                                child: TextField(
                                    controller: user,
                                    decoration: const InputDecoration(  
                                      border: OutlineInputBorder(),  
                                      labelText: 'User',
                                    ),  
                                ),
                            ),
                            Text("ADMIN:"),
                            Checkbox(
                              
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                  });
                                  }
                                )
                                 ,
                            // SizedBox(
                            //     width: 120.0,
                            //     child: TextField(
                            //         controller: type,
                            //         decoration: const InputDecoration(  
                            //           border: OutlineInputBorder(),  
                            //           labelText: 'Type',
                            //         ),  
                            //     ),
                            // ),
                            ElevatedButton(onPressed: ()async{
                              //request
                              var p ;
                              var e;
                              final response = await http.Client().get(Uri.parse('https://mydatabase.salimalaoui.repl.co/?query=select pin from employe'));
                              
                              if (response.statusCode == 200) {
                                if (response.body.indexOf("<b>Warning</b>")==-1)
                                { 
                                  e = jsonDecode(parser.parse(response.body).body.text);
                                  // print(e);
                                  do{
                                    p = rand_pin();
                                    }while (e.toString().indexOf(p)>-1);
                                    // try{
                                    request("insert into employe values(\"$p\",\""+user.text+"\",\""+ (isChecked ? "admin": "employe")+"\")");
                                    // }
                                    // catch(e)
                                    // {
                                    //   print("User already used");
                                    //    setState(() {
                                    //      error = "User already used";
                                    //    });
                                    // }
                                    // print(Navigator.defaultRouteName);


                                    /// reload
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context,"/home/employees");
                                    // Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => employees()),
                                    //     (Route<dynamic> route) => false,);
                                  }
                                  }
                                }
                            , child: Icon(Icons.add_circle_outline )),
                            Text(
                            error,
                          textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18,color: Colors.red,)),
                          ],
                          
                ),
                    
                  ])
                )
            );
    
  }
}


class products extends StatefulWidget {
  const products({Key? key}) : super(key: key);

  @override
  State<products> createState() => _productsState();
}

class _productsState extends State<products> {
  
  String orderby = 'Last';
  @override
  Widget build(BuildContext context) {
    // best_selling();
    if (Syapp.emp.type != 'admin')
    return MaterialApp(
          debugShowCheckedModeBanner: false,
            home:Scaffold(
              appBar: AppBar(
                    // PreferredSize(
                    // preferredSize: Size.fromHeight(160),
                    backgroundColor: Colors.white,
                    title: DropdownButton<String>(
                        value: orderby,
                        onChanged: (String? newValue) {
                          setState(() {
                            orderby = newValue!;
                          });
                        },
                        items: <String>['Last', 'Views', 'Sold']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                )
                ,
              body: SafeArea(
                child:
                    FutureBuilder(
                        future: Syapp.emp.empproducts(orderby.toLowerCase()) ,
                        builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                                case ConnectionState.waiting: return Text('Loading....');
                                default:
                                      if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                      else{
                                          List<product> prods= snapshot.data as List<product>;
                                          return ListView.builder(itemBuilder: (context, index) {
                                            // print("ref = "+(prods.length-index-1).toString());
                                            
                                            if(index<prods.length) {
                                              print("future builder"+prods[prods.length-index-1].toString());
                                          return ListTile(
                                              leading : Image(image: NetworkImage(prods[prods.length-index-1].imageurl)),
                                              title:TextButton(child:Text(prods[prods.length-index-1].desc),
                                              onPressed: (() async {
                                                String url = 'https://syapp.salimalaoui.repl.co/product/'+prods[prods.length-index-1].ref.toString();
                                                // print(url);
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              }),
                                              ),
                                              subtitle: Row(children: [Icon(Icons.remove_red_eye_outlined),Text(prods[prods.length-index-1].visited.toString()),SizedBox(width:15),if(prods[prods.length-index-1].times!=0)Text(((prods[prods.length-index-1].times/prods[prods.length-index-1].visited)*100).toInt().toString()+"%") else Text("0%"),SizedBox(width:15),Icon(Icons.shopping_cart_outlined ),Text(prods[prods.length-index-1].sold.toString())]),
                                              trailing: IconButton(icon: Icon(Icons.delete_forever_outlined),onPressed: () {
                                               request('delete from produit where ref='+prods[prods.length-index-1].ref.toString()+'');
                                              // Navigator.popAndPushNamed(context,"/home/products");
                                              Navigator.pop(context);

                                              },),
                                              
                                            );
                                            }
                                            else{
                                                return SizedBox(height:10);
                                            }
                                      }
                                    );
                                  }
                          };
                        }
                      
                      ),
                      // ]
                    ),
            backgroundColor: Syapp.maincolor,
             floatingActionButton:FloatingActionButton(
                child: Icon(Icons.add_circle_outline),
                onPressed: () {
                  Navigator.pushNamed(context, "/home/products/add");
                      // Add your onPressed code here!
                }),
            ),
    );
    else
    return MaterialApp(
          debugShowCheckedModeBanner: false,
            home:Scaffold(
              appBar: AppBar(
                    // PreferredSize(
                    // preferredSize: Size.fromHeight(160),
                    backgroundColor: Colors.white,
                    title: DropdownButton<String>(
                        value: orderby,
                        onChanged: (String? newValue) {
                          setState(() {
                            orderby = newValue!;
                          });
                        },
                        items: <String>['Last', 'Views', 'Sold']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                )
                ,
              body: SafeArea(
                child: 
                    FutureBuilder(
                        future: allproducts(orderby.toLowerCase()) ,
                        builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                                case ConnectionState.waiting: return Text('Loading....');
                                default:
                                      if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                      else{
                                          List prods = snapshot.data as List;
                                          // List emps =[];
                                          // var i=-1;
                                          // prods.forEach((element) async{
                                          //   try{
                                          //     final emp = await request("select user from employe join produit on(employe.pin = produit.qualified_by) where ref="+element.ref.toString());
                                          //     emps.add(emp[0]["user"]);
                                          //   }
                                          //   catch(e)
                                          //   {
                                          //     print("none");
                                          //   }
                                          // });
                                          return ListView.builder(itemBuilder: (context, index) {
                                            // print("ref = "+(prods.length-index-1).toString());
                                            if(index<prods.length){
                                              // print(emps);
                                              
                                              print("future builder"+prods[prods.length-index-1].toString()+prods[prods.length-index-1][0].times.toString());
                                          return ListTile(
                                              leading : Image(image: NetworkImage(prods[prods.length-index-1][0].imageurl)),
                                              title: TextButton(child: Text(prods[prods.length-index-1][0].desc),
                                              onPressed: (() async{
                                                String url = 'https://syapp.salimalaoui.repl.co/product/'+prods[prods.length-index-1][0].ref.toString();
                                                // print(url);
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              }),
                                              ),
                                              subtitle: Row(children: [Icon(Icons.remove_red_eye_outlined),Text(prods[prods.length-index-1][0].visited.toString()),SizedBox(width:15),if(prods[prods.length-index-1][0].times!=0)Text(((prods[prods.length-index-1][0].times/prods[prods.length-index-1][0].visited)*100).toInt().toString()+"%")else Text("0%"),SizedBox(width:15),Icon(Icons.shopping_cart_outlined ),Text(prods[prods.length-index-1][0].sold.toString()),SizedBox(width:15),if(prods[prods.length-index-1][0].sold!=0)Text(((prods[prods.length-index-1][0].sold/product.allsaled)*100).toInt().toString()+"%")else Text("0%"),SizedBox(width:15),Text(prods[prods.length-index-1][1])]),
                                              
                                              // trailing: IconButton(icon: Icon(Icons.delete_forever_outlined),onPressed: () {
                                              //  request('delete from produit where ref='+prods[prods.length-index-1].ref.toString()+'');
                                              // Navigator.popAndPushNamed(context,"/home/products");
                                              // },),
                                              
                                            );
                                            }
                                            else{
                                                return SizedBox(height:10);
                                            }
                                      }
                                    );
                                  }
                          };
                        }
                      
                      ),
                      // ]
                    ),
            backgroundColor: Syapp.maincolor,
             
            ),
    );
  }
}

class addpro extends StatefulWidget {
  const addpro({Key? key}) : super(key: key);

  @override
  State<addpro> createState() => _addproState();
}

class _addproState extends State<addpro> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
            home:Scaffold(
            backgroundColor: Syapp.maincolor,
            body: SafeArea(
                child: 
                    FutureBuilder(
                        future: best_selling(),
                        builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                                case ConnectionState.waiting: return Text('Loading....');
                                default:
                                      if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                      else{
                                          List<product> pros = snapshot.data as List<product>;
                                          // print(pros);
                                          return ListView.builder(itemBuilder: (context, index) {
                                            if(index<pros.length){
                                          return ListTile(
                                            
                                              leading : Image(image: NetworkImage(pros[pros.length-index-1].imageurl),),
                                              title: Text(pros[pros.length-index-1].desc),
                                              subtitle: Text(pros[pros.length-index-1].price.toString()),
                                              trailing: IconButton(icon: Icon(Icons.add),onPressed: () async  {
                                                print('insert into produit(imageurl,desc,price,views,qualified_by) values(\''+pros[pros.length-index-1].imageurl+"','"+pros[pros.length-index-1].desc+'\','+pros[pros.length-index-1].price.toString()+',0,"'+Syapp.emp.pin+'")');
                                              // print('insert into produit(imageurl,desc,price,visited,qualified_by) values("'+pros[pros.length-index-1].imageurl+'","'+pros[pros.length-index-1].desc+'",'+pros[pros.length-index-1].price.toString()+',0,"'+Syapp.emp.type+'")');
                                               await request('insert into produit(imageurl,desc,price,views,qualified_by) values(\''+pros[pros.length-index-1].imageurl+"','"+pros[pros.length-index-1].desc+'\','+pros[pros.length-index-1].price.toString()+',0,"'+Syapp.emp.pin+'")');
                                                Navigator.pop(context);
                                              //  Navigator.popAndPushNamed(context, '/home/products');
                                              },),
                                              //TextButton(child: Text("sqlim"),),
                                                //IconButton(icon:Icon(Icons.delete_forever_outlined)),
                                            );
                                            }
                                            else{
                                                return SizedBox(height:10);
                                            }
                                      }
                                    );
                                  }
                          };
                        }
                      
                      ),
                      
                      // ]
                    ),
            ),
    );
  }
}


class stats extends StatefulWidget {
  const stats({Key? key}) : super(key: key);

  @override
  State<stats> createState() => _statsState();
}

class _statsState extends State<stats> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
            home:Scaffold(
            backgroundColor: Syapp.maincolor,
            body: SafeArea(
                child: Center ( child:Column(children:[
                              const SizedBox(
                                height: 100.0,
                              )
                                  ,
                                FutureBuilder<String>(
                              future: totalsold(), 
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return Text('Loading....');
                                  default:
                                    if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                    else
                                    return Card(child: ListTile(trailing: Text("${snapshot.data}"),leading: Icon(Icons.label), title:  Text('Total Sold:')));
                                  }
                              },
                              ),
                              const SizedBox(
                                height: 50.0,
                              )
                                  ,
                                FutureBuilder<String>(
                              future: totalclient(), 
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return Text('');
                                  default:
                                    if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                    else
                                    return Card(child: ListTile(trailing: Text("${snapshot.data}"),leading: Icon(Icons.groups ), title:  Text('Total Clients:')));
                                  }
                              },
                              ),
                              const SizedBox(
                                height: 50.0,
                              )
                                  ,
                                FutureBuilder<String>(
                              future: totalcommande(), 
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return Text('');
                                  default:
                                    if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                    else
                                    return Card(child: ListTile(trailing: Text("${snapshot.data}"),leading: Icon(Icons.outbox), title:  Text('Total Orders:')));
                                  }
                              },
                              ),
                              const SizedBox(
                                height: 50.0,
                              )
                                  ,
                                FutureBuilder<String>(
                              future: totalincome(), 
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return Text('');
                                  default:
                                    if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                    else
                                    return Card(child: ListTile(trailing: Text("${snapshot.data}"),leading: Icon(Icons.attach_money_outlined ), title: Text('Total Income:')));
                                  }
                              },
                              ),
                          ])
                ),
            ),
            ),
    );
  }
}

//flutter run --no-sound-null-safety
//exznadhf ADMIN
//flutter.minSdkVersion=21