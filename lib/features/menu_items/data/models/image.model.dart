import 'package:food_app/common/configuration/sqflie.config.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';

class ImageModel extends Photo {
  ImageModel({required super.imageName, super.id});

  Map<String, dynamic> toJson() => {
        ImageFiled.imageId: id,
        ImageFiled.imageString: imageName,
      };
  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json[ImageFiled.imageId],
        imageName: json[ImageFiled.imageString],
      );
}
