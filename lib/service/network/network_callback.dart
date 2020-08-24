class TTNetworkCallback {
  final bool isOK;
  final Map<String, dynamic> data;
  final String msgError;

  TTNetworkCallback({this.isOK, this.data, this.msgError});
}

typedef NetworkCallback = Function(TTNetworkCallback);
