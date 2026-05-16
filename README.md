# ClassShare

Aplicativo mobile desenvolvido em Flutter para organização e compartilhamento de registros fotográficos acadêmicos por curso, semestre e disciplina.

---

## Sobre o projeto

O ClassShare é um projeto acadêmico que facilita o armazenamento e visualização de conteúdos registrados durante as aulas. Todos os dados são armazenados localmente no dispositivo, sem dependência de internet ou servidores externos.

---

## Funcionalidades

- Organização por curso, semestre e disciplina
- Feed de postagens com imagem, título, descrição e data
- Tela de detalhes da postagem
- Adição de novas disciplinas e cursos
- Captura de foto pela câmera ou seleção pela galeria
- Exclusão de cursos, disciplinas e postagens com confirmação
- Persistência local com SQLite

---

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite (sqflite)
- image_picker
- Material Design 3

---

## Fluxo do aplicativo

```
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
```

---

## Estrutura do projeto

```
lib/
 ├── database/       → persistência SQLite
 ├── models/         → estrutura dos dados
 ├── screens/        → telas do aplicativo
 ├── theme/          → identidade visual global
 ├── widgets/        → componentes reutilizáveis
 └── main.dart
```

---

## Banco de dados

Tabelas utilizadas:

- `cursos`
- `semestres`
- `salas`
- `posts`

---

## Como executar

**Pré-requisitos:** Flutter SDK instalado e dispositivo/emulador Android configurado.

```bash
flutter pub get
flutter run
```

---

## Integrantes

- Erick Alves da Silva
- Fábio da Rocha e Silva Alcântara
- Felipe Choiti Yonaha
- Lucas Ancilon Pavão
- Paloma Oliveira Cordeiro

---

Projeto acadêmico desenvolvido para fins educacionais.
