# Configuração do Firebase App Check

Este documento descreve os passos manuais necessários para completar a configuração do Firebase App Check.

## Configuração iOS (App Attest)

### 1. Habilitar App Attest no Xcode

1. Abra o projeto no Xcode: `ios/Runner.xcworkspace`
2. Selecione o target `Runner` no navegador de projetos
3. Vá para a aba "Signing & Capabilities"
4. Clique em "+ Capability"
5. Adicione "App Attest"
6. Certifique-se de que o App ID está configurado corretamente no Apple Developer Portal

### 2. Requisitos
- iOS 14.0 ou superior
- Dispositivo físico recomendado para testes (App Attest pode não funcionar corretamente no simulador)

## Configuração Android (Play Integrity)

### 1. Habilitar Play Integrity API

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Selecione o projeto Firebase: `estai-edb36`
3. Navegue até "APIs & Services" > "Library"
4. Procure por "Play Integrity API"
5. Clique em "Enable"

### 2. Configuração no Firebase Console

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto `estai-edb36`
3. Vá para "Build" > "App Check"
4. Selecione o app Android
5. Configure Play Integrity como provider
6. Configure o enforcement (recomendado: começar em modo "Monitor" antes de ativar enforcement completo)

## Tokens de Debug

### Para Desenvolvimento

O código já está configurado para usar providers de debug automaticamente quando `kDebugMode` é `true`. No entanto, você precisa registrar os tokens de debug no Firebase Console:

#### Android (Play Integrity Debug)
1. Execute o app em modo debug
2. Verifique os logs do Flutter para encontrar o debug token
3. No Firebase Console > App Check > Apps > Android app
4. Vá para "Debug tokens"
5. Adicione o token encontrado nos logs

#### iOS (App Attest Debug)
1. Execute o app em modo debug em um dispositivo físico
2. Verifique os logs do Flutter para encontrar o debug token
3. No Firebase Console > App Check > Apps > iOS app
4. Vá para "Debug tokens"
5. Adicione o token encontrado nos logs

### Como Obter Debug Tokens

Os tokens de debug são impressos automaticamente nos logs quando o app é executado em modo debug. Procure por mensagens como:
- Android: "App Check debug token: [TOKEN]"
- iOS: "App Check debug token: [TOKEN]"

## Configuração no Firebase Console

### Habilitar App Check para Serviços

1. Acesse Firebase Console > App Check
2. Para cada serviço (Firestore, Authentication):
   - Clique no serviço
   - Configure o enforcement
   - Recomendado: começar com "Monitor" para verificar que tudo está funcionando
   - Depois de validar, altere para "Enforce" para ativar a proteção completa

### Ordem Recomendada de Ativação

1. **Fase 1 - Monitor**: Ative App Check em modo "Monitor" para todos os serviços
2. **Fase 2 - Validação**: Execute o app e verifique os logs no Firebase Console para garantir que os tokens estão sendo validados corretamente
3. **Fase 3 - Enforcement**: Após confirmar que tudo está funcionando, altere para "Enforce" para ativar a proteção completa

## Troubleshooting

### Android - Play Integrity não funciona
- Verifique se o app está publicado na Play Store ou configurado como app interno
- Certifique-se de que a Play Integrity API está habilitada no Google Cloud Console
- Verifique se o SHA-256 do certificado de assinatura está registrado no Firebase

### iOS - App Attest não funciona
- Certifique-se de que está testando em um dispositivo físico (iOS 14+)
- Verifique se a capability "App Attest" está habilitada no Xcode
- Confirme que o App ID está configurado corretamente no Apple Developer Portal

### Tokens de debug não funcionam
- Verifique se o app está rodando em modo debug (`flutter run` sem `--release`)
- Confirme que os tokens foram registrados corretamente no Firebase Console
- Verifique os logs do app para mensagens de erro do App Check

