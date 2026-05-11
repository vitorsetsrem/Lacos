# Laço's - Minha Saúde Feminina

> Aplicativo mobile (Android & iOS) de saúde feminina que integra autocuidado, informação confiável, acompanhamento do ciclo menstrual, educação em saúde, lembretes e suporte contínuo.

---

## Objetivo do Projeto

Auxiliar mulheres em todas as fases da vida (adolescência, fase adulta, tentantes, gestação, pós-parto, climatério, menopausa, senescência) com uma plataforma digital acolhedora, acessível e baseada em evidências.

**Este aplicativo NÃO substitui atendimento médico.** Sempre inclui avisos educativos e incentivo à UBS.

---

## Stack Tecnológica

| Camada | Tecnologia |
|--------|-----------|
| Frontend | Flutter (Dart) SDK ^3.11.0 |
| Backend | Supabase (Auth + PostgreSQL + RLS) |
| Arquitetura | Clean Architecture |
| State Management | Riverpod |
| Gráficos | fl_chart |
| Tipografia | Leckerli One + Nunito Sans (Google Fonts) |
| Design System | Material 3 |

---

## Funcionalidades

| Módulo | Descrição | Status |
|--------|-----------|--------|
| Auth | Login/Cadastro via Supabase | ✅ |
| Dashboard/Home | Visão geral, dicas, progresso | ✅ |
| Calendário Menstrual | Registro de ciclos, intensidade, observações | ✅ |
| Conteúdos Educativos | Artigos por categoria e fase da vida | ✅ |
| Perfil | Visualização, configurações, logout | ✅ |
| Análise do Ciclo | Estatísticas, gráficos, histórico | 🔄 |
| Chat Anônimo | Perguntas educativas com avisos legais | 🔄 |
| Lembretes | Anticoncepcional, consultas, exames, vacinas | 🔄 |
| Rede de Apoio | UBS, Delegacia, CVV, CRAS, Disque 180 | 🔄 |

---

## Identidade Visual

### Paleta de Cores Oficial
| Cor | Hex | Uso |
|-----|-----|-----|
| Creme | `#FBF4EB` | Fundo principal |
| Rosa Suave | `#FBD9E5` | Cards, destaques |
| Vermelho Rosado | `#C43A4A` | CTAs, ícones ativos |
| Rosa Médio | `#C56682` | Elementos complementares |
| Salmão | `#E7A48C` | Acentos suaves |

### Tipografia
- **Leckerli One** — títulos decorativos
- **Nunito Sans** — texto principal (corpo)

### Estilo Visual
- Minimalista e clean
- Feminino elegante (sem infantilidade)
- Cards arredondados com sombras suaves
- Bastante espaço em branco
- Interface clara e acolhedora

---

## Estrutura do Projeto

```
lacos_app/
├── lib/
│   ├── core/
│   │   ├── constants/      → Cores, strings, constantes
│   │   ├── theme/          → Tema global Material 3
│   │   └── widgets/        → Widgets reutilizáveis (botões, disclaimers)
│   ├── data/
│   │   ├── datasources/    → Comunicação com Supabase
│   │   ├── models/         → Modelos de dados (JSON serialization)
│   │   └── repositories/   → Implementação dos repositórios
│   ├── domain/
│   │   ├── entities/       → Entidades de negócio
│   │   └── usecases/       → Casos de uso
│   ├── presentation/
│   │   └── pages/          → Telas (auth, home, ciclo, conteúdos, perfil)
│   └── main.dart           → Entry point
├── android/                → Configurações nativas Android
├── ios/                    → Configurações nativas iOS (quando adicionado)
├── assets/                 → Imagens e recursos estáticos
├── test/                   → Testes unitários e de widget
└── pubspec.yaml            → Dependências
```

---

## Configuração do Ambiente

### Pré-requisitos
- Flutter SDK ^3.11.0
- Dart SDK (incluído no Flutter)
- Android Studio / Xcode (para emuladores)
- Conta Supabase (gratuita)

### 1. Clone e Instale
```bash
git clone <repo-url>
cd lacos_app
flutter pub get
```

### 2. Configure o Supabase
1. Crie um projeto no [Supabase](https://supabase.com)
2. Execute `supabase_schema.sql` no SQL Editor
3. Copie a URL e Anon Key do projeto

### 3. Variáveis de Ambiente
```bash
cp .env.example .env
# Edite .env com suas credenciais reais
```

### 4. Execute
```bash
flutter run                    # Debug (emulador/dispositivo)
flutter run --release          # Release mode
```

---

## Build para Produção

### Android (APK / AAB)
```bash
# APK (instalação direta)
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxx

# AAB (Google Play)
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxx
```

### iOS (IPA)
```bash
flutter build ipa --release \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxx
```

---

## Segurança

- **RLS (Row Level Security)** em todas as tabelas do Supabase
- Chaves de API NUNCA versionadas no repositório
- `.gitignore` protege certificados, keystores, builds e secrets
- Dados de saúde tratados conforme LGPD (Lei 13.709/2018)
- Consulte `SECURITY.md` na raiz do projeto para detalhes completos

---

## Banco de Dados

### Tabelas
| Tabela | Descrição |
|--------|-----------|
| `usuarias` | Perfil da usuária |
| `ciclos_menstruais` | Registros do ciclo |
| `sintomas` | Sintomas registrados |
| `conteudos` | Conteúdos educativos (público) |
| `lembretes` | Lembretes e alertas |

### Políticas RLS
- Usuárias: CRUD apenas nos próprios dados
- Conteúdos: leitura pública
- Ciclos/Sintomas/Lembretes: acesso restrito ao dono

---

## Entregáveis do Projeto

- [x] Estrutura organizada dos conteúdos médicos
- [x] Repositório organizado com Clean Architecture
- [x] Interface simples, intuitiva e acolhedora
- [x] Compatível com Android e iOS
- [x] Identidade visual aplicada
- [x] Segurança implementada (RLS, .gitignore, SECURITY.md)
- [x] Primeira versão funcional navegável
- [ ] Geração final APK/AAB/IPA

---

## Aviso Legal

> ⚠️ **Este aplicativo não substitui avaliação médica.**
> Em caso de dúvidas ou emergências, procure uma Unidade Básica de Saúde (UBS) ou ligue para os serviços de emergência.

---

## Licença

Projeto acadêmico — uso restrito à equipe de desenvolvimento.
