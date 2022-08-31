import 'package:dart_web3_multicall/dart_web3_multicall.dart' as dart_web3_multicall;
import 'package:dart_web3_multicall/multicall.dart' as multicall;
import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';

var apiUrl = "https://data-seed-prebsc-1-s1.binance.org:8545"; //Replace with your API

var httpClient = Client();
var ethClient = Web3Client(apiUrl, httpClient);
var multicallContract = EthereumAddress.fromHex("0x7aa35985B617416F502afC69b25aB9dBF7FDd0a1");

var token1 = EthereumAddress.fromHex("0x4F32336a6032BA3763D533853224f743b3C8eE88");
var token2 = EthereumAddress.fromHex("0x8085c02665f2BC0975Bd69C747D1918c3154e5c0");

void main(List<String> arguments) async {
  print('Hello world: ${dart_web3_multicall.calculate()}!');

  List<dynamic> results = await multicall.getTokenDetails(ethClient, multicallContract, token1);
  print(results);
}
