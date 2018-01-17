########################################################
# Detecting Package Manager and Linux 32/64
########################################################
YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)

if [[ ! -z $YUM_CMD ]]; then
    reset
elif [[ ! -z $APT_GET_CMD ]]; then
    reset
else
    reset
    echo "$(tput bold || echo)$(tput setaf 6 || echo)"
    echo "  Canceling Remote Network Connection Setup"
    echo "$(tput sgr0 || echo)"
    echo ""
    echo "Setup has cancelled to install Remote Network Connection."
    echo ""
    echo "-------------------------------------------------------------------------"
    read -p "Press ENTER to finish"
    exit 1;
fi

if [ $(uname -m) == 'x86_64' ]; then
    # 64-bit
    echo ""
else
    # 32-bit
    reset
    echo "$(tput bold || echo)$(tput setaf 6 || echo)"
    echo "  Canceling Remote Network Connection Setup"
    echo "$(tput sgr0 || echo)"
    echo ""
    echo "Setup has cancelled to install Remote Network Connection."
    echo ""
    echo "---------------------------------------------------------------------"
    read -p "Press ENTER to finish"
    exit 1;
fi

########################################################
# Welcome
########################################################
echo "$(tput bold || echo)$(tput setaf 6 || echo)"
echo "	Welcome to Remote Network Connection Setup Wizard"
echo "$(tput sgr0 || echo)"
echo ""
echo "This will install Remote Network Connection on your server."
echo ""
echo "It is recommended that you close other applications before continuing."
echo ""
echo "-------------------------------------------------------------------------"
echo "Choose Yes to continue, or Ctrl+C to exit Setup."
read -p "Are you sure to Continue (y/n)? " choice
case "$choice" in
  y|Y|yes|YES ) reset;;
  * ) exit;;
esac

########################################################
# License Agreement
########################################################
echo "$(tput bold || echo)$(tput setaf 6 || echo)"
echo "	License Agreement"
echo "$(tput sgr0 || echo)"
echo ""
echo "By using this software and any updates to it, you indicate your acceptance of these terms. If you do not accept these terms, do not install or use the software."
echo ""
echo "The software - Remote Network Connection™ - and any updates to it are provided "as is" and you bear the risk of using it."
echo ""
echo "In no event shall CloudTrust Ltd. be liable for any consequential, special, incidental or indirect damages of any kind arising out of the delivery, performance or use of this software."
echo ""
echo "You may privately make copies of the software to yourself, so long as this disclaimer accompanies said distribution, you do not represent the software as your own work, and you do not alter the software or the installation package in any way. You may not host or redistribute this software publicly (e.g. from a public Internet site) - instead, point users to https://rnc.services to download. You may not decompile or otherwise reverse-engineer any part of the software, except and only to the extent that such actions are expressly allowed by applicable law notwithstanding this restriction."
echo ""
echo "USE RESTRICTIONS: You warrant that your use of this software is legal and does not violate any law or regulation to which you are subject."
echo ""
echo "Remote Network Connection™ is ©2006-2018 CloudTrust Ltd. All rights reserved."
echo ""
echo "-------------------------------------------------------------------------"
echo "Choose Yes to accept the agreemant, or Ctrl+C to exit Setup."
read -p "Are you sure to Continue (y/n)? " choice
case "$choice" in
  y|Y|yes|YES ) reset;;
  * ) exit;;
esac

########################################################
# Subscription Information
########################################################
echo "$(tput bold || echo)$(tput setaf 6 || echo)"
echo "	Remote Network Connection Subscription Information"
echo "$(tput sgr0 || echo)"
echo ""
echo "Enter Ticket ID, followed by [ENTER]:"
read rnc_ticket_id
echo "Enter Remote Network Connection Server address, followed by [ENTER]:"
read rnc_server_address
echo "Enter Network passphrase, followed by [ENTER]:"
read -s rnc_network_passphrase
echo ""
echo "-------------------------------------------------------------------------"
echo "Choose Yes to continue with the installation, or Ctrl+C to exit Setup."
read -p "Are you sure to Continue (y/n)? " choice
case "$choice" in
  y|Y|yes|YES ) reset;;
  * ) exit;;
esac

########################################################
# Installing applications
########################################################
echo "$(tput bold || echo)$(tput setaf 6 || echo)"
echo "  Installing"
echo "$(tput sgr0 || echo)"
echo ""
echo "Installing Wget library..."
 if [[ ! -z $YUM_CMD ]]; then
    yum install wget
 elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get install wget
 else
    exit 1;
 fi

echo "Installing OpenSSL library..."
 if [[ ! -z $YUM_CMD ]]; then
    yum install openssl
 elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get install openssl
 else
    exit 1;
 fi

echo "Installing Universally Unique ID library..."
 if [[ ! -z $YUM_CMD ]]; then
    yum install uuid-devel
 elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get install uuid-runtime
 else
    exit 1;
 fi

echo "Installing .NET Core library..."
wget -O - https://dot.net/v1/dotnet-install.sh | bash

echo "Installing NuGet packages..."
dotnet add package Microsoft.Extensions.Configuration --version 2.0.0
dotnet add package Microsoft.Extensions.Configuration.Json --version 2.0.0

########################################################
# Create appsettings.json configuration file
########################################################
rm appsettings.json
echo "{" >> appsettings.json
echo "  \"TicketID\" :  \"$rnc_ticket_id\"," >> appsettings.json
echo "  \"ServerAddress\" :  \"$rnc_server_address:443\"," >> appsettings.json
echo -n "  \"NetworkPassphrase\" :  \"" >> appsettings.json
printf $rnc_network_passphrase | openssl base64 | awk 'BEGIN{ORS="";} {print}' >> appsettings.json
echo "\"," >> appsettings.json
echo -n "  \"MemberID\" :  \"" >> appsettings.json
echo "" | uuidgen | tr /a-z/ /A-Z/ | tr "\n" "\"," >> appsettings.json
echo "," >> appsettings.json
echo "  \"MemberDescription\" :  \"$HOSTNAME\"" >> appsettings.json
echo "}" >> appsettings.json

reset
########################################################
# Completing
########################################################
echo "$(tput bold || echo)$(tput setaf 6 || echo)"
echo "	Completing Remote Network Connection Setup"
echo "$(tput sgr0 || echo)"
echo ""
echo "Setup has finished installing Remote Network Connection on your server."
echo ""
echo "-------------------------------------------------------------------------"
read -p "Press ENTER to finish"




