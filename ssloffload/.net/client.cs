
	[...]

///
/// <summary> 
/// Start the client 
/// </summary> 
private static void RunClient() {
	while (true) {
		Console.Write("\nInput message: ");

		//read a string from the console. 
		_message = Console.ReadLine();

		if (String.Compare(_message, "close", StringComparison.CurrentCultureIgnoreCase) == 0) break;
		if (!String.IsNullOrEmpty(_message)) {
			//create the client instance. It will perform calls to the server's 
			//endpoint (192.168.1.21:443) 
			TcpClient client = new TcpClient("192.168.12.34", 443);
			SendMessageToServer(client);
		}
	}
}

///
/// <summary> 
/// Send a message to the server using TLS/SSL 
/// </summary> 
private static void SendMessageToServer(TcpClient client) {

	try {

		bool leaveInnerStreamOpen = false;

		RemoteCertificateValidationCallback validationCallback = new RemoteCertificateValidationCallback(ServerValidationCallback);

		LocalCertificateSelectionCallback selectionCallback = new LocalCertificateSelectionCallback(ClientCertificateSelectionCallback);

		EncryptionPolicy encryptionPolicy = EncryptionPolicy.RequireEncryption;

		//create the SSL stream starting from the NetworkStream associated 
		//with the TcpClient instance 
		_sslStream = new SslStream(client.GetStream(), leaveInnerStreamOpen, validationCallback, selectionCallback, encryptionPolicy);

		//1. start the authentication process. If it doesn't succeed  
		//an AuthenticationException is thrown 
		ClienSideHandshake();

		//2. send the input message to the server 
		SendDataToServer();

	} catch(AuthenticationException ex) {
		Console.WriteLine("\nAuthentication Exception: " + ex.Message);
	} catch(Exception ex) {
		Console.WriteLine("\nError detected: " + ex.Message);
	} finally {
		if (_sslStream != null) _sslStream.Close();
		client.Close();
	}
}

///
/// <summary> 
/// Perform the client handshake 
/// </summary> 
private static void ClientSideHandshake() {

	Console.WriteLine("\nStart authentication ... ");

	X509CertificateCollection clientCertificates = GetClientCertificates("ssl_client");

	string targetHost = "192.168.12.34";
	SslProtocols sslProtocol = SslProtocols.Tls;
	bool checkCertificateRevocation = true;

	//Start the handshake 
	_sslStream.AuthenticateAsClient(targetHost, clientCertificates, sslProtocol, checkCertificateRevocation);

}

///
///   <summary>     
///  Callback for the verification of the server certificate      
///   </summary>      
private static bool ServerValidationCallback(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) {
	switch (sslPolicyErrors) {
	case SslPolicyErrors.RemoteCertificateNameMismatch:
		Console.WriteLine("Server name mismatch. End communication ...\n");
		return false;
	case SslPolicyErrors.RemoteCertificateNotAvailable:
		Console.WriteLine("Server's certificate not available. End communication ...\n");
		return false;
	case SslPolicyErrors.RemoteCertificateChainErrors:
		Console.WriteLine("Server's certificate validation failed. End communication ...\n");
		return false;
	} //Perform others checks using the "certificate" and "chain" objects ... 
	// ... 
	// ... 
	Console.WriteLine("Server's authentication succeeded ...\n");
	return true;
}

///
///   <summary>     
///  Certificate selection callback.     
///   </summary>    
public static X509Certificate ClientCertificateSelectionCallback(object sender, string targetHost, X509CertificateCollection localCertificates, X509Certificate remoteCertificate, string[] acceptableIssuers) {
	//perform some checks on the certificate ...
	// ... 
	// ...
	//return the selected certificate. If null is returned, the client's authentication does
	//not take place. 
	return localCertificates[0];
}

///
///   <summary>  ///  Send data to server 
///   </summary> 
private static void SendDataToServer() {
	byte[] buffer = Encoding.UTF8.GetBytes(_message);
	_sslStream.Write(buffer, 0, buffer.Length);

}

///   https://www.red-gate.com/simple-talk/dotnet/net-framework/tlsssl-and-net-framework-4-0/

	[...]

