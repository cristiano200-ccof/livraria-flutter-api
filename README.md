# livraria_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Livraria Digital - Consumo de API REST em Flutter

Aplicação desenvolvida em Flutter que consome uma API REST pública de livros, converte a resposta JSON em objetos tipados e exibe o catálogo dinamicamente utilizando `ListView.builder`.

## Funcionalidades Implementadas
- Requisição HTTP GET assíncrona com tratamento de timeout e falhas de rede.
- Conversão de JSON para modelo de dados (`Book`).
- Gerenciamento de estados da interface com `FutureBuilder` (carregamento, erro e sucesso).
- Listagem otimizada com `ListView.builder` e atualização via *pull-to-refresh*.

## Evidências de Execução

### 1. Indicador de Carregamento
![Tela de Carregamento](prints/carregando.png)

### 2. ListView Dinâmica Carregada
![Lista de Livros](prints/lista_livros.png)

### 3. Tratamento de Erro
![Tela de Erro](prints/erro.png)
