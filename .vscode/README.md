# Configurações do VSCode para Flutter Android

## Como usar

### 1. Executar o app no Android (Debug)

**Opção A - Usando o painel de Debug:**
1. Pressione `F5` ou clique no ícone de Debug na barra lateral
2. Selecione "Flutter (Android)" ou "Flutter (Primeiro dispositivo Android disponível)"
3. O app será compilado e executado automaticamente

**Opção B - Usando a paleta de comandos:**
1. Pressione `Ctrl+Shift+P` (ou `Cmd+Shift+P` no Mac)
2. Digite "Flutter: Launch Emulator" ou "Flutter: Select Device"
3. Escolha o dispositivo Android

### 2. Build APK

**Usando Tasks:**
1. Pressione `Ctrl+Shift+P` (ou `Cmd+Shift+P` no Mac)
2. Digite "Tasks: Run Task"
3. Escolha uma das opções:
   - **Flutter: Build APK (Debug)** - Gera APK de debug
   - **Flutter: Build APK (Release)** - Gera APK de release (otimizado)
   - **Flutter: Build App Bundle (Release)** - Gera AAB para Play Store

**Localização dos APKs gerados:**
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

### 3. Instalar no dispositivo conectado

1. Conecte um dispositivo Android via USB ou use um emulador
2. Pressione `Ctrl+Shift+P` (ou `Cmd+Shift+P` no Mac)
3. Digite "Tasks: Run Task"
4. Escolha "Flutter: Instalar no Android"

### 4. Outras tarefas úteis

- **Flutter: Listar dispositivos** - Mostra todos os dispositivos disponíveis
- **Flutter: Limpar build** - Remove arquivos de build (útil para resolver problemas)
- **Flutter: Pub Get** - Atualiza dependências do projeto

## Atalhos de teclado recomendados

Você pode adicionar atalhos personalizados em `.vscode/keybindings.json`:

```json
[
  {
    "key": "ctrl+alt+b",
    "command": "workbench.action.tasks.runTask",
    "args": "Flutter: Build APK (Debug)"
  },
  {
    "key": "ctrl+alt+r",
    "command": "workbench.action.tasks.runTask",
    "args": "Flutter: Build APK (Release)"
  }
]
```

## Verificar dispositivos disponíveis

Para ver quais dispositivos Android estão disponíveis, execute no terminal:
```bash
flutter devices
```

Ou use a task "Flutter: Listar dispositivos" no VSCode.

