class Recipe {
  late String label;
  late String image;
  late String url;
  List<String> ingredientLines = [];

  Recipe(this.label, this.image, this.url);

  Recipe.fromJson(Map<String, dynamic> json) {
    label = json['label'] ?? '';
    image = json['image'] ?? '';
    url = json['url'] ?? '';
    ingredientLines = List<String>.from(json['ingredientLines'] ?? []);
  }
}