import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InternetConnection extends StatefulWidget {
  const InternetConnection({Key? key}) : super(key: key);


  @override
  State<InternetConnection> createState() => _InternetConnectionState();
}

class _InternetConnectionState extends State<InternetConnection> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isThereInternet = true;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus.contains(ConnectivityResult.none)) {
        _isThereInternet = false;
      } else {
        _isThereInternet = true;
      }
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  void recheckConnection() async {
    var result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
    print("internet rechecked");
  }

  //_isThereInternet ? SizedBox.shrink() :
  @override
  Widget build(BuildContext context) {
    return _isThereInternet ? SizedBox.shrink() : Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
            child: ListView(
              shrinkWrap: true,
              children: List.generate(
                  _connectionStatus.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Internet Connection Lost!",
                          style: TextStyle(color: Colors.white),
                        ),
                        /*Text(
                          _connectionStatus[index].toString(),
                          style: TextStyle(color: Colors.white),
                        ),*/
                        InkWell(
                          onTap: () => setState(() {
                            _isThereInternet = true;
                          }),
                          child: Row(
                            children: [
                              Text('Dismiss'),
                              Icon(
                                Icons.cancel,
                                color: Colors.white,
                                semanticLabel: 'Refresh Time',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            //child: Center(child: Text("Internet Connection Lost!"),),),
          ),
        ),

      ],
    );
  }
}

/*Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Plus Example'),
        elevation: 4,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(flex: 2),
          Text(
            'Active connection types:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Spacer(),
          ListView(
            shrinkWrap: true,
            children: List.generate(
                _connectionStatus.length,
                    (index) => Center(
                  child: Text(
                    _connectionStatus[index].toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );*/
