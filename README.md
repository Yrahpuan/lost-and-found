# Achados e Perdidos — UESPI

Aplicativo Flutter para a comunidade acadêmica registrar e consultar objetos perdidos ou encontrados no campus. Os registros ficam no Cloud Firestore e podem ser consultados em diferentes instalações do app.

## Funcionalidades

- Listar registros de objetos perdidos e encontrados, mostrando nome, descrição, local e situação.
- Cadastrar um objeto perdido ou encontrado.
- Validar os campos obrigatórios; limitar o nome a 60 caracteres e a descrição a 200.
- Registrar a data e hora no Firestore e ordenar os itens do mais recente para o mais antigo.
- Atualizar a listagem, exibir carregamento, lista vazia e erros, e permitir tentar novamente após uma falha.

O cadastro possui quatro campos: nome, descrição, local e situação. A data e hora são preenchidas automaticamente. O app não oferece login, edição ou exclusão de registros.

## Tecnologias

- Flutter e Dart;
- Firebase Core;
- Cloud Firestore.

## Integrantes

- Mariana da Mota Pinho
- Mayara Lima Miranda
- José Wilk Souza Lima
- Irapuam Junio da Silva

## Requisitos

- Flutter SDK instalado e configurado (`flutter doctor`);
- Um dispositivo Android ou navegador para executar o aplicativo.

O repositório já contém as configurações cliente para o projeto Firebase usado pela equipe. Para executar o app como configurado, não é necessário instalar Firebase CLI ou FlutterFire CLI.

## Baixar dependências e executar

Na raiz do projeto, execute:

```bash
flutter pub get
```

Para executar no Android, conecte um dispositivo ou inicie um emulador e rode:

```bash
flutter run
```

Para executar na web e abrir o endereço em um navegador instalado, rode:

```bash
flutter run -d web-server
```

O terminal exibirá o endereço local. Abra-o no navegador.

## Firebase e Firestore

- Projeto Firebase: `uespi-achados-perdidos-2026`.
- Banco padrão do Firestore, na região `southamerica-east1` (São Paulo).
- Coleção usada pelo app: `items`.
- Campos: `name`, `description`, `location`, `status` (`lost` ou `found`) e `createdAt` (timestamp do servidor).
- `lib/firebase_options.dart` e `android/app/google-services.json` configuram o app para conectar ao Firebase. `.firebaserc` e `firebase.json` configuram a Firebase CLI para publicar as regras.
- As regras em `firestore.rules` permitem leitura e criação, validam os campos e bloqueiam atualização e exclusão. Para republicá-las, instale e autentique a Firebase CLI e execute:

  ```bash
  firebase login
  firebase deploy --only firestore:rules --project uespi-achados-perdidos-2026
  ```

O app não usa autenticação; qualquer pessoa que consiga acessá-lo pode ler e cadastrar registros. Usem apenas dados demonstrativos, sem informações pessoais ou sensíveis. As configurações Firebase incluídas são identificadores de cliente, não credenciais administrativas. Nunca publiquem chaves de contas de serviço ou tokens privados.

## Organização do código

- `lib/src/features/items/lost_item.dart`: modelo do registro;
- `lib/src/features/items/items_repository.dart`: leitura e gravação no Firestore;
- `lib/src/features/items/items_controller.dart`: carregamento, cadastro e estados da interface;
- `lib/src/features/items/items_page.dart`: listagem e atualização;
- `lib/src/features/items/item_form_page.dart`: formulário e validação.
