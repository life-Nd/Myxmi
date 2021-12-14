class ProductModel {
  static const _expiration = 'expiration';
  static const _ingredientType = 'ingredientType';
  static const _mesureType = 'mesureType';
  static const _name = 'name';
  static const _left = 'left';
  String? productId;
  String? expiration;
  String? ingredientType;
  String? mesureType;
  String? name;
  String? left;

  ProductModel({
    this.productId,
    this.expiration,
    this.ingredientType,
    this.mesureType,
    this.name,
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _expiration: expiration,
      _ingredientType: ingredientType,
      _mesureType: mesureType,
      _name: name,
      _left: left,
    };
  }
}
