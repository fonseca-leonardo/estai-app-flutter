# Guia de Release Android - Estai

Este documento contém instruções passo a passo para gerar a release completa do Android.

## Pré-requisitos

- Flutter SDK instalado e configurado
- Java JDK instalado (para keytool)
- Conta no Firebase Console configurada
- Conta no Google Play Console (para publicação)

## Passo 1: Criar Keystore

Execute o script fornecido (recomendado):

```bash
cd android
./create_keystore.sh
```

O script criará o keystore em `~/estai-release-key.jks` e fornecerá instruções para os próximos passos.

**Após criar o keystore, execute IMEDIATAMENTE o backup:**
```bash
cd android
./backup_keystore.sh
```

**Alternativa - Executar manualmente:**

```bash
keytool -genkey -v -keystore ~/estai-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias estai
```

**Informações necessárias:**
- Nome e sobrenome: Nome da organização/desenvolvedor
- Unidade organizacional: (pode deixar vazio)
- Organização: Nome da organização
- Cidade: Cidade
- Estado: Estado (sigla)
- Código do país: BR
- Senha: Criar uma senha forte e guardá-la com segurança

**⚠️ CRÍTICO - LEIA COM ATENÇÃO:**

O keystore e a senha são **irreversíveis e irrecuperáveis**. Se você perder qualquer um deles:

- ❌ **NÃO poderá mais atualizar o app na Google Play Store**
- ❌ **NÃO há como recuperar ou redefinir** (nem o Google pode ajudar)
- ❌ **Terá que criar um NOVO app** na Play Store (novo package name)
- ❌ **Perderá todo o histórico**: avaliações, downloads, estatísticas, etc.

**Por que isso acontece?**
A Google Play Store exige que TODAS as atualizações sejam assinadas com a MESMA chave usada na primeira publicação. É uma medida de segurança para garantir que apenas você pode atualizar seu app.

**O que fazer AGORA:**
1. ✅ Faça backup do arquivo `.jks` em múltiplos locais seguros
2. ✅ Guarde a senha em um gerenciador de senhas (1Password, LastPass, Bitwarden, etc.)
3. ✅ Salve também em um cofre físico ou serviço de backup criptografado
4. ✅ Documente onde está o backup (mas não a senha no mesmo lugar)

## Passo 2: Criar arquivo key.properties

1. Copie o template:
```bash
cp android/key.properties.template android/key.properties
```

2. Edite `android/key.properties` e preencha com suas informações:
```
storePassword=sua_senha_do_keystore
keyPassword=sua_senha_do_keystore
keyAlias=estai
storeFile=/caminho/completo/para/estai-release-key.jks
```

**Exemplo se o keystore estiver na home:**
```
storeFile=/Users/seu_usuario/estai-release-key.jks
```

## Passo 3: Obter Chaves SHA para Release

Execute o script fornecido:

```bash
cd android
./get_sha_keys.sh
```

**Alternativa - Executar manualmente:**
```bash
keytool -list -v -keystore ~/estai-release-key.jks -alias estai
```

Você verá algo como:
```
Certificate fingerprints:
     SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
     SHA256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**Copie ambas as chaves SHA-1 e SHA-256.**

## Passo 4: Adicionar Chaves SHA no Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto (`estai-edb36`)
3. Vá em **Configurações do projeto** (ícone de engrenagem)
4. Role até **Seus apps** e clique no app Android
5. Clique em **Adicionar impressão digital**
6. Cole as chaves SHA-1 e SHA-256 obtidas no Passo 3
7. Clique em **Salvar**

## Passo 5: Baixar google-services.json atualizado

Após adicionar as chaves SHA no Firebase:

1. No Firebase Console, clique em **Baixar google-services.json**
2. Substitua o arquivo em `android/app/google-services.json`

## Passo 6: Verificar Versão

Verifique se a versão em `pubspec.yaml` está correta:

```yaml
version: 1.0.0+1
```

- O número após o `+` é o `versionCode` (1)
- O número antes do `+` é o `versionName` (1.0.0)

Para futuras releases, incremente:
- `versionCode` (+1) para cada build
- `versionName` quando houver mudanças significativas

## Passo 7: Gerar Release Completa

Execute o script que faz tudo automaticamente:

```bash
cd android
./build_release.sh
```

Este script irá:
1. Verificar se `key.properties` existe
2. Limpar builds anteriores
3. Obter dependências
4. Gerar o App Bundle (AAB)

**Alternativa - Executar manualmente:**

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

O arquivo será gerado em: `build/app/outputs/bundle/release/app-release.aab`

## Passo 9: Gerar APK (Opcional)

Se precisar de um APK ao invés de AAB:

```bash
flutter build apk --release
```

O arquivo será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

## Passo 10: Testar o Build

Antes de publicar, teste o arquivo gerado:

- **AAB**: Use o [Play Console Internal Testing](https://play.google.com/console) para testar
- **APK**: Instale diretamente em um dispositivo Android para testar

## Próximos Passos para Publicação

1. Acesse o [Google Play Console](https://play.google.com/console)
2. Crie um novo app ou selecione o app existente
3. Faça upload do arquivo AAB gerado
4. Preencha todas as informações necessárias:
   - Descrição do app
   - Screenshots
   - Ícone
   - Política de privacidade
   - etc.
5. Submeta para revisão

## Segurança e Backup do Keystore

### Proteção no Git

- ✅ O arquivo `key.properties` está no `.gitignore` e não será versionado
- ✅ Arquivos `.jks` e `.keystore` estão no `.gitignore`
- ⚠️ **NUNCA** commite o keystore ou key.properties no git

### Estratégia de Backup (OBRIGATÓRIO)

**1. Backup do Arquivo Keystore (.jks):**
- Copie o arquivo para pelo menos 3 locais diferentes:
  - Serviço de nuvem criptografado (Google Drive, Dropbox, iCloud, etc.)
  - Disco externo ou pendrive
  - Computador de backup
  - Gerenciador de senhas com anexos (1Password, Bitwarden, etc.)

**2. Backup da Senha:**
- Use um gerenciador de senhas confiável
- Anote em local físico seguro (cofre, gaveta trancada)
- Compartilhe com pessoa de confiança (se aplicável)
- **NÃO** salve a senha no mesmo lugar que o keystore (se alguém acessar um, não terá o outro)

**3. Documentação:**
- Anote onde estão os backups (mas não a senha no mesmo documento)
- Configure lembretes anuais para verificar se os backups ainda existem
- Considere usar um serviço de backup automático

**4. Verificação Periódica:**
- A cada 6 meses, verifique se consegue acessar o keystore e a senha
- Teste fazer um build de release para garantir que tudo funciona

### O que fazer se perder o keystore?

Infelizmente, **não há solução**. Você terá que:
1. Criar um novo app na Play Store (novo package name)
2. Perder todo o histórico do app antigo
3. Usuários terão que desinstalar o app antigo e instalar o novo

**Por isso, o backup é CRÍTICO!**

## Troubleshooting

### Erro: "key.properties not found"
- Certifique-se de que criou o arquivo `android/key.properties` seguindo o Passo 2

### Erro: "Keystore file not found"
- Verifique o caminho em `storeFile` no `key.properties`
- Use caminho absoluto (começando com `/`)

### Erro: "Wrong password"
- Verifique se as senhas em `key.properties` estão corretas
- Certifique-se de que não há espaços extras

### Google Sign-In não funciona após release
- Certifique-se de que adicionou as chaves SHA de release no Firebase
- Baixou o novo `google-services.json` após adicionar as chaves

