#!/bin/bash

# Script para gerar release completa do Android
# Execute este script após configurar o keystore e key.properties

echo "=========================================="
echo "Gerando Release Android - Estai"
echo "=========================================="
echo ""

# Verificar se key.properties existe
if [ ! -f "key.properties" ]; then
    echo "ERRO: Arquivo key.properties não encontrado!"
    echo ""
    echo "Por favor:"
    echo "1. Copie key.properties.template para key.properties"
    echo "2. Preencha com suas informações do keystore"
    echo ""
    exit 1
fi

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "ERRO: Flutter não encontrado no PATH"
    echo "Por favor, instale o Flutter e adicione ao PATH"
    exit 1
fi

echo "Limpando build anterior..."
flutter clean

echo ""
echo "Obtendo dependências..."
flutter pub get

echo ""
echo "Gerando App Bundle (AAB)..."
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "Build concluído com sucesso!"
    echo "=========================================="
    echo ""
    echo "Arquivo gerado em:"
    echo "build/app/outputs/bundle/release/app-release.aab"
    echo ""
    echo "Próximos passos:"
    echo "1. Teste o AAB em um dispositivo ou via Play Console"
    echo "2. Faça upload para Google Play Console"
    echo "3. Preencha todas as informações necessárias"
    echo "4. Submeta para revisão"
    echo ""
else
    echo ""
    echo "ERRO: Falha ao gerar o build"
    echo "Verifique as mensagens acima para mais detalhes"
    exit 1
fi

