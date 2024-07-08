#!/bin/bash

# Set environment variables
export EP_NAME="${ORACLE_SID^^}_on_${HOSTNAME%%.*}"   # Construct EP_NAME using uppercase ORACLE_SID and hostname without domain
export DBNAME="${ORACLE_SID::-1}"                    # Remove last character from ORACLE_SID to get DBNAME
export WALLET_NAME="${DBNAME^^}"                     # Convert DBNAME to uppercase for WALLET_NAME
export OKV_HOME="/u02/app/oracle/admin/${DBNAME}/okv_home"
export JAVA_HOME="/usr/java/jdk1.8.0_241-amd64/jre"

# Download OKV Rest CLI package
curl -Ok https://okvserver:5695/okvrestclipackage.zip

# Unzip only the necessary library
unzip -Vj okvrestclipackage.zip lib/okvrestcli.jar -d ./lib

# Generate deployment script
cat > ./deploy-okv-lead.sh << EOF
#!/bin/bash
# Deployment script to set up Oracle Key Vault

# Create directory for OKV wallet
mkdir -pv "${OKV_HOME}/okv"

# Manage access: create wallet
./bin/okv manage-access wallet create --wallet "${WALLET_NAME}" --unique FALSE

# Admin: create endpoint
./bin/okv admin endpoint create --endpoint "${EP_NAME}" --description "$HOSTNAME, $(hostname -i)" \
    --type ORACLE_DB --platform LINUX64 --subgroup "USE CREATOR SUBGROUP" --unique FALSE

# Manage access: set default wallet for endpoint
./bin/okv manage-access wallet set-default --wallet "${WALLET_NAME}" --endpoint "${EP_NAME}"

# Provision endpoint
expect << _EOF
    set timeout 120
    spawn ./bin/okv admin endpoint provision --endpoint "${EP_NAME}" --location "${OKV_HOME}/okv/" --auto-login FALSE
    expect "ENTER ORACLE KEY VAULT ENDPOINT PASSWORD: "
    send "change-on-install\r"   # Replace with actual TDE password
    expect eof
_EOF
EOF

