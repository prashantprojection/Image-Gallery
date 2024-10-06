class ImageResolution {
  final String url;
  final int width;
  final int height;

  ImageResolution({
    required this.url,
    required this.width,
    required this.height,
  });
}

class ImageModel {
  final int id;
  final String pageURL;
  final String type;
  final String tags;
  final String previewURL;
  final int previewWidth;
  final int previewHeight;
  final String webformatURL;
  final int webformatWidth;
  final int webformatHeight;
  final String largeImageURL;
  final int imageWidth;
  final int imageHeight;
  final int imageSize;
  final int views;
  final int downloads;
  final int collections;
  final int likes;
  final int comments;
  final int userId;
  final String user;
  final String userImageURL;

  // List for all the resolution of the image
  final List<ImageResolution> resolutions;

  ImageModel({
    required this.id,
    required this.pageURL,
    required this.type,
    required this.tags,
    required this.previewURL,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatURL,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageURL,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.collections,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageURL,
    required this.resolutions,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      pageURL: json['pageURL'],
      type: json['type'],
      tags: json['tags'],
      previewURL: json['previewURL'],
      previewWidth: json['previewWidth'],
      previewHeight: json['previewHeight'],
      webformatURL: json['webformatURL'],
      webformatWidth: json['webformatWidth'],
      webformatHeight: json['webformatHeight'],
      largeImageURL: json['largeImageURL'],
      imageWidth: json['imageWidth'],
      imageHeight: json['imageHeight'],
      imageSize: json['imageSize'],
      views: json['views'],
      downloads: json['downloads'],
      collections: json['collections'],
      likes: json['likes'],
      comments: json['comments'],
      userId: json['user_id'],
      user: json['user'],
      userImageURL: json['userImageURL'],
      resolutions: [
        ImageResolution(
          url: json['previewURL'],
          width: json['previewWidth'],
          height: json['previewHeight'],
        ),
        ImageResolution(
          url: json['webformatURL'],
          width: json['webformatWidth'],
          height: json['webformatHeight'],
        ),
        ImageResolution(
          url: json['largeImageURL'],
          width: json['imageWidth'],
          height: json['imageHeight'],
        ),
      ],
    );
  }

  // Method to convert the model to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageURL': pageURL,
      'type': type,
      'tags': tags,
      'previewURL': previewURL,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatURL,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageURL,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'collections': collections,
      'likes': likes,
      'comments': comments,
      'user_id': userId,
      'user': user,
      'userImageURL': userImageURL,
      'resolutions': resolutions
          .map((res) => {
                'url': res.url,
                'width': res.width,
                'height': res.height,
              })
          .toList(),
    };
  }
}
