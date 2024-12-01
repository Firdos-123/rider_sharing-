import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/AllScreens/searchScreen.dart';
import 'package:rider/Assistants/assistantMethods.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);  // Use Key? to make it optional

  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  bool drawerOpen = true;
  late String address1;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(
        (CameraUpdate.newCameraPosition(cameraPosition)));

    address1 = AssistantMethods.searchCoordinateAddress(currentPosition, context) as String;

  }



  @override
  Widget build(BuildContext context) {

    AssistantMethods.searchCoordinateAddress(currentPosition, context);

    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer header
              SizedBox(
                height: 165.0,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("assets/images/user_icon.png", height: 65.0, width: 65.0,),
                      const SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("username", style: TextStyle(fontSize: 16.0,fontFamily: "Brand Bold"),),
                          const SizedBox(height: 6,),
                          GestureDetector(
                            onTap: (){

                            },
                            child: const Text("Visit Profile"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Divider(),

              const SizedBox(height: 12.0,),

              //Drawer Body Contrller
              GestureDetector(
                onTap: (){

                },
                child: const ListTile(
                  leading: Icon(Icons.history),
                  title: Text("History"),
                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: const ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: const ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Sign Out", style: TextStyle(fontSize: 15.0),),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled:  true,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),

          //HamburgerButton for Drawer
          Positioned(
            top: 36.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                if(drawerOpen){
                  scaffoldKey.currentState?.openDrawer();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                    child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: Colors.black),
                ),
              )
            ),
          ),

          //Search UI
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              //vsync: this,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6.0),
                      const Text("Hi there,", style: TextStyle(fontSize: 12.0),),
                      const Text("Where to?", style: TextStyle(fontSize: 20.0, fontFamily:
                        "Brand Bold"),),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () async{
                          Navigator.push(context, MaterialPageRoute(builder:
                          (context) => const SearchScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 16.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7,0.7),
                              ),
                            ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.blueAccent),
                              SizedBox(width: 10.0),
                              Text("Search Drop Off"),
                            ],
                          ),
                        )
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey),
                          SizedBox(width:12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Home"),
                              SizedBox(height: 4.0),
                              Text("Your living home address",
                                style: TextStyle(color: Colors.black54,
                                fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      const Divider(),
                      const SizedBox(height: 16.0,),
                      const Row(
                        children: [
                          Icon(Icons.work, color: Colors.grey),
                          SizedBox(width:12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work"),
                              SizedBox(height: 4.0),
                              Text("Your Office address",
                                style: TextStyle(color: Colors.black54,
                                    fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }
}
