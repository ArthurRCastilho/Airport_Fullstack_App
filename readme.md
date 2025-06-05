# Airport Fullstack App

## Descrição
Durante meus estudos na matérdia de Sistemas Distribuidos, aprendemos conceitos básicos do desenvolvimento back-end, models, controllers, middleware, rotas, login, hash dentre outras.<br>

Na matéria desenvolvi uma API que simula de forma simples o controle de um sistema para aeroportos.
Funcionário -> Vizualiza Portões, Voos e Passageiros disponível
Administrador -> Cria e Vizualiza Portões, Voos e Passageiros. Além de poder mudar o status de Voos e Passageiros

Com isso me desafiei a criar uma aplicação mobile para implementar com este back-end, portanto com flutter decidi criar a aplicação que consegue utilizar tudo o que eu fiz no back-end para apresentar no front-end.

## Ferramentas utilizadas
- [Flutter - Front-end](https://flutter.dev/)
- [Node.js - back-end](https://nodejs.org/pt)
- [MongoDB Compass - Banco de dados](https://www.mongodb.com/)
- [VSCode - IDE]()

## Como rodar
### 1 - Iniciar Banco de dados
Abra o mongoDB Compass e se conecte Localhost

### 2 - Iniciar back-end
Abra a pasta que contenha o arquivo back-end <br>

```
cd Back-end
``` 

<br>
e com node.js instalado inicie o servidor Back-end com o seguinte comando <br>

```
npm run dev
``` 
<br>

Deve aparecer uma mensagem que se conectou ao banco de dados

### 3 - Inicie o front-end e teste
Em uma nova janela do VSCode, com flutter instalado abra a pasta Front-end:<br>
```
cd Back-end
``` 
<br>
Inicie um simulador de sua preferência (IOS ou Android);
Rode o programa usando o seguinte código

```
flutter run
```

<br>
Agora basta criar, lembrando que o banco de dados por estar em seu PC ele não tem nada, é necessário criar contas de funcionário e Admin para testar

