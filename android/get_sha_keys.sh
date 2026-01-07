#!/bin/bash

# Script para obter chaves SHA do keystore de release
# Execute este script após criar o keystore

KEYSTORE_PATH="$HOME/estai-release-key.jks"
ALIAS="estai"

echo "=========================================="
echo "Obtendo Chaves SHA do Keystore"
echo "=========================================="
echo ""

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "ERRO: Keystore não encontrado em $KEYSTORE_PATH"
    echo ""
    echo "Se o keystore estiver em outro local, execute manualmente:"
    echo "keytool -list -v -keystore /caminho/para/keystore.jks -alias $ALIAS"
    exit 1
fi

echo "Keystore: $KEYSTORE_PATH"
echo "Alias: $ALIAS"
echo ""
echo "Digite a senha do keystore quando solicitado:"
echo ""

keytool -list -v -keystore "$KEYSTORE_PATH" -alias "$ALIAS"

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Próximos passos:"
    echo "=========================================="
    echo ""
    echo "1. Copie as chaves SHA-1 e SHA-256 acima"
    echo "2. Acesse o Firebase Console: https://console.firebase.google.com/"
    echo "3. Vá em Configurações do projeto > Seus apps > App Android"
    echo "4. Clique em 'Adicionar impressão digital'"
    echo "5. Cole as chaves SHA-1 e SHA-256"
    echo "6. Baixe o novo google-services.json e substitua em android/app/"
    echo ""
else
    echo ""
    echo "Erro ao obter chaves SHA. Verifique:"
    echo "- O caminho do keystore está correto?"
    echo "- O alias está correto?"
    echo "- A senha está correta?"
    exit 1
fi

