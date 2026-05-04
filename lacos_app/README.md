# Laço's - Minha Saúde Feminina

Aplicativo Android voltado para o monitoramento da saúde feminina, com foco em ciclo menstrual, registro de sintomas, conteúdos educativos e autocuidado.

## Stack Tecnológica

- **Frontend:** Flutter (Dart)
- **Backend:** Supabase (Auth + PostgreSQL)
- **Arquitetura:** Clean Architecture

## Configuração

### 1. Flutter SDK
Certifique-se de ter o Flutter SDK instalado e no PATH:
```
flutter doctor
```

### 2. Supabase
Execute o script `supabase_schema.sql` no SQL Editor do Supabase para criar as tabelas.

### 3. Dependências
```
flutter pub get
```

### 4. Executar
```
flutter run
```

## Estrutura do Projeto

```
lib/
  core/           → Constantes, tema, widgets compartilhados
  data/           → Models, datasources, repositories
  presentation/   → Pages, widgets, controllers
  main.dart       → Entry point
```

## Aviso Legal

Este aplicativo não substitui avaliação médica. Em caso de dúvidas, procure uma unidade de saúde.
