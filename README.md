# Details of setting it up first time
This guid is captured from the youtube video. [RaynYoutubeChannel](https://www.youtube.com/watch?v=YfS5BJ4IXcQ)   

## Create an elm project
```bash
mkdir my_template
cd my_template
elm init
tree
.
├── elm.json
└── src
```

## Linking elm with vite

```bash
npm init -y
npm install -DE vite
npm install -DE vite-plugin-elm-watch
```

## Configuring vite

```bash
touch vite.config.js
```
## contents of vite.config.js
```js
import { defineConfig } from "vite";

import elm from "vite-plugin-elm-watch";

export default defineConfig({
  plugins: [elm()],
});
```

## Contents of index.html

```html
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>My Elm App Template</title>
</head>

<body>
	<div id="app"> </div>
	<script type="module" src="./main.js"></script>
</body>

</html>
```

## contents of the package.json 

```json
{
  "name": "my_template",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "type": "module",  <---- This is manually added. Without this there will be some strange errors.
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "vite": "5.3.1",
    "vite-plugin-elm-watch": "1.3.4"
  }
}
```
## Create a main.js file as an entry point

```bash
import "./assets/style.css";
import Main from "./src/Main.elm";

let app = Main.init({
  node: document.getElementById("app"),
});

```
## Here is how now the directory structure looks like

```bash
.
├── assets
│   └── style.css
├── elm.json
├── index.html
├── main.js
├── package.json
├── package-lock.json
├── src
│   └── Main.elm  <-- Here we are using the name as Main and hence in main.js file we used "import Main  from './src/Main.elm'"
└── vite.config.js
```
## Run the vite server.

```bash
npx vite
```
