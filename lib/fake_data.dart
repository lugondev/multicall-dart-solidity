import 'dart:convert';
import 'dart:io';

import 'package:web3dart/web3dart.dart';

class Token {
  late EthereumAddress address;
  late int decimals;

  static fromJson(jsonObject) {
    Token t = Token();
    t.address = EthereumAddress.fromHex(jsonObject["address"]);
    t.decimals = jsonObject["decimals"];
    return t;
  }
}

List<Token> fakeTokensList() {
  String tokensList = File('lib/fake_list_token_backend.json').readAsStringSync();
  List tokens = json.decode(tokensList);
  return List<Token>.from(tokens.map((token) => Token.fromJson(token)));
}
