import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  File? imageFile;
  List<String> foodNames = [];

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
                Material(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          foodNames.map((e) => Text(e))
                        ]
                    )
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: Text("Перейти к списку рецептов"),
                  onPressed: () => Upload(imageFile!),
                  //color: Color(0xff24997f),
                  //textColor: Colors.white,
                  //shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.all(Radius.circular(25))),
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


  Future Upload(File imageFile) async {
    var headers = {
      'Authorization': 'Bearer dc14a17ca4e34b79e0cf0773ac83df914e7e15f7'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.logmeal.es/v2/image/recognition/complete/v1.0?language=eng'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    foodNames = [];

    if (response.statusCode == 200) {
      var s = (await response.stream.bytesToString());
      var body = jsonDecode(s)['recognition_results'] as List;
      setState((){
        foodNames = body.map((e) => e['name'] as String).toList();
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}