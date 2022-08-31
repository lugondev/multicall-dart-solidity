import 'package:dart_web3_multicall/dart_web3_multicall.dart' as dart_web3_multicall;
import 'package:dart_web3_multicall/fake_data.dart' as fake_data;
import 'package:dart_web3_multicall/multicall.dart' as multicall;
import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';

var apiUrl = "https://data-seed-prebsc-1-s1.binance.org:8545"; //Replace with your API

var httpClient = Client();
var ethClient = Web3Client(apiUrl, httpClient);
var multicallContract = EthereumAddress.fromHex("0xae11c5b5f29a6a25e955f0cb8ddcc416f522af5c");

var token = EthereumAddress.fromHex("0x8085c02665f2BC0975Bd69C747D1918c3154e5c0");
var user = EthereumAddress.fromHex("0x7dedcd37ad8d65c4c01b522e30060836ffbf81bb");

void main(List<String> arguments) async {
  print('Hello world: ${dart_web3_multicall.calculate()}!');

  List<dynamic> tokenDetails = await multicall.getTokenDetails(ethClient, multicallContract, token);
  print(tokenDetails);

  List<fake_data.Token> tokensList = fake_data.fakeTokensList();
  List<dynamic> balanceOfsResult = await multicall.getBalanceMultiTokens(ethClient, multicallContract, tokensList, user);
  List<dynamic> balanceOfs = balanceOfsResult.sublist(1).first;

  List<fake_data.Token> tokensWithBalanceOfs = List<fake_data.Token>.from(tokensList.map((token) {
    token.setBalance(balanceOfs[tokensList.indexOf(token)]);
    return token;
  }));

  for (var token in tokensWithBalanceOfs) {
    print(" >> token address: ${token.address}");
    print(" >> user: $user");
    print(" >> bigBalanceOf: ${token.bigBalanceOf.toInt()}");
    print(" >> balanceOf: ${token.balanceOf}");
    print(" >>> ============ >>>>>>");
  }
}
