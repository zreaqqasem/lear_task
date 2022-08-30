// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lear_task/AppComponents/rounded_button.dart';
import 'package:lear_task/Utils/shared.dart';
import 'package:native_dialog/native_dialog.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../AppStates/quote_states.dart';
import '../../../Utils/notification_manager.dart';
import '../../../Utils/snack_bar.dart';
import '../../../ViewModels/quote_view_model.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late BitmapDescriptor customIcon;
  final LocalStorage storage = LocalStorage('local');
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLatLng;
  late LocationPermission permission;
  Set<Marker> markers = <Marker>{};
  late QuoteViewModel _quoteViewModel;

  @override
  void initState() {
    _quoteViewModel = QuoteViewModel();
    super.initState();
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(17, 17)),
            'assets/images/icons8-person-64.png')
        .then((d) {
      customIcon = d;
    });
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    final confirmed = await NativeDialog.confirm(
                        "Do you really want to delete prev inspirations?");
                    if (confirmed) {
                      storage.deleteItem('data');
                    }
                  } on PlatformException catch (error) {return;}
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  showPlacePicker();
                },
                icon: const Icon(Icons.add)),
          ],
          backgroundColor: Colors.blueGrey,
          title: const Text("Map Screen"),
        ),
        body: currentLatLng == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      markers: markers,
                      initialCameraPosition:
                          CameraPosition(target: currentLatLng!, zoom: 17),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  _sendQuoteUi(),
                ],
              ));
  }

  _sendQuoteUi() {
    return BlocProvider(
      create: (context) => _quoteViewModel,
      child: BlocConsumer<QuoteViewModel, QuoteApiState>(
        listener: (context, state) {
          if (state is QuoteApiError) {
            AppSnackBar().showSnackBar("error", () {}, context);
          }
        },
        builder: (context, state) {
          if (state is QuoteApiInitial) {
            return _quoteUi(true);
          } else if (state is QuoteApiLoading) {
            return _quoteUi(false);
          } else if (state is QuoteApiCompleted) {

               NativeDialog.alert(
                  state.response[0].q);
            NotificationUtils.sendNotification(Shared.fcm, "New Quote", state.response[0].q, "code", {});
            return _quoteUi(true);
          } else {
            return _quoteUi(true);
          }
        },
      ),
    );
  }

  // check if user give the need permission.
  checkLocationPermission() async {
    PermissionStatus result;
    result = await Permission.location.request();
    if (result.isGranted) {
      Geolocator.getCurrentPosition().then((currLocation) {
        setState(() {
          currentLatLng = LatLng(currLocation.latitude, currLocation.longitude);
          checkIfWasHereBefore(currLocation.latitude, currLocation.longitude);
          markers.add(Marker(
              markerId: const MarkerId("mark"),
              icon: customIcon,
              position: LatLng(currLocation.latitude, currLocation.longitude)));
        });
      });
    } else {}
  }

  //open and let user pick new inspiration place.
  void showPlacePicker() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: "AIzaSyCslAMvsL0TWwdwsXs08cbcmFjWP9a3OMI",
          onPlacePicked: (result) {
            Navigator.of(context).pop();
            calculateDistance(currentLatLng!.latitude, currentLatLng!.longitude,
                result.geometry!.location.lat, result.geometry!.location.lng);
          },
          initialPosition: currentLatLng!,
          useCurrentLocation: true,
        ),
      ),
    );
  }
  //quoteButtonUi
  _quoteUi(enabled){
    return RoundedButton(
        text: "Send Quote",
        isLoading: !enabled,
        enabled: enabled,
        press: () {
          _quoteViewModel.getQuote();
        },
        color: Colors.blueGrey,
        textColor: Colors.white,
        width: MediaQuery.of(context).size.width,
        cornerRadius: 10,
        height: MediaQuery.of(context).size.height * 0.08);
  }

  //check if user where here before in range 1km if yes send notification.
  checkIfWasHereBefore(lat1, lon1) {
    if (storage.getItem('data') != null) {
      var list = storage.getItem('data') as List<dynamic>;
      list.contains([lat1, lon1]) ? print("") : list.add([lat1, lon1]);
      storage.setItem('data', list);
      for (var element in list) {
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 -
            c((element[0] - lat1) * p) / 2 +
            c(lat1 * p) *
                c(element[0] * p) *
                (1 - c((element[1] - lon1) * p)) /
                2;
        final distance = 12742 * asin(sqrt(a));
        if ((0 <= distance && distance <= 1) ||
            (0 >= distance && distance >= -1)) {
          NotificationUtils.showLocalNotification(
              context, "welcome again", "you where here before!", (index) {});
          return;
        }
      }
    } else {
      storage.setItem('data', [
        [lat1, lon1]
      ]);
    }
  }

  //calculate distance between picked location if in range 1 km to user location propt notification.
  Future<void> calculateDistance(lat1, lon1, lat2, lon2) async {
    if (storage.getItem('data') != null) {
      var list = storage.getItem('data') as List<dynamic>;
      list.add([
        [lat2, lon2]
      ]);
      storage.setItem('data', list);
    } else {
      storage.setItem('inspiration', [
        [lat2, lon2]
      ]);
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    final distance = 12742 * asin(sqrt(a));
    if ((0 <= distance && distance <= 1) || (0 >= distance && distance >= -1)) {
      NotificationUtils.showLocalNotification(
          context, "welcome again", "you where here before!", (index) {});
      return;
    }
  }
}
