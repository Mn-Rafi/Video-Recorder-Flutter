import 'dart:typed_data';

class Videomodel {
  String path;
  String name;
  Uint8List? thumbnail;
  Videomodel({required this.name, required this.path, this.thumbnail});
}
