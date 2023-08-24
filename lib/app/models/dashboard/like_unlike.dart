class LikeUnlike {
  bool? isLiked;
  int? likeCount;

  LikeUnlike({this.isLiked, this.likeCount});

  LikeUnlike.fromJson(Map<String, dynamic> json) {
    isLiked = json['isLiked'] ?? false;
    likeCount = int.parse(json['likeCount'].toString());
  }
}
