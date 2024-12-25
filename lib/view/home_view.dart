import 'package:another_brother_printer/view/printer_view.dart';
import 'package:flutter/material.dart';


class HomeView extends StatelessWidget {
   HomeView({super.key});


  final List<Map<String,dynamic>> data = 
  [
    {
      "title": "Pruc1",
      "price" : 10000,
      "qty" : 2,
      "total_price" : 2000,
    },
    {
      "title": "Pruc2",
      "price" : 10000,
      "qty" : 2,
      "total_price" : 2000,
    },
    {
      "title": "Pruc3",
      "price" : 10000,
      "qty" : 2,
      "total_price" : 2000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    int _total = 0; 
    for(int i = 0;i<data.length ; i++)
    {
      _total += int.parse(data[i]['total_price'].toString()) ;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Printer"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]['title']),
                subtitle: Text('Rp ${data[index]['price']} x ${data[index]['qty']}'),
                trailing: Text('Rp ${data[index]['total_price']}'),
              );
            },),),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text("Total :", style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Rp ${_total} :", style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(width: 20,),
                  Expanded(child: 
                  ElevatedButton(
                    
                    onPressed: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (_)=>PrinterView(data: data)));
                    },
                   child: Text("data"),),),
                ],
              ),
            )
        ],
      ),
    );
  }
}