# Como obter e adicionar chaves SHA no Firebase

## 1. Obter as chaves SHA-1 e SHA-256

### Para Debug (desenvolvimento):
```bash
cd android
./gradlew signingReport
```

**Suas chaves SHA (já obtidas):**
- **SHA-1:** `30:03:DF:6A:C5:EA:6B:C5:3F:B8:CC:93:02:B7:FC:75:7E:A3:E1:89`
- **SHA-256:** `03:05:C6:00:62:28:44:09:B3:04:06:20:02:55:89:3C:C0:E6:06:DF:96:67:4D:85:21:18:B7:51:AC:05:C4:02`

**IMPORTANTE:** Adicione AMBAS as chaves no Firebase Console!

### Para Release (produção):
Se você já tem um keystore de release:
```bash
keytool -list -v -keystore /caminho/para/seu/keystore.jks -alias seu_alias
```

## 2. Adicionar no Firebase Console

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto (`estai-edb36`)
3. Vá em **Configurações do projeto** (ícone de engrenagem)
4. Role até **Seus apps** e clique no app Android
5. Clique em **Adicionar impressão digital**
6. Cole as chaves SHA-1 e SHA-2 (SHA-256) obtidas acima
7. Clique em **Salvar**

## 3. Baixar o google-services.json atualizado

Após adicionar as chaves SHA:
1. Baixe o novo arquivo `google-services.json`
2. Substitua o arquivo em `android/app/google-services.json`

## 4. Recompilar o app

Após adicionar as chaves SHA e atualizar o `google-services.json`, recompile o app:
```bash
flutter clean
flutter pub get
flutter run
```

## Nota Importante

- As chaves SHA são necessárias para o Google Sign-In funcionar no Android
- Você precisa adicionar tanto SHA-1 quanto SHA-256
- Se você criar um novo keystore para release, precisará adicionar essas chaves também

