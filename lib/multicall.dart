import 'dart:io';

import 'package:web3dart/web3dart.dart';

DeployedContract getDeployedMulticall(EthereumAddress multicallContract) {
  String multicallAbiJson = File('lib/multicall.abi.json').readAsStringSync();
  ContractAbi contractABI = ContractAbi.fromJson(multicallAbiJson, "Multicall");
  return DeployedContract(contractABI, multicallContract);
}

DeployedContract getDeployedToken(EthereumAddress tokenContract) {
  String multicallAbiJson = File('lib/token.abi.json').readAsStringSync();
  ContractAbi contractABI = ContractAbi.fromJson(multicallAbiJson, "TokenERc20");
  return DeployedContract(contractABI, tokenContract);
}

getTokenDetails(Web3Client ethClient, EthereumAddress multicallContract, EthereumAddress tokenContract) async {
  DeployedContract tokenDeployedContract = getDeployedToken(tokenContract);
  DeployedContract multicallDeployedContract = getDeployedMulticall(multicallContract);

  ContractFunction decimalsFunction = tokenDeployedContract.function("decimals");
  ContractFunction nameFunction = tokenDeployedContract.function("name");
  ContractFunction symbolFunction = tokenDeployedContract.function("symbol");

  List<dynamic> resultAggregate = await ethClient.call(contract: multicallDeployedContract, function: multicallDeployedContract.function("aggregate"), params: [
    [
      [tokenContract, nameFunction.encodeCall([])],
      [tokenContract, symbolFunction.encodeCall([])],
      [tokenContract, decimalsFunction.encodeCall([])]
    ]
  ]);

  return resultAggregate;
}
