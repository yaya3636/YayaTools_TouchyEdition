# Instalation
  1. Créer un dossier nommée YayaTools_TouchyEdition a la racine de Touchy
  2. Télécharger les fichiers présent sur github et placer les dans le dossier fraîchement créer

# Utilisation
  1. Déclarer la variable Tools en haut de votre script comme ci dessous : <br>
     ```lua
     Tools = require("YayaTools_TouchyEdition.Modules.Tools")()
     ```
     # Documentation

> En cours de développement

<details><summary>Tools</summary>
<p>
 - Instanciation
```lua
Tools = require("YayaTools_TouchyEdition.Modules.Tools")()
```
- Méthodes
  ---
  ### Tools.dump(paramsA)
    > Transforme une table en une chaine de caractère lisible
    - Params :
      1. Table
  - Exemple :  
  ```lua
  local uneTable = { a = { z = 1 }, b = true, c = 1, d = "d" }
  global:printMessage(Tools.dump(uneTable))
  ```
  ---
</p>
</details>

<details><summary>List</summary>
<p>

- Instanciation
```lua
local maList = Tools.list()
```
- Méthodes
  https://github.com/lalawue/linked-list.lua
</p>
</details>
