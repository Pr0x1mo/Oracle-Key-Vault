provider "local" {
  # Use local-exec provisioner to run commands on the local machine
}

resource "null_resource" "setup_okv" {
  # This resource triggers local-exec provisioners
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      # Bash script to set up OKV as per your run-me-lead.sh script
      export EP_NAME="${var.oracle_sid^^}_on_${hostname()%%.*}"
      export DBNAME="${var.oracle_sid::-1}"
      export WALLET_NAME="${DBNAME^^}"
      export OKV_HOME="/u02/app/oracle/admin/${DBNAME}/okv_home"
      export JAVA_HOME="/usr/java/jdk1.8.0_241-amd64/jre"

      # Download OKV Rest CLI package
      curl -Ok https://okvserver:5695/okvrestclipackage.zip

      # Unzip necessary library
      unzip -Vj okvrestclipackage.zip lib/okvrestcli.jar -d ./lib

      # Generate deployment script
      cat > ./deploy-okv-lead.sh << EOF
      #!/bin/bash
      mkdir -pv "${OKV_HOME}/okv"
      ./bin/okv manage-access wallet create --wallet "${WALLET_NAME}" --unique FALSE
      ./bin/okv admin endpoint create --endpoint "${EP_NAME}" --description "\$HOSTNAME, \$(hostname -i)" \
          --type ORACLE_DB --platform LINUX64 --subgroup "USE CREATOR SUBGROUP" --unique FALSE
      ./bin/okv manage-access wallet set-default --wallet "${WALLET_NAME}" --endpoint "${EP_NAME}"
      expect << _EOF
          set timeout 120
          spawn ./bin/okv admin endpoint provision --endpoint "${EP_NAME}" --location "${OKV_HOME}/okv/" --auto-login FALSE
          expect "ENTER ORACLE KEY VAULT ENDPOINT PASSWORD: "
          send "change-on-install\r"   # Replace with actual TDE password
          expect eof
      _EOF
      EOF

      # Make the script executable
      chmod +x ./deploy-okv-lead.sh

      # Execute the deployment script
      ./deploy-okv-lead.sh
    EOT
  }
}
