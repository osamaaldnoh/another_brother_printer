import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';


class PrinterView extends StatefulWidget {
   PrinterView({super.key, required this.data});


  final List<Map<String,dynamic>> data ;

  @override
  State<PrinterView> createState() => _PrinterViewState();
}

class _PrinterViewState extends State<PrinterView> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    print("OSamam");
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected =
    await bluetooth.isConnected;
    
    try {
      devices = await bluetooth.getBondedDevices();
    } 
    catch (e)
    {
      print(e.toString());
    }
    // on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blue Thermal Printer'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice? value) =>
                            setState(() => _device = value),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.brown),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: _connected ? Colors.red : Colors.green),
                      onPressed: _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.brown),
                    onPressed: () 
                    async{
                      // testPrint.sample();
                      if((await bluetooth.isConnected)!){
                      bluetooth.printNewLine();
                      bluetooth.printCustom("Welcome in Era Tech", 0, 1);
                      bluetooth.printQRcode("Welcome in Era Tech", 200, 200, 1);
                      bluetooth.printNewLine();
                      bluetooth.printNewLine();
                      bluetooth.printNewLine();
              }
                    },
                    child: Text('PRINT TEST',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Text("IsConnect : ${
                  _connected
                }")
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

 void _connect() async { if (_device != null) { bluetooth.isConnected.then((isConnected) { if (isConnected == false) { bluetooth.connect(_device!).catchError((error) { setState(() => _connected = false); }); setState(() => _connected = true); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already connected'))); } }); } else { show('No device selected.'); } }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}

// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/material.dart';


// class PrinterView extends StatefulWidget {
//    PrinterView({super.key, required this.data});


//   final List<Map<String,dynamic>> data ;

//   @override
//   State<PrinterView> createState() => _PrinterViewState();
// }

// class _PrinterViewState extends State<PrinterView> {
//   List<BluetoothDevice> device =[];
//   BluetoothDevice? selectDevice;
//   BlueThermalPrinter printer = BlueThermalPrinter.instance;
//   // PrinterBluetoothManager

//   @override
//   void initState() {
//     print(widget.data);
//     super.initState();
//     getDevice();
//   }

//   getDevice()
//   async
//   {
//     device = await printer.getBondedDevices();
//     setState(() {
      
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Printer"),
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DropdownButton(
//               hint: Text("Select Device"),
//               items: device.map((e) => 
//             DropdownMenuItem(child: Text(e.name!))).toList(),
//              onChanged: (device)
//              {
//               selectDevice = device;
//               setState(() {
                
//               });
//              }),
//              SizedBox(
//                 height: 20,
//               ),
//              ElevatedButton(onPressed: ()
//              {
//               if(selectDevice != null)
//               {setState(() {
               
//              });
//               printer.connect(selectDevice!);
//              }
             
//              }
//              ,
//               child: Text("Connect"),),
//               SizedBox(
//                 height: 20,
//               ),
//                ElevatedButton(onPressed: ()
//              {
//               printer.disconnect();
//              },
//               child: Text("Disconnect"),),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(onPressed: ()
//               async
//               {
//                 if((await printer.isConnected)!){
//                 printer.printNewLine();
//                 printer.printCustom("Welcome in Era Tech", 0, 1);
//                 printer.printQRcode("Welcome in Era Tech", 200, 200, 1);
//                 printer.printNewLine();
//                 printer.printNewLine();
//                 printer.printNewLine();
//               }
//               },
//               child: Text("Print"),),

//           ],
//         ),
//       )
//        );
//   }
// }