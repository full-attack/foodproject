import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fprojectfood/constants.dart';
import 'package:fprojectfood/screens/recipe_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  File? imageFile;
  List<String> foodNames = ['apple', 'banana', 'milk', 'eggs'];
  List<Recipe> recipes = [];
  bool loading = false;
  TextEditingController foodNamesTextController = TextEditingController();
  CameraController? _cameraController;

  @override
  void initState() {
    initCameraController();
    foodNamesTextController.text = foodNames.join('\n');
    super.initState();
  }

  Future initCameraController() async {
    _cameraController = null;
    await availableCameras().then((value) async {
      var cameras = value;
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
            cameras.first, ResolutionPreset.medium,
            imageFormatGroup: ImageFormatGroup.jpeg);
        print('initinh...');
        await _cameraController!.initialize();
        print('done');
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var pages = [
      mainPage(),
      recipePage(),
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Recipes')
        ],
        onTap: (v) => setState(() {
          currentPageIndex = v;
        }),
      ),
    );
  } // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: backgroundColor,
  //     body: LayoutBuilder(
  //       builder: (BuildContext context, BoxConstraints viewportConstraints) {
  //         return SingleChildScrollView(
  //           child: ConstrainedBox(
  //             constraints:
  //             BoxConstraints(minHeight: viewportConstraints.maxHeight),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const SizedBox(
  //                   height: 30,
  //                 ),
  //                 Text(
  //                   'Загрузите фото, на котором видны Ваши продукты. К примеру это может быть фото холодильника',
  //                   style: TextStyle(
  //                       color: Color(0xffffffff),
  //                       fontSize: 20,
  //                       decoration: TextDecoration.none,
  //                       fontWeight: FontWeight.w500,
  //                       fontFamily: 'Palanquin'),
  //                 ),
  //                 if (imageFile != null)
  //                   Container(
  //                     width: 300,
  //                     height: 300,
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey,
  //                       image: DecorationImage(
  //                           image: FileImage(imageFile!), fit: BoxFit.cover),
  //                       //border: Border.all(width: 8, color: Colors.black),
  //                       borderRadius: BorderRadius.circular(15.0),
  //                     ),
  //                   )
  //                 else
  //                   Container(
  //                     width: 300,
  //                     height: 300,
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       color: Color(0xffa7c8fd),
  //                       //border: Border.all(width: 8, color: Colors.black12),
  //                       borderRadius: BorderRadius.circular(15.0),
  //                     ),
  //                     child: const Text(
  //                       'Image should appear here',
  //                       style: TextStyle(
  //                           color: Color(0xffffffff),
  //                           fontSize: 30,
  //                           decoration: TextDecoration.none,
  //                           fontWeight: FontWeight.w500,
  //                           fontFamily: 'Palanquin'),
  //                     ),
  //                   ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: ElevatedButton(
  //                           onPressed: () => getImage(source: ImageSource.camera),
  //                           child: const Text('Capture Image',
  //                               style: TextStyle(fontSize: 18))),
  //                     ),
  //                     const SizedBox(
  //                       width: 20,
  //                     ),
  //                     Expanded(
  //                       child: ElevatedButton(
  //                           onPressed: () =>
  //                               getImage(source: ImageSource.gallery),
  //                           child: const Text('Select Image',
  //                               style: TextStyle(fontSize: 18))),
  //                     ),
  //                   ],
  //                 ),
  //                 Container(
  //                   height: 300,
  //                   child: Material(
  //                     child: TextField(
  //                       maxLines: null,
  //                       expands: true,
  //                       controller: foodNamesTextController,
  //                     ),
  //                   ),
  //                 ),
  //                 // Material(
  //                 //     child: Column(
  //                 //         mainAxisSize: MainAxisSize.min,
  //                 //         children: [
  //                 //           ...foodNames.map((e) => Text(e))
  //                 //         ]
  //                 //     )
  //                 // ),
  //                 const SizedBox(
  //                   height: 30,
  //                 ),
  //                 ElevatedButton(
  //                   child: Text("Распознать продукты"),
  //                   onPressed: () => getFoodNames(imageFile!),
  //                   //color: Color(0xff24997f),
  //                   //textColor: Colors.white,
  //                   //shape: RoundedRectangleBorder(
  //                   //borderRadius: BorderRadius.all(Radius.circular(25))),
  //                 ),
  //                 ElevatedButton(
  //                   child: Text("Перейти к списку продуктов"),
  //                   onPressed: () {
  //                     var foodNames = foodNamesTextController.text
  //                         .trim()
  //                         .split('\n')
  //                         .map((e) => e.trim())
  //                         .where((element) => element.isNotEmpty)
  //                         .toList();
  //                     getRecipes(foodNames);
  //                   },
  //                   //color: Color(0xff24997f),
  //                   //textColor: Colors.white,
  //                   //shape: RoundedRectangleBorder(
  //                   //borderRadius: BorderRadius.all(Radius.circular(25))),
  //                 ),
  //                 const SizedBox(
  //                   height: 30,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Material(
  //                       child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [...recipeNames.map((e) => Text(e))])),
  //                 ),
  //                 // Container(
  //                 //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
  //                 //     height: 100,
  //                 //     child: Card(
  //                 //         child: FutureBuilder(
  //                 //           future: Upload(imageFile!),
  //                 //           builder: (context, snapshot) {
  //                 //             if (snapshot.data == null) {
  //                 //               return Container()
  //                 //             }
  //                 //
  //                 //           },
  //                 //         )
  //                 //     )
  //                 // )
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Future getImage({required ImageSource source}) async {
    if (_cameraController == null) {
      final file = await ImagePicker().pickImage(
          source: source,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 80 //0 - 100
          );

      if (file?.path != null) {
        foodNames.clear();
        recipes.clear();
        setState(() {
          imageFile = File(file!.path);
        });
      }
    } else {
      var pic = await _cameraController!.takePicture();
      foodNames.clear();
      recipes.clear();
      setState(() {
        imageFile = File(pic.path);
      });
    }
    //   // _cameraController = CameraController(cameras.first, ResolutionPreset.low);
    // }
    // initCameraController();
  }

  Future getFoodNames(File imageFile) async {
    var headers = {
      'Authorization': 'Bearer aea9217748817471a5af8ada6bd839a457addcf1'
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

  Future<void> getRecipes(List<String> foodNames) async {
    recipes = [];
    print('Looking for ${foodNames}');
    if (foodNames.isEmpty) {
      return;
    }
    var request2 = http.Request(
        'GET',
        Uri.parse(
            'https://api.edamam.com/api/recipes/v2?app_id=11a8f975&app_key=02161a656317e22305c5d3880a77178a&type=public&q=${foodNames.join(',')}'));
    print(request2.url);
    http.StreamedResponse response2 = await request2.send();

    if (response2.statusCode == 200) {
      var r = (await response2.stream.bytesToString());
      var hits = jsonDecode(r)['hits'] as List;
      recipes = hits.map((e) => Recipe.fromJson(e['recipe'])).toList();
      // .map((e) => e['recipe']?['label'] as String? ?? '')
      // .where((element) => element.isNotEmpty)
      // .toList();
      print("recipeNames: $recipes");
    } else {
      print(response2.reasonPhrase);
    }
    setState(() {});
  }

  Widget mainPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: InkWell(
                onTap: () async {
                  await getImage(source: ImageSource.camera);
                  setState(() {
                    loading = true;
                  });
                  if (imageFile != null) {
                    await getFoodNames(imageFile!);
                  }
                  setState(() {
                    loading = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    children: [
                      LayoutBuilder(builder: (context, constrains) {
                        if (imageFile != null) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  child: Image.file(
                                    imageFile!,
                                    width: constrains.maxWidth,
                                    fit: BoxFit.fill,
                                  )),
                              Positioned(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (!loading) {
                                      setState(() {
                                        imageFile = null;
                                      });
                                    }
                                  },
                                ),
                                top: 8.0,
                                right: 8.0,
                              ),
                              if (loading) CircularProgressIndicator()
                            ],
                          );
                        }
                        return _cameraController == null
                            ? Container(
                          color: blue,
                          height: constrains.maxWidth,
                          alignment: Alignment.center,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 99,
                              )),
                        )
                            : AspectRatio(
                          aspectRatio:
                          1 / _cameraController!.value.aspectRatio,
                          child: CameraPreview(
                            _cameraController!,
                          ),
                        );
                      }),
                      Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        height: 100,
                        child: Text(
                          'Take photos of your products',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (imageFile != null)
              Container(
                margin: EdgeInsets.only(top: 16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Container(
                  height: 300,
                  child: Material(
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black26),
                        hintText: 'Here will be your products',
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      controller: foodNamesTextController,
                    ),
                  ),
                ),
              ),
            if (imageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green[400],
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    highlightColor: Colors.green[500],
                    splashColor: Colors.green[700],
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      var products = foodNamesTextController.text.split('\n').where((element) => element.isNotEmpty).toList();
                      if (products.isNotEmpty) {
                        setState(() {
                          loading = true;
                        });
                        try {
                          await getRecipes(products);
                        } catch (_) {}
                        setState(() {
                          currentPageIndex = 1;
                          loading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add products')));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      height: 64,
                      alignment: Alignment.center,
                      child: Text(
                        'Find Recipes',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget recipePage() {
     return SafeArea(
       child: Container(
         padding: const EdgeInsets.all(24.0),
         child: Column(
           children: [
         Padding(
         padding: const EdgeInsets.only(bottom: 16.0),
         child: ClipRRect(
           clipBehavior: Clip.hardEdge,
           borderRadius: BorderRadius.circular(32),
           child: Container(
               alignment: Alignment.topCenter,
               color: Colors.white,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                 child: Text(recipes.isEmpty ?
                 "Eh... while there's nothing, take a picture!"
                     : 'Wow! Found  ${recipes.length} recipes'
                   , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
               )
           ),
         ),
       ),
       Expanded(
         child: ListView.builder(
                 itemExtent: 396,
                 shrinkWrap: true,
                 itemCount: recipes.length,
                 itemBuilder: (context, index) {
                   var item = recipes[index];
                   return Padding(
                     padding: const EdgeInsets.only(bottom: 16.0),
                     child: ClipRRect(
                       clipBehavior: Clip.hardEdge,
                       borderRadius: BorderRadius.circular(32),
                       child: Container(
                         height: 400,
                         alignment: Alignment.center,
                         child: InkWell(
                           onTap: () {
                             Navigator.of(context).push(
                                 MaterialPageRoute(
                                     builder: (context) =>
                                         RecipeWidget(item)));
                           },
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               FittedBox(
                                   fit: BoxFit.fill,
                                   alignment: Alignment.center,
                                   child: Transform.scale(
                                       scale: 1.1,
                                       child: item.image.isEmpty ? Image.asset('assets/images/bgPattern.jpg') : Image.network(item.image, errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/bgPattern.jpg'),))),
                               Container(
                                   alignment: Alignment.topCenter,
                                   height: 80,
                                   color: Colors.white,
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(item.label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                   )
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                   );
                 },


               ),


       ),
           ],
         ),
       )
     );
  }
}
