import 'package:alphawash/view/screens/location/add_location_screen.dart';
import 'package:alphawash/view/screens/location/edit_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:provider/provider.dart';

class AutocompleteSearch extends StatefulWidget {
  AutocompleteSearch({Key? key, this.newArea}) : super(key: key);

  final bool? newArea;

  @override
  _AutocompleteSearchState createState() => _AutocompleteSearchState();
}

class _AutocompleteSearchState extends State<AutocompleteSearch> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<LocationProvider>(context, listen: false).setMapVisibility(true);
        if(widget.newArea == true){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
              AddLocationScreen()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
              EditAreaScreen(area:
              Provider.of<LocationProvider>(context, listen: false).selectedArea,
                  fromAutoCompleteSearch: true)));
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: InkWell(
                onTap: () {
                  Provider.of<LocationProvider>(context, listen: false).setMapVisibility(true);

                  if(widget.newArea == true){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                        AddLocationScreen()));
                  }else{
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                        EditAreaScreen(area:
                        Provider.of<LocationProvider>(context, listen: false).selectedArea,
                            fromAutoCompleteSearch: true)));
                  }

                },
                child: const Icon(Icons.close, color: Colors.black87)),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),

              placesAutoCompleteTextField(),

            ],
          ),
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return
      Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: controller, // when text contains (#) message shows: the provided api key is invalid
              googleAPIKey: AppConstants.API_KEY,
              inputDecoration: InputDecoration(
                hintText: "Search your location",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              debounceTime: 400,
              countries: ["co"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                print("placeDetails" + prediction.lat.toString());
                Provider.of<LocationProvider>(context, listen: false).updateSearchLocation(context,
                    controller.text,
                    double.parse(prediction.lat!),
                    double.parse(prediction.lng!)
                );

                if(widget.newArea == true){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                      AddLocationScreen()));
                }else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                      EditAreaScreen(area:
                      Provider.of<LocationProvider>(context, listen: false).selectedArea,
                          fromAutoCompleteSearch: true)));
                }

              },

              itemClick: (Prediction prediction) {
                controller.text = prediction.description ?? "";
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0));

              },
              seperatedBuilder: Divider(),
              // OPTIONAL// If you want to customize list view item builder
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(child: Text("${prediction.description??""}"))
                    ],
                  ),
                );
              },

              isCrossBtnShown: true,

              // default 600 ms ,
            ),
          );
        });

  }
}