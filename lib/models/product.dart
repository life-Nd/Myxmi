class ProductModel {
  static const _expiration = 'expiration';
  static const _ingredientType = 'ingredientType';
  static const _mesureType = 'mesureType';
  static const _name = 'name';
  static const _left = 'left';
  static const _imageUrl = 'imageUrl';
  String? productId;
  String? expiration;
  String? ingredientType;
  String? mesureType;
  String? name;
  String? left;
  String? imageUrl;
  ProductModel({
    this.productId,
    this.expiration,
    this.ingredientType,
    this.mesureType,
    this.name,
    this.imageUrl,
    this.left = '0.0',
  });

  factory ProductModel.fromSnapshot({
    required Map<String, dynamic> snapshot,
    String? keyIndex,
  }) {
    return ProductModel(
      productId: keyIndex,
      expiration: snapshot[_expiration] as String?,
      ingredientType: snapshot[_ingredientType] as String?,
      mesureType: snapshot[_mesureType] as String?,
      name: snapshot[_name] as String?,
      left: snapshot[_left] as String?,
      imageUrl: snapshot[_imageUrl] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _expiration: expiration,
      _ingredientType: ingredientType,
      _mesureType: mesureType,
      _name: name,
      _left: left,
      _imageUrl: imageUrl,
    };
  }
}
