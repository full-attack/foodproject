class Reciept {
  late String label;
  late String image;
  late String url;

  Reciept(this.label, this.image, this.url);

  Reciept.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    label = json['label'];
    label = json['label'];
  }
}