# ClassShare

Aplicativo mobile desenvolvido em Flutter para organização e compartilhhamento de registros fotográficos acadêmicos por curso, semestre e disciplina.

## Sobre o projeto

O ClassShare é um projeto acadêmico criado para facilitar o armazenamento e a visualização de conteúdos registrados durante as aulas. Os dados são armazenados localmente no dispositivo utilizando SQLite, sem dependência de servidores externos.

## Funcionalidades

- Organização por cursos, semestres e disciplinas
- Feed de postagens com imagem, título, descrição e data
- Tela de detalhes da postagem
- Adição e exclusão de cursos e disciplinas
- Captura de fotos pela câmera ou seleção pela galeria
- Persistência local de dados com SQLite
- Navegação simples e organizada

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite (sqflite)
- image_picker
- Material Design 3

## Fluxo do aplicativo

Login
↓
Tela de apresentação
↓
Cursos
↓
Semestres
↓
Disciplinas
↓
Feed de postagens
↓
Detalhes da postagem

## Estrutura do projeto

lib/
├── database/       → persistência SQLite
├── models/         → estrutura dos dados
├── screens/        → telas do aplicativo
├── theme/          → identidade visual global
├── widgets/        → componentes reutilizáveis
└── main.dart

## Banco de dados

Tabelas utilizadas:

- cursos
- semestres
- salas
- posts

## Como executar

Pré-requisitos:

- Flutter SDK instalado
- Dispositivo Android ou emulador configurado

flutter pub get
flutter run

## Melhorias futuras

- Integração com Firebase para sincronização em nuvem
- Sistema de autenticação de usuários
- Compartilhamento online de postagens
- Upload de imagens para armazenamento remoto
- Organização colaborativa entre alunos

## Integrantes

- Erick Alves da Silva
- Fábio da Rocha e Silva Alcântara
- Felipe Choiti Yonaha
- Lucas Ancilon Pavão
- Paloma Oliveira Cordeiro

Projeto acadêmico desenvolvido para fins educacionais.

