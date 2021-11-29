class newsmodel {
  late String title;
  late String url;
  late String source;

  newsmodel({required this.title, required this.url, required this.source});

  newsmodel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    data['source'] = this.source;
    return data;
  }
}