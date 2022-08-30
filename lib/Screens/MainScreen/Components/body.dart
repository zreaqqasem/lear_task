import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lear_task/AppComponents/rounded_button.dart';
import 'package:lear_task/AppStates/image_api_states.dart';
import 'package:lear_task/Screens/MapScreen/map_screen.dart';
import 'package:lear_task/Utils/shared.dart';
import 'package:lear_task/ViewModels/quote_view_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Utils/snack_bar.dart';
import '../../../ViewModels/main_screen_view_model.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late ImageViewModel _homeViewModel;
  late QuoteViewModel _quoteViewModel;

  @override
  void initState() {
    _homeViewModel = ImageViewModel();
    _quoteViewModel = QuoteViewModel();
    _homeViewModel.getImageUrl().asStream();
    _getFcm();
    super.initState();
  }

  @override
  void dispose() {
    _homeViewModel.close();
    _quoteViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return  BlocProvider(
      create: (context) => _homeViewModel,
      child: BlocConsumer<ImageViewModel, ImageApiState>(
        listener: (context, state) {
          if (state is ImageApiError) {
            AppSnackBar().showSnackBar(state.message, () {}, context);
          }
        },
        builder: (context, state) {
          if (state is ImageApiInitial) {
            return _loadingUi(context);
          } else if (state is ImageApiLoading) {
            return _loadingUi(context);
          } else if (state is ImageApiCompleted) {
            return _buildUi(context, state.response);
          } else {
            return _loadingUi(context);
          }
        },
      ),
   );
  }

  _getFcm() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    var token = await fcm.getToken();
    Shared.fcm = token!;
  }
  _buildUi(BuildContext context, String imagePath) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: _getImageUrl(imagePath),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => const CupertinoActivityIndicator(
              radius: 20,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          child: Row(
            children: [
              const Spacer(),
              RoundedButton(
                  text: "Map",
                  isLoading: false,
                  enabled: true,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapScreen()),
                    );
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.3,
                  cornerRadius: 10,
                  height: MediaQuery.of(context).size.height * 0.05),
              const Spacer(),
              RoundedButton(
                  text: "Refresh",
                  isLoading: false,
                  enabled: true,
                   press: () async {
                      _homeViewModel.getImageUrl();
                      },
                  color: Colors.red,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.3,
                  cornerRadius: 10,
                  height: MediaQuery.of(context).size.height * 0.05),
              const Spacer(),
              RoundedButton(
                  text: "Share",
                  isLoading: false,
                  enabled: true,
                  press: () {
                    _share('see the image inspiration from this url:  $imagePath');
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.3,
                  cornerRadius: 10,
                  height: MediaQuery.of(context).size.height * 0.05),
              const Spacer(),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  _loadingUi(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          child: const CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
        const Spacer(),
        Expanded(
          child: Row(
            children: [
              const Spacer(),
              RoundedButton(
                  text: "Map",
                  isLoading: false,
                  enabled: true,
                  press: () {},
                  color: Colors.red,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.3,
                  cornerRadius: 10,
                  height: MediaQuery.of(context).size.height * 0.05),
              const Spacer(),
              RoundedButton(
                  text: "Refresh",
                  isLoading: false,
                  enabled: false,
                  press: () {},
                  color: Colors.red,
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.3,
                  cornerRadius: 10,
                  height: MediaQuery.of(context).size.height * 0.05),
              const Spacer(),
            RoundedButton(
                text: "Share",
                isLoading: false,
                enabled: false,
                press: () {},
                color: Colors.red,
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width * 0.3,
                cornerRadius: 10,
                height: MediaQuery.of(context).size.height * 0.05),
              const Spacer(),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Future<void> _share(String quote) async {
    Share.share(quote);
  }

  String _getImageUrl(String response) {
    final imagePath = response.split("/").last;
    return "https://generated.inspirobot.me/a/$imagePath";
  }
}
