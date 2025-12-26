# Documentação de Funcionalidades - Estai

## Visão Geral do App

**Estai** é um aplicativo de navegação náutica desenvolvido em Flutter, projetado para navegadores, pescadores e entusiastas do mar. O app oferece ferramentas profissionais de navegação, planejamento de rotas, informações de marés e mapas náuticos customizados.

### Público-Alvo
- Navegadores recreativos e profissionais
- Pescadores esportivos e comerciais
- Entusiastas de esportes aquáticos
- Capitães e tripulações de embarcações

### Principais Benefícios
- **Navegação em Tempo Real**: Rastreamento GPS preciso com atualização contínua
- **Planejamento Inteligente**: Criação e gerenciamento de rotas personalizadas
- **Informações Náuticas**: Acesso a tabelas de marés e mapas especializados
- **Sincronização na Nuvem**: Rotas salvas sincronizadas entre dispositivos
- **Interface Intuitiva**: Design moderno e fácil de usar mesmo em condições adversas
- **Multilíngue**: Suporte completo para Português e Inglês

---

## Funcionalidades Principais

### 1. Mapa Interativo

O coração do aplicativo é um mapa interativo com camadas customizadas de mapas náuticos.

**Recursos:**
- Visualização de mapa com zoom e pan
- Camadas de mapas náuticos customizados (sobrepostos ao mapa base)
- Marcadores de localização do usuário em tempo real
- Visualização de rotas planejadas e rotas rastreadas
- Linha de direção indicando o rumo atual

**Controles:**
- Botão de lock/unlock da câmera (fixa a visualização na posição do usuário)
- Toggle de exibição de mapas customizados
- Botão de menu inferior para acesso rápido a funcionalidades

### 2. Navegação e Rastreamento

Sistema completo de navegação com rastreamento automático da rota percorrida.

**Recursos:**
- **Início de Navegação**: Ativação manual do modo navegação
- **Rastreamento Automático**: Registro automático da rota percorrida
- **Filtro de Distância Mínima**: Configurável (5-50 metros) para otimizar armazenamento
- **Dados de Navegação em Tempo Real**:
  - Velocidade (VEL) em nós
  - Rumo (HDG) em graus
  - Latitude e Longitude formatadas
  - Distância total percorrida (em milhas náuticas)
  - Tempo decorrido (formato HH:MM:SS)
- **Visualização da Rota Rastreada**: Linha no mapa mostrando o caminho percorrido
- **Finalização de Navegação**: Parada e reset do rastreamento

**Dados Exibidos:**
- Painel superior direito: VEL, HDG, LAT, LON
- Painel inferior esquerdo (durante navegação): Distância total e Tempo decorrido

### 3. Planejamento de Rotas

Sistema completo para criar, editar e gerenciar rotas náuticas.

**Criação de Rotas:**
- Modo de planejamento ativável via menu
- Adição de pontos de rota através de toque longo no mapa
- Confirmação de cada ponto antes de adicionar
- Edição de pontos existentes (arrastar para reposicionar)
- Remoção do último ponto adicionado
- Visualização da rota planejada no mapa com linha conectando os pontos
- Marcadores visuais para cada ponto da rota

**Gerenciamento:**
- Salvar rota com nome personalizado
- Lista de rotas salvas com informações detalhadas
- Edição do nome da rota
- Exclusão de rotas
- Carregamento de rotas salvas para navegação
- Início de navegação direto a partir de rota salva

**Informações da Rota:**
- Número de pontos
- Distância total calculada (em milhas náuticas)
- Data de criação
- Visualização no mapa antes de iniciar navegação

### 4. Tábuas de Marés

Acesso completo a tabelas de marés de estações ao redor do mundo.

**Recursos:**
- Lista de estações de maré disponíveis
- Ordenação por proximidade (quando localização disponível)
- Distância calculada até cada estação
- Visualização de PDFs das tabelas de maré
- Informações de coordenadas de cada estação
- Atualização automática da lista baseada na localização do usuário

**Interface:**
- Cards com informações de cada estação
- Botão de acesso direto ao PDF da tabela
- Indicador de distância quando aplicável
- Suporte a visualização de PDFs integrada

### 5. Mapas Customizados

Sistema de mapas náuticos especializados sobrepostos ao mapa base.

**Recursos:**
- Lista de mapas disponíveis do servidor
- Seleção múltipla de mapas para sobreposição
- Modo escuro para mapas (toggle)
- Ativação/desativação rápida dos mapas customizados
- Informações de zoom mínimo e máximo de cada mapa
- Persistência das seleções de mapas

**Interface:**
- Tela dedicada para gerenciamento de mapas
- Cards visuais para cada mapa disponível
- Toggle de seleção individual
- Indicador de quantos mapas estão selecionados
- Botão de toggle de modo escuro

### 6. Gerenciamento de Rotas Salvas

Sistema completo de persistência e sincronização de rotas.

**Recursos:**
- Armazenamento na nuvem (Firebase Firestore)
- Sincronização entre dispositivos (para usuários autenticados)
- Lista de todas as rotas salvas
- Informações detalhadas de cada rota:
  - Nome personalizado
  - Número de pontos
  - Distância total
  - Data de criação
- Edição de nome de rota
- Exclusão de rotas
- Carregamento rápido para navegação

**Interface:**
- Tela de lista com cards informativos
- Menu de ações (editar/excluir) por rota
- Diálogo de confirmação para ações destrutivas
- Visualização prévia antes de iniciar navegação

### 7. Autenticação e Conta de Usuário

Sistema completo de autenticação com Firebase.

**Funcionalidades de Autenticação:**
- **Login**: Acesso com email e senha
- **Cadastro**: Criação de conta com nome, email e senha
- **Recuperação de Senha**: Envio de email para redefinição
- **Continuar sem Login**: Modo de uso básico sem autenticação
- **Logout**: Encerramento seguro de sessão

**Conta de Usuário:**
- Visualização de informações do perfil:
  - Nome de exibição
  - Email cadastrado
- Gerenciamento de sessão
- Acesso condicional a funcionalidades (rotas salvas na nuvem)

**Segurança:**
- Validação de formulários
- Mensagens de erro localizadas
- Tratamento de erros de autenticação
- Proteção contra ações não autorizadas

### 8. Configurações

Sistema de configurações personalizáveis para otimizar a experiência.

**Configurações de Navegação:**
- **Distância Mínima de Rastreamento**: Slider configurável de 5 a 50 metros
  - Controla a frequência de registro de pontos durante navegação
  - Valores menores = mais pontos (maior precisão, mais dados)
  - Valores maiores = menos pontos (menor precisão, menos dados)
  - Tooltip explicativo da funcionalidade
  - Persistência das configurações

**Acesso Rápido:**
- Link para configurações de navegação
- Link para conta de usuário (quando autenticado)
- Botões de login/cadastro (quando não autenticado)

---

## Detalhamento por Tela

### LoginScreen

**Propósito**: Autenticação de usuários existentes

**Elementos:**
- Campo de email com validação
- Campo de senha com toggle de visibilidade
- Link "Esqueci minha senha"
- Botão de login com indicador de carregamento
- Link para criação de conta
- Opção "Continuar sem login"
- Mensagens de erro contextuais

**Fluxo:**
1. Usuário preenche email e senha
2. Validação de formulário
3. Tentativa de login via Firebase Auth
4. Redirecionamento para MapScreen em caso de sucesso
5. Exibição de erro em caso de falha

### SignUpScreen

**Propósito**: Criação de novas contas

**Elementos:**
- Campo de nome (mínimo 2 caracteres)
- Campo de email com validação
- Campo de senha (mínimo 6 caracteres) com toggle de visibilidade
- Botão de cadastro com indicador de carregamento
- Link para tela de login
- Mensagens de erro contextuais

**Fluxo:**
1. Usuário preenche nome, email e senha
2. Validação de formulário
3. Criação de conta via Firebase Auth
4. Redirecionamento automático para MapScreen
5. Tratamento de erros (email já em uso, senha fraca, etc.)

### ForgotPasswordScreen

**Propósito**: Recuperação de senha via email

**Elementos:**
- Campo de email
- Botão de envio de email
- Mensagem de confirmação quando email é enviado
- Link de volta para login
- Mensagens de erro contextuais

**Fluxo:**
1. Usuário informa email cadastrado
2. Envio de email de recuperação via Firebase Auth
3. Confirmação visual de envio
4. Usuário acessa link no email para redefinir senha

### MapScreen

**Propósito**: Tela principal do aplicativo com mapa interativo

**Elementos Principais:**
- Mapa interativo (FlutterMap)
- Marcador de posição do usuário
- Painéis de dados de navegação
- Botões de ação flutuantes
- Menu inferior (bottom sheet)
- Widgets de planejamento de rota
- Indicadores de status de navegação

**Widgets Integrados:**
- `MapUserMarker`: Marcador da posição atual
- `MapNavigationData`: Painel de dados (VEL, HDG, LAT, LON)
- `MapActionsButtons`: Botões de lock de câmera e toggle de mapas
- `MapBottomSheet`: Menu de acesso rápido
- `RoutePlanner`: Controles de planejamento de rota
- `RouteDistance`: Exibição de distância da rota planejada
- `NavigationStatus`: Status de navegação ativa
- `PlannedRouteLine`: Linha da rota planejada
- `TrackedRouteLine`: Linha da rota rastreada
- `MapDirectionLine`: Linha indicando direção atual

**Interações:**
- Toque longo: Adiciona ponto de rota (modo planejamento)
- Arrastar: Move ponto de rota (modo planejamento)
- Zoom/Pan: Navegação pelo mapa
- Botões flutuantes: Ações rápidas

**Estados:**
- Modo normal: Navegação livre pelo mapa
- Modo planejamento: Criação/edição de rotas
- Modo navegação: Rastreamento ativo

### ListMapsScreen

**Propósito**: Gerenciamento de mapas customizados

**Elementos:**
- Lista de mapas disponíveis
- Toggle de modo escuro
- Informação de mapas selecionados
- Cards de mapa com:
  - Nome do mapa
  - Informações de zoom (min/max)
  - Checkbox de seleção
- Pull-to-refresh
- Estados de carregamento e erro

**Funcionalidades:**
- Seleção/deseleção de mapas
- Toggle de modo escuro global
- Atualização da lista
- Persistência de seleções

### TideScreen

**Propósito**: Acesso a tabelas de marés

**Elementos:**
- Lista de estações de maré
- Cards informativos com:
  - Nome da estação
  - Coordenadas (formato legível)
  - Distância até a estação (quando aplicável)
  - Botão de acesso ao PDF
- Estados de carregamento e erro
- Pull-to-refresh

**Funcionalidades:**
- Carregamento automático baseado em localização
- Ordenação por proximidade
- Visualização de PDFs
- Cálculo de distância em tempo real

### RoutesListScreen

**Propósito**: Gerenciamento de rotas salvas

**Elementos:**
- Lista de rotas salvas
- Cards de rota com:
  - Nome da rota
  - Número de pontos
  - Data de criação
  - Menu de ações (editar/excluir)
- Estado vazio quando não há rotas
- Diálogos de confirmação

**Funcionalidades:**
- Visualização de todas as rotas
- Edição de nome
- Exclusão de rotas
- Carregamento para navegação
- Diálogo de detalhes antes de iniciar navegação

### SettingsScreen

**Propósito**: Acesso centralizado a configurações

**Elementos:**
- Tile de configurações de navegação
- Tile de conta de usuário (quando autenticado)
- Botões de login/cadastro (quando não autenticado)

**Navegação:**
- Link para NavigationSettingsScreen
- Link para UserAccountScreen
- Links para LoginScreen/SignUpScreen

### NavigationSettingsScreen

**Propósito**: Configuração de parâmetros de navegação

**Elementos:**
- Slider de distância mínima (5-50 metros)
- Indicadores de valores mínimo e máximo
- Tooltip explicativo
- Persistência automática de configurações

**Funcionalidades:**
- Ajuste fino da frequência de rastreamento
- Feedback visual imediato
- Salvamento automático

### UserAccountScreen

**Propósito**: Gerenciamento de conta de usuário

**Elementos (Autenticado):**
- Cards informativos com:
  - Nome do usuário
  - Email cadastrado
- Seção de logout com:
  - Descrição da ação
  - Botão de confirmação
  - Indicador de carregamento

**Elementos (Não Autenticado):**
- Mensagem informativa
- Indicação para fazer login

**Funcionalidades:**
- Visualização de dados do perfil
- Logout seguro
- Redirecionamento após logout

---

## Recursos Técnicos

### Localização em Tempo Real

**Tecnologia**: Geolocator com stream contínuo

**Recursos:**
- Obtenção inicial rápida da localização
- Stream de atualizações contínuas
- Filtro de distância configurável (5 metros padrão)
- Alta precisão (LocationAccuracy.high)
- Tratamento de permissões e serviços desabilitados
- Tratamento de erros de localização

**Dados Capturados:**
- Latitude e Longitude
- Velocidade (em m/s, convertida para nós)
- Rumo/Heading (em graus)
- Precisão
- Timestamp

### Mapas Offline/Customizados

**Tecnologia**: Tile layers customizados via API própria

**Recursos:**
- Servidor de mapas próprio (maps-api.estai.com.br)
- Suporte a múltiplas camadas sobrepostas
- Modo escuro para mapas
- Controle de zoom mínimo e máximo por mapa
- Cache de tiles para performance
- Integração com OpenStreetMap e OpenSeaMap

**Formato:**
- URL template: `/maps/{mapId}/{z}/{x}/{y}.png`
- Parâmetro opcional: `?dark=true` para modo escuro

### Sincronização na Nuvem

**Tecnologia**: Firebase Firestore

**Recursos:**
- Persistência local habilitada
- Sincronização automática
- Estrutura de dados:
  - Rotas salvas por usuário
  - Metadados (nome, data de criação)
  - Pontos de rota (array de coordenadas)
- Offline-first: Funciona sem conexão, sincroniza quando online

**Segurança:**
- Autenticação obrigatória para salvar rotas
- Regras de segurança do Firestore
- Dados privados por usuário

### Suporte Multilíngue

**Tecnologia**: Flutter Localizations (ARB files)

**Idiomas Suportados:**
- Português (pt_BR) - Padrão
- Inglês (en_US)

**Cobertura:**
- Todas as strings da interface
- Mensagens de erro
- Formatação de dados (coordenadas, distâncias, etc.)
- Mensagens de validação

**Arquivos:**
- `app_pt.arb`: Traduções em português
- `app_en.arb`: Traduções em inglês
- Geração automática de classes de localização

### Formatação de Dados Náuticos

**Recursos:**
- **Coordenadas**: Formato graus/minutos/segundos com direção (N/S, E/W)
- **Velocidade**: Conversão de m/s para nós (knots)
- **Rumo**: Formato em graus (0-360)
- **Distância**: Milhas náuticas (NM) para navegação, metros/quilômetros para distâncias curtas
- **Tempo**: Formato HH:MM:SS

**Utilitários:**
- `CoordinateFormatter`: Formatação de coordenadas
- Cálculos de distância usando biblioteca latlong2
- Conversões de unidades náuticas

---

## Diferenciais e Benefícios

### Recursos Únicos

1. **Mapas Náuticos Customizados**
   - Mapas especializados não disponíveis em apps genéricos
   - Múltiplas camadas sobrepostas
   - Modo escuro para uso noturno

2. **Rastreamento Inteligente**
   - Filtro de distância mínima configurável
   - Otimização automática de armazenamento
   - Precisão ajustável conforme necessidade

3. **Planejamento Visual de Rotas**
   - Interface tátil intuitiva
   - Edição em tempo real (arrastar pontos)
   - Visualização imediata no mapa

4. **Dados Náuticos Completos**
   - Velocidade em nós
   - Rumo em graus
   - Coordenadas formatadas profissionalmente
   - Distâncias em milhas náuticas

5. **Integração com Tabelas de Marés**
   - Acesso direto a PDFs oficiais
   - Ordenação por proximidade
   - Sem necessidade de apps externos

### Vantagens Competitivas

1. **Especialização Náutica**
   - Desenvolvido especificamente para navegação marítima
   - Terminologia e unidades corretas
   - Recursos relevantes para o contexto náutico

2. **Performance e Confiabilidade**
   - Rastreamento eficiente com filtros configuráveis
   - Funcionamento offline para mapas base
   - Sincronização inteligente na nuvem

3. **Experiência do Usuário**
   - Interface limpa e focada
   - Acesso rápido a funcionalidades principais
   - Feedback visual claro em todas as ações

4. **Flexibilidade**
   - Uso sem autenticação para funcionalidades básicas
   - Sincronização opcional para usuários registrados
   - Configurações personalizáveis

5. **Custo-Benefício**
   - Funcionalidades profissionais
   - Sem necessidade de hardware adicional
   - Atualizações contínuas

### Casos de Uso

1. **Navegação Recreativa**
   - Planejamento de rotas para passeios
   - Rastreamento de trajetos
   - Consulta de marés para timing ideal

2. **Pesca Esportiva**
   - Marcação de pontos de pesca
   - Retorno a locais favoritos
   - Acompanhamento de deslocamentos

3. **Navegação Profissional**
   - Planejamento detalhado de rotas
   - Registro de navegações
   - Acesso a mapas náuticos especializados

4. **Treinamento e Aprendizado**
   - Prática de navegação
   - Entendimento de coordenadas
   - Estudo de rotas históricas

5. **Segurança**
   - Rastreamento de rotas percorridas
   - Compartilhamento de localização (futuro)
   - Registro de navegações para análise

---

## Fluxos Principais

### Fluxo de Navegação Completa

1. Usuário abre o app → MapScreen carrega
2. App solicita permissão de localização
3. Posição atual é exibida no mapa
4. Usuário ativa modo navegação via menu
5. Rastreamento automático inicia
6. Dados de navegação são exibidos em tempo real
7. Rota rastreada é visualizada no mapa
8. Usuário finaliza navegação
9. Dados são resetados

### Fluxo de Planejamento de Rota

1. Usuário acessa menu → "Nova Rota"
2. Modo planejamento é ativado
3. Usuário faz toque longo no mapa para adicionar pontos
4. Cada ponto é confirmado antes de adicionar
5. Rota é visualizada no mapa
6. Usuário pode editar pontos (arrastar) ou remover último ponto
7. Usuário confirma rota (mínimo 2 pontos)
8. Nome da rota é solicitado
9. Rota é salva (localmente ou na nuvem se autenticado)
10. Rota pode ser carregada posteriormente para navegação

### Fluxo de Autenticação

1. Usuário acessa tela de login
2. Preenche email e senha
3. Sistema valida e autentica via Firebase
4. Em caso de sucesso: redirecionamento para MapScreen
5. Em caso de erro: mensagem específica é exibida
6. Usuário autenticado tem acesso a:
   - Rotas salvas na nuvem
   - Sincronização entre dispositivos
   - Informações da conta

---

## Considerações para Landing Page

### Seções Recomendadas

1. **Hero Section**
   - Título impactante sobre navegação náutica
   - Imagem/vídeo do app em ação
   - Call-to-action para download

2. **Funcionalidades Principais**
   - Cards destacando: Mapa Interativo, Navegação, Rotas, Marés
   - Ícones e descrições curtas
   - Screenshots do app

3. **Diferenciais**
   - Comparação com apps genéricos
   - Destaque para especialização náutica
   - Recursos únicos

4. **Casos de Uso**
   - Exemplos práticos de utilização
   - Testemunhos (futuro)
   - Galeria de screenshots

5. **Download/CTA**
   - Links para App Store e Google Play
   - QR Code para download rápido
   - Informações de compatibilidade

6. **Sobre**
   - História do app
   - Tecnologias utilizadas
   - Roadmap futuro

### Mensagens-Chave

- "Navegação náutica profissional no seu bolso"
- "Tudo que você precisa para navegar com segurança"
- "Mapas náuticos especializados e planejamento de rotas inteligente"
- "Rastreamento preciso e dados náuticos em tempo real"
- "Desenvolvido por navegadores, para navegadores"

### Elementos Visuais Sugeridos

- Screenshots do mapa em ação
- Mockups do app em dispositivos
- Diagramas de funcionalidades principais
- Ícones náuticos (bússola, âncora, etc.)
- Paleta de cores: Azul marinho, branco, acentos em laranja/vermelho

---

## Conclusão

O Estai é um aplicativo completo e profissional para navegação náutica, oferecendo todas as ferramentas necessárias para planejamento, execução e registro de navegações. Com interface intuitiva, recursos especializados e tecnologia moderna, o app se posiciona como uma solução completa para navegadores de todos os níveis.

A documentação acima serve como guia completo para a criação da landing page, destacando os principais recursos, benefícios e diferenciais do aplicativo.

