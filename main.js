import "./assets/style.css";

import Main from "./src/Main.elm";

let app = Main.init({
  node: document.getElementById("app"),
  flags: {
    windowWidth: parseInt(window.innerWidth),
    windowHeight: parseInt(window.innerHeight),
  },
});
