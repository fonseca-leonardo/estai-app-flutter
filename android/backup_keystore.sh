#!/bin/bash

# Script para fazer backup do keystore de release
# Execute este script após criar o keystore

KEYSTORE_PATH="$HOME/estai-release-key.jks"
BACKUP_DIR="$HOME/estai-keystore-backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "=========================================="
echo "Backup do Keystore - Estai"
echo "=========================================="
echo ""

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "ERRO: Keystore não encontrado em $KEYSTORE_PATH"
    echo ""
    echo "Se o keystore estiver em outro local, edite este script"
    echo "ou copie manualmente para um local seguro."
    exit 1
fi

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

# Copiar keystore com timestamp
BACKUP_FILE="$BACKUP_DIR/estai-release-key_${TIMESTAMP}.jks"
cp "$KEYSTORE_PATH" "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Backup criado com sucesso!"
    echo ""
    echo "Local do backup: $BACKUP_FILE"
    echo ""
    echo "=========================================="
    echo "PRÓXIMOS PASSOS CRÍTICOS:"
    echo "=========================================="
    echo ""
    echo "1. Copie este backup para pelo menos 3 locais diferentes:"
    echo "   - Serviço de nuvem (Google Drive, Dropbox, iCloud)"
    echo "   - Disco externo ou pendrive"
    echo "   - Outro computador"
    echo ""
    echo "2. Guarde a SENHA do keystore em:"
    echo "   - Gerenciador de senhas (1Password, LastPass, Bitwarden)"
    echo "   - Local físico seguro (cofre, gaveta trancada)"
    echo ""
    echo "3. NÃO salve a senha no mesmo lugar que o keystore!"
    echo ""
    echo "4. Verifique os backups periodicamente (a cada 6 meses)"
    echo ""
    echo "⚠️  LEMBRE-SE: Se perder o keystore ou a senha,"
    echo "   NÃO poderá mais atualizar o app na Play Store!"
    echo ""
else
    echo "ERRO: Falha ao criar backup"
    exit 1
fi

