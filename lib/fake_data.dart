import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:web3dart/crypto.dart' as crypto;
import 'package:web3dart/web3dart.dart';

class Token {
  late EthereumAddress address;
  late int decimals;
  late BigInt bigBalanceOf;
  late double balanceOf;

  static fromJson(jsonObject) {
    Token t = Token();
    t.address = EthereumAddress.fromHex(jsonObject["address"]);
    t.decimals = jsonObject["decimals"];
    return t;
  }

  setBalance(Uint8List bytes) {
    bigBalanceOf = crypto.bytesToUnsignedInt(bytes);
    String hexBalanceOf = hex.encode(bytes).toString();
    BigInt decimalsPow = BigInt.from(10).pow(decimals);

    balanceOf = BigInt.parse(hexBalanceOf, radix: 16) / decimalsPow;
  }
}

List<Token> fakeTokensList() {
  String tokensList = File('lib/fake_list_token_backend.json').readAsStringSync();
  List tokens = json.decode(tokensList);
  return List<Token>.from(tokens.map((token) => Token.fromJson(token)));
}
