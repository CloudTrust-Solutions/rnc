
	[...]

function get_certificate(txn)
        core.log(core.info, "Remote Network Connection Frontend")
        local arg1 = txn.f:src()
        local arg2 = txn.f:ssl_c_s_dn("CN")
        local arg3 = txn.f:ssl_c_s_dn("OU")
        local arg4 = txn.f:ssl_c_s_dn("O")
        local arg5 = txn.f:ssl_c_notbefore()
        local arg6 = txn.f:ssl_c_notafter()
        local arg7 = txn.f:ssl_c_sha1()
        local arg8 = txn.f:ssl_c_serial()
        local arg9 = txn.f:ssl_c_i_dn("CN")
        local arg10 = txn.f:ssl_c_i_dn("OU")
        local arg11 = txn.f:ssl_c_i_dn("O")
        core.log(core.info, "Source IP address")
        core.log(core.info, arg1)
        core.log(core.info, "Certificate presented by the client")
        core.log(core.info, arg2)
        core.log(core.info, arg3)
        core.log(core.info, arg4)
        core.log(core.info, arg5)
        core.log(core.info, arg6)
        core.log(core.info, arg7)
        core.log(core.info, arg8)
        core.log(core.info, "Issuer of the certificate presented by the client")
        core.log(core.info, arg9)
        core.log(core.info, arg10)
        core.log(core.info, arg11)

        return "rnc_server_https"
end

core.register_fetches("get_certificate", get_certificate)

	[...]


