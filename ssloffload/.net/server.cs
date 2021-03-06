
	[...]

///
/// <summary> 
/// Start the server 
/// </summary> 
private static void RunServer() {
	TcpListener listener = null;

	try {
		listener = new TcpListener(IPAddress.Any, 443);
		listener.Start();

		Console.WriteLine("Ready ...\n");

		while (String.Compare(_message, "close", StringComparison.CurrentCultureIgnoreCase) != 0) {
			TcpClient client = listener.AcceptTcpClient();
			ManageClientRequest(client);
		}

	} catch(Exception ex) {
		Console.WriteLine("Error detected: " + ex.Message);
	} finally {
		Console.WriteLine("\nStopped ...");
	}
}

/// 
/// <summary> 
/// Manage a client request 
/// </summary> 
private static void ManageClientRequest(TcpClient client) {

	try {
		bool leaveInnerStreamOpen = true;

		RemoteCertificateValidationCallback validationCallback = new RemoteCertificateValidationCallback(ClientValidationCallback);

		LocalCertificateSelectionCallback selectionCallback = new LocalCertificateSelectionCallback(ServerCertificateSelectionCallback);

		EncryptionPolicy encryptionPolicy = EncryptionPolicy.AllowNoEncryption;

		//create the SSL stream starting from the NetworkStream associated 
		//with the TcpClient instance 
		_sslStream = new SslStream(client.GetStream(), leaveInnerStreamOpen, validationCallback, selectionCallback, encryptionPolicy);

		//1. when the client requests it, the handshake begins 
		ServerSideHandshake();

		//2. read client's data using the encrypted stream 
		ReadClientData();

	} catch(Exception ex) {
		Console.WriteLine("\nError detected: " + ex.Message);
	} finally {
		if (_sslStream != null) _sslStream.Close();
		client.Close();
	}
}

///
/// <summary> 
/// Perform the server handshake 
/// </summary> 
private static void ServerSideHandshake() {
	X509Certificate2 certificate = GetServerCertificate("ssl_server");

	bool requireClientCertificate = true;
	SslProtocols enabledSslProtocols = SslProtocols.Ssl3 | SslProtocols.Tls;
	bool checkCertificateRevocation = true;

	_sslStream.AuthenticateAsServer(certificate, requireClientCertificate, enabledSslProtocols, checkCertificateRevocation);
}

///
///   <summary> 
///   Callback for the verification of the client's certificate 
///   </summary> 
private static bool ClientValidationCallback(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) {
	switch (sslPolicyErrors) {

	case SslPolicyErrors.RemoteCertificateNameMismatch:
		Console.WriteLine("Client's name mismatch. End communication ...\n");
		return false;

	case SslPolicyErrors.RemoteCertificateNotAvailable:
		Console.WriteLine("Client's certificate not available. End communication ...\n");
		return false;

	case SslPolicyErrors.RemoteCertificateChainErrors:
		Console.WriteLine("Client's certificate validation failed. End communication ...\n");
		return false;

	}

	//Perform others checks using the "certificate" and "chain" objects ... 
	// ... 
	// ... 

	Console.WriteLine("Client's authentication succeeded ...\n");

	return true;
}

///
///   <summary>     
///   Certificate selection callback.     
///   </summary>      
public static X509Certificate ServerCertificateSelectionCallback(object sender, string targetHost, X509CertificateCollection localCertificates, X509Certificate remoteCertificate, string[] acceptableIssuers) {
	//perform some checks on the certificate... 
	// ...
	// ...                                       //return the selected certificate. If null is returned a 
	// NotSupported exception is thrown. 
	return localCertificates[0];
}

///
///   <summary> 
///   Read client's data 
///   </summary> 
private static void ReadClientData() {
	byte[] buffer = new byte[1024];

	int n = _sslStream.Read(buffer, 0, 1024);
	Array.Resize < byte > (ref buffer, n);

	_message = Encoding.UTF8.GetString(buffer);

	Console.WriteLine("Client said: " + _message);
}

///   https://www.red-gate.com/simple-talk/dotnet/net-framework/tlsssl-and-net-framework-4-0/

	[...]

