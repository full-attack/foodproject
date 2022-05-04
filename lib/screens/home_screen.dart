import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../models/reciept.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  File? imageFile;
  List<String> foodNames = [];
  List<String> recipeNames = [];
  TextEditingController foodNamesTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Загрузите фото, на котором видны Ваши продукты. К примеру это может быть фото холодильника',
                  style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Palanquin'),
                ),
                if (imageFile != null)
                  Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: FileImage(imageFile!), fit: BoxFit.cover),
                      //border: Border.all(width: 8, color: Colors.black),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  )
                else
                  Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffa7c8fd),
                      //border: Border.all(width: 8, color: Colors.black12),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: const Text(
                      'Image should appear here',
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 30,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Palanquin'),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () => getImage(source: ImageSource.camera),
                          child: const Text('Capture Image',
                              style: TextStyle(fontSize: 18))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () =>
                              getImage(source: ImageSource.gallery),
                          child: const Text('Select Image',
                              style: TextStyle(fontSize: 18))),
                    ),
                  ],
                ),
                Container(
                  height: 300,
                  child: Material(
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      controller: foodNamesTextController,
                    ),
                  ),
                ),
                // Material(
                //     child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           ...foodNames.map((e) => Text(e))
                //         ]
                //     )
                // ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: Text("Распознать продукты"),
                  onPressed: () => getFoodNames(imageFile!),
                  //color: Color(0xff24997f),
                  //textColor: Colors.white,
                  //shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
                ElevatedButton(
                  child: Text("Перейти к списку продуктов"),
                  onPressed: () {
                    var foodNames = foodNamesTextController.text
                        .trim()
                        .split('\n')
                        .map((e) => e.trim())
                        .where((element) => element.isNotEmpty)
                        .toList();
                    getRecipes(foodNames);
                  },
                  //color: Color(0xff24997f),
                  //textColor: Colors.white,
                  //shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.all(Radius.circular(25))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [...recipeNames.map((e) => Text(e))])),
                ),
                // Container(
                //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                //     height: 100,
                //     child: Card(
                //         child: FutureBuilder(
                //           future: Upload(imageFile!),
                //           builder: (context, snapshot) {
                //             if (snapshot.data == null) {
                //               return Container()
                //             }
                //
                //           },
                //         )
                //     )
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 70 //0 - 100
    );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }

  Future getFoodNames(File imageFile) async {
    var headers = {
      'Authorization': 'Bearer b63354c6aed233ca536839df9a4f4764d97151d6'
    };
    var request1 = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.logmeal.es/v2/image/recognition/complete/v1.0?language=eng'));
    request1.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request1.headers.addAll(headers);

    http.StreamedResponse response1 = await request1.send();
    foodNames = [];
    foodNamesTextController.clear();

    if (response1.statusCode == 200) {
      var s = (await response1.stream.bytesToString());
      var body = jsonDecode(s)['recognition_results'] as List;

      foodNames = body.map((e) => e['name'] as String).toList();
      foodNamesTextController.text = foodNames.join('\n');
    }

    setState(() {});
  }

  Future getRecipes(List<String> foodNames) async {
    recipeNames = [];
    print('Looking for ${foodNames}');
    if (foodNames.isEmpty) {
      return;
    }
    var request2 = http.Request(
        'GET',
        Uri.parse(
            'https://api.edamam.com/api/recipes/v2?app_id=11a8f975&app_key=02161a656317e22305c5d3880a77178a&type=public&q=${foodNames
                .join(',')}'));
    print(request2.url);
    http.StreamedResponse response2 = await request2.send();

    if (response2.statusCode == 200) {
      var r = (await response2.stream.bytesToString());
      var hits = jsonDecode(r)['hits'] as List;
      var reciepts = hits.map((e) => Reciept.fromJson(e['recipe'])).toList();
      recipeNames = reciepts.map((e) => e.label).toList();
      // .map((e) => e['recipe']?['label'] as String? ?? '')
      // .where((element) => element.isNotEmpty)
      // .toList();
      print("recipeNames: $recipeNames");
    } else {
      print(response2.reasonPhrase);
    }
      setState(() {});
    }
  }
