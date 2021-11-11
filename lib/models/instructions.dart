import 'package:flutter/material.dart';

class InstructionsModel {
  static const _ingredients = 'ingredients';
  static const _steps = 'steps';
  static const _comments = 'comments';
  static const _uid = 'uid';
  List steps = [];
  Map ingredients = {};
  List comments = [];
  String uid = '';
  InstructionsModel(
      {@required this.ingredients,
      @required this.steps,
      this.comments,
      this.uid});

  void fromSnapshot({Map<String, dynamic> snapshot}) {
    ingredients = snapshot[_ingredients] as Map;
    steps = snapshot[_steps] as List;
    comments = snapshot[_comments] as List;
    uid = snapshot[_uid] as String;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _ingredients: ingredients,
      _steps: steps,
      _comments: comments,
      _uid: uid,
    };
  }
}
