#!/bin/bash
set -euo pipefail

# Common Name
CACN=simplesamlephp.local
IDPCN=idp.simplesamlephp.local

# CA file
CA_CRT=ca.crt
CA_KEY=ca.key

# App cert file
IDP_CRT=idp.crt
IDP_CSR=idp_cert.csr
IDP_KEY=idp_cert.key

# CA 証明書作成
openssl req -new -x509 -sha256 -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=SimpleSAMLPHP/CN=${CACN}" -newkey rsa:2048 -nodes -out ${CA_CRT} -keyout ${CA_KEY} -days 1095

# IDP CSR 作成
openssl req -new -nodes -sha256 -subj "/C=JP/ST=Tokyo/L=Chiyoda-ku/O=SimpleSAMLPHP/CN=${IDPCN}" -keyout ${IDP_KEY} -out ${IDP_CSR}
# IDP 用証明書作成および CA 署名
openssl x509 -req -sha256 -CA ${CA_CRT} -CAkey ${CA_KEY} -CAcreateserial -days 1095 -in ${IDP_CSR} -out ${IDP_CRT}
