import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/recipe.dart';

class RecipeWidget extends StatelessWidget {

  Recipe recipe;

  RecipeWidget(this.recipe);

  Map<String, bool> checked = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe.image),
                  fit: BoxFit.cover
                )
              ),
              height: MediaQuery.of(context).size.height * 2/5 + 20,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF3F5F6),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow()
                ]
              ),
              padding: EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 3/5,
              child: Column(
                children: [
                  Text(recipe.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                  SizedBox(height: 8.0,),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (context, setState) =>
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...recipe.ingredientLines.map((e) => CheckboxListTile(
                            visualDensity: VisualDensity.compact,
                              dense: true,

                              value: checked[e] ?? false,
                              onChanged: (v){
                                setState((){
                                  checked[e] = v!;
                                });
                              },
                              title: Text(e)))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            top: MediaQuery.of(context).size.height * 2/5 - 36,
            child: RawMaterialButton(
              onPressed: () {
                launchUrlString(recipe.url.replaceAll('http://', 'https://'));
              },
              elevation: 2.0,
              fillColor: Colors.green,
              child: Icon(
                Icons.search,
                size: 25.0,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}