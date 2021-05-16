class Elocation {
  int id;
  String description;
  String title;
  String address;
  String city;
  String state;
  String category;
  String image;

  Elocation(this.id, this.title, this.description, this.address, this.city,
      this.state, this.category, this.image);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'category': category,
      'image': image
    };
    return map;
  }

  Elocation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    address = map['address'];
    city = map['city'];
    state = map['state'];
    category = map['category'];
    image = map['image'];
  }

  @override
  String toString() {
    return "Elocation => (id: $id, description: $description, title: $title, address: $address, city: $city, state: $state, category: $category, image: $image)";
  }
}
