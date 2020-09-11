
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class idPrefs{

  // int id;
  // idPrefs(this.id);
  SharedPreferences _prefs;

  setPref(int id)async{
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('id', id);

  }

  Future<int> getPref()async
  {
    _prefs= await SharedPreferences.getInstance();
    int id = _prefs.getInt('id')??5;
    return id;
  }

}
