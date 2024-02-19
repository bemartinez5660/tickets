// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/services/google_maps/google_maps_service.dart';
import 'package:isu_corp_test/widgets/common/customized_back_button.dart';

class DirectionsScreen extends StatefulWidget {
  const DirectionsScreen({super.key, this.ticket});
  final Ticket? ticket;

  @override
  State<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final googleMapService = GoogleMapsService();
  
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ticket != null) {
      Future.delayed(
        Duration.zero,
        () async {
          final GoogleMapController controller = await mapController.future;
          final location = await googleMapService.determinePosition(
              controller, widget.ticket!.address);
          if (location == null) {
            wrongAddressDialog();
          } else {
            setState(() {
              googleMapService.updateMarkers(
                  _markers, location, widget.ticket!.address);
            });
          }
        },
      );
    }
  }

  static const CameraPosition eua = CameraPosition(
    target: LatLng(37.37666371556644, -103.80547631531954),
  );

  //  Dialog to show when the search for the address provide return no results
  void wrongAddressDialog() {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'))
        ],
        content: const Text('No results for the address provide'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Instace of GoogleMaps
            GoogleMap(
              initialCameraPosition: eua,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.normal,
              markers: _markers,
            ),
            CustomizedBackButton(theme: theme),
            Positioned(
                top: 80,
                left: 10,
                right: 10,
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 70),
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          onTap: () async {
                            final GoogleMapController controller =
                                await mapController.future;
                            final location =
                                await googleMapService.determinePosition(
                                    controller, searchController.text);
                            if (location == null) {
                              wrongAddressDialog();
                            } else {
                              setState(() {
                                googleMapService.updateMarkers(
                                    _markers, location, searchController.text);
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(148, 87, 235, 0.9),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.search,
                              size: 30,
                              color: theme.canvasColor,
                            ),
                          ),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
