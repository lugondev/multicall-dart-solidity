import 'dart:io';

import 'package:dart_web3_multicall/dart_web3_multicall.dart' as dart_web3_multicall;
import 'package:dart_web3_multicall/fake_data.dart' as fake_data;
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

  EthereumAddress address = EthereumAddress.fromHex("0x01504761F5Ec308Fc0BAf3e705f31F2466535d94");
  EtherAmount balance = await ethClient.getBalance(address);
  print(balance.getValueInUnit(EtherUnit.ether));

  String tokenAbiJson = File('lib/token.abi.json').readAsStringSync();
  String multicallAbiJson = File('lib/multicall.abi.json').readAsStringSync();

  ContractAbi tokenContractABI = ContractAbi.fromJson(tokenAbiJson, "TokenERC20");
  ContractAbi multicallContractABI = ContractAbi.fromJson(multicallAbiJson, "Multicall");
  ContractFunction aggregateFunction = multicallContractABI.functions.firstWhere((element) => element.name == "aggregate");
  ContractFunction getEthBalanceFunction = multicallContractABI.functions.firstWhere((element) => element.name == "getEthBalance");

  DeployedContract tokenDeployedContract = DeployedContract(tokenContractABI, token2);
  DeployedContract multicallDeployedContract = DeployedContract(multicallContractABI, multicallContract);
  ContractFunction balanceOfFunction = tokenContractABI.functions.firstWhere((element) => element.name == "balanceOf");
  ContractFunction decimalsFunction = tokenContractABI.functions.firstWhere((element) => element.name == "decimals");
  List<dynamic> resultsBalanceOf = await ethClient.call(contract: tokenDeployedContract, function: balanceOfFunction, params: [address]);
  print(resultsBalanceOf);

  List<dynamic> resultGetEth = await ethClient.call(contract: multicallDeployedContract, function: getEthBalanceFunction, params: [address]);

  print(resultGetEth);

  List<dynamic> resultAggregate = await ethClient.call(contract: multicallDeployedContract, function: aggregateFunction, params: [
    [
      [
        token1,
        balanceOfFunction.encodeCall([address])
      ],
      [token1, decimalsFunction.encodeCall([])]
    ]
  ]);

  print(resultAggregate);
}
