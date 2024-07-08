# Oracle-Key-Vault

Steps:

[oracle@hostname01 ~]$ cd /u02/app/oracle/admin/DBNAME/okvrest/bin
#list 
[oracle@hostname01 bin]$ ls
okv  okv.bat
#export OKV_RESTCLI_CONFIG=./conf/okvrestcli.ini
export OKV_REST=/u02/app/oracle/admin/DBNAME/okvrest
export OKV_RESTCLI_CONFIG=${OKV_REST}/conf/okvrestcli.ini
export JAVA_HOME=/usr/java/jdk.8.0_291-amd64/jre

if [ -z "$JAVA_HOME" ]
then
    echo "JAVA_HOME environment variable is not set."
    exit 1
fi

if [ -z "$OKV_RESTCLI_CONFIG" ]
then 
    echo "OKV_RESTCLI_CONFIG env variable not set."
    exit 1
fi


# Execute the OKV REST client CLI using the specified JAR file and pass command-line arguments
java -jar ${OKV_REST}/conf/okvrestcli.jar "$@"


[oracle@hostname01 bin]$ cd /u02/app/oracle/admin/DBNAME/okv_home/conf
[oracle@hostname01 conf]$ cat okvrestcli.ini
[Default]


#log_property=./conf/okvrestlci_logging.properties
#server=[OKV IP ADDRESS]
#okv_client_config=./conf/okvclient.ora
#user=[OKV username]
#password=[user password]

server=<ip of the OKV server>:5696


#[Profile1]
#server=
#okv_clint_config=
#user=

# Adds a client wallet for REST_USER using Oracle Key Vault (okv) utility.
[oracle@hostname01 ~]$ /u02/app/oracle/admin/DBNAME/okvrest/bin/okv admin client- wallet add --client-wallet /u02/app/oracle/admin/DBNAME/okvrest/w/. --wallet-user REST_USER

Password: [password]
{
	"result": "Success"
}

[oracle@hostname01 ~]$ cd /u02/app/oracle/admin/DBNAME/okvrest/w
# Lists files in the current directory in long format, sorted by modification time in reverse order.
[oracle@hostname01 bin]$ ls -lrt


server=<ip of the OKV server>:5696
user=REST_USER
client_wallet=/u02/app/oracle/admin/DBNAME/okvrest/w

#CREATE WALLET:

/u02/app/oracle/admin/DBNAME/okvrest/bin/okv manage-access wallet create --wallet DBNAME_cluster1 --description "wallet for database DBNAME" --unique FALSE

#CREATE ENDPOINT:
/u02/app/oracle/admin/DBNAME/okvrest/bin/okv admin endpoint create --endpoint DBNAME_hostname01 --description "DBNAME initial primary instance on hostname01" --type ORACLE_DB --platform LINUX64 --unique FALSE

#ASSIGN WALLET TO ENDPOINT
/u02/app/oracle/admin/DBNAME/okvrest/bin/okv manage-access wallet set-default --wallet DBNAME_cluster1 --endpoint DBNAME_hostname01

#download and install endpoint client software

/u02/app/oracle/admin/DBNAME/okvrest/bin/okv admin endpoint provision --endpoint DBNAME_hostname01 --location /u02/app/oracle/admin/DBNAME/okv_home/okv --auto-login FALSE

run-me-lead.sh automates all that

# DB CHANGES - UPLOAD TDE WALLETS TO OKV

[oracle@hostname01 ~]$ sqlplus

enter user-name /as sysdba

SQL> select wrl_parameter from v$encryption_wallet;

wrl_paramater: /var/opt/oracle/dbaas_acfs/DBNAME/wallet_root/tde

# 

[oracle@hostname01 ~]$ cp -p /var/opt/oracle/dbaas_acfs/DBNAME/wallet_root/tde/* /u02/app/oracle/admin/DBNAME/okv_home/tde/.
[oracle@hostname01 ~]$ ls -lrt /u02/app/oracle/admin/DBNAME/okv_home/tde/.
total 24
ewallet_2024.p12
ewallet_2024.p12
cwallet.sso

# Upload Wallet Command:
[oracle@hostname01 ~]$ /u02/app/oracle/admin/DBNAME/okv_home/okv/bin/okvutil upload -t WALLET -1 /u02/app/oracle/admin/DBNAME/okv_home/tde -g DBNAME_cluster1

Enter source wallet password:
Enter Oracle key Vault endpoint password:
Upload Succeeded

[oracle@hostname01 ~]$ /u02/app/oracle/admin/DBNAME/okv_home/okv/bin/okvutil list
Enter Oracle Key Vault endpoint password: 

#okvutil shows all tde wallets 

