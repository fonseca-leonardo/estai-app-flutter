#!/bin/bash

# Script para criar keystore de release para o app Estai
# Execute este script e siga as instruções

KEYSTORE_PATH="$HOME/estai-release-key.jks"
ALIAS="estai"

echo "=========================================="
echo "Criando Keystore para Release"
echo "=========================================="
echo ""
echo "Este script criará um keystore em: $KEYSTORE_PATH"
echo "Alias: $ALIAS"
echo ""
echo "IMPORTANTE:"
echo "- Guarde a senha em local seguro!"
echo "- Se perder o keystore, não poderá atualizar o app na Play Store"
echo "- O keystore será criado em: $KEYSTORE_PATH"
echo ""
read -p "Pressione Enter para continuar ou Ctrl+C para cancelar..."

keytool -genkey -v -keystore "$KEYSTORE_PATH" -keyalg RSA -keysize 2048 -validity 10000 -alias "$ALIAS"

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Keystore criado com sucesso!"
    echo "=========================================="
    echo ""
    echo "Próximos passos:"
    echo "1. Crie o arquivo android/key.properties com:"
    echo "   storePassword=sua_senha"
    echo "   keyPassword=sua_senha"
    echo "   keyAlias=$ALIAS"
    echo "   storeFile=$KEYSTORE_PATH"
    echo ""
    echo "2. Obtenha as chaves SHA executando:"
    echo "   keytool -list -v -keystore $KEYSTORE_PATH -alias $ALIAS"
    echo ""
    echo "3. Adicione as chaves SHA no Firebase Console"
else
    echo ""
    echo "Erro ao criar keystore. Verifique as mensagens acima."
    exit 1
fi

