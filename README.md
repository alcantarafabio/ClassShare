# ClassShare

Aplicativo mobile desenvolvido em Flutter para organização e compartilhamento de registros fotográficos acadêmicos por semestre e disciplina.

---

## Sobre o projeto

O ClassShare foi desenvolvido como projeto acadêmico com o objetivo de facilitar o armazenamento e visualização de conteúdos registrados durante as aulas.

O aplicativo permite:

* organizar disciplinas por semestre;
* criar salas/disciplina;
* publicar registros fotográficos;
* adicionar título e descrição nas postagens;
* visualizar feed de imagens;
* utilizar câmera ou galeria do dispositivo;
* armazenar os dados localmente utilizando SQLite.

---

## Funcionalidades

### Organização acadêmica

* Separação por semestres;
* Separação por disciplinas/salas.

### Feed de postagens

* Visualização das postagens por disciplina;
* Exibição de imagem, título, descrição e data;
* Tela de detalhes da postagem.

### Criação de conteúdo

* Seleção de imagem pela galeria;
* Captura de foto pela câmera;
* Cadastro de título e descrição.

### Persistência local

* Banco SQLite local;
* Armazenamento das postagens no dispositivo.

### Gerenciamento

* Exclusão de disciplinas;
* Exclusão de postagens;
* Confirmação visual antes da exclusão.

---

## Tecnologias utilizadas

* Flutter
* Dart
* SQLite
* sqflite
* image_picker
* Material Design

---

## Estrutura do projeto

```text
lib/
 ├── database/
 ├── models/
 ├── screens/
 ├── theme/
 ├── widgets/
 └── main.dart
```

### Organização

* `screens/` → telas do aplicativo
* `widgets/` → componentes reutilizáveis
* `models/` → estrutura dos dados
* `database/` → persistência SQLite
* `theme/` → identidade visual global

---

## Fluxo do aplicativo

```text
Login
↓
Tela de apresentação
↓
Semestres
↓
Disciplinas
↓
Feed de postagens
↓
Nova postagem
```

---

## Banco de dados

O aplicativo utiliza SQLite local para persistência.

Tabelas utilizadas:

* `semestres`
* `salas`
* `posts`

Os dados são gerenciados através da classe:

```dart
DatabaseHelper
```

---

## Arquitetura

O projeto foi desenvolvido priorizando:

* simplicidade;
* legibilidade;
* separação de responsabilidades;
* componentização básica;
* manutenção acadêmica.

---

## Status do projeto

### MVP Finalizado

O projeto atualmente possui:

* CRUD parcial;
* navegação entre telas;
* persistência local;
* feed de imagens;
* integração com câmera e galeria;
* experiência visual refinada para apresentação acadêmica.

---

## Integrantes

* Erick Alves da Silva
* Fábio da Rocha e Silva Alcântara
* Felipe Choiti Yonaha
* Lucas Ancilon Pavão
* Paloma Oliveira Cordeiro

---

## Desenvolvimento principal

Projeto desenvolvido em grupo com implementação principal, arquitetura e coordenação técnica realizadas por:

Fábio da Rocha e Silva Alcântara

---

## Observações

Projeto acadêmico desenvolvido para fins educacionais.
