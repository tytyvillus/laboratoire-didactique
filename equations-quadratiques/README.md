#  « Je ne gère pas LaTeX » : démarrage rapide en ligne 

`à venir...`

# Présentation de l'outil : résoudre efficacement une équation de second degré

Le présent outil est conçu pour permettre à des élèves d'entraîner la résolution d'équations de deuxième degré $a x^2 + b x + c = 0$ en utilisant la méthode la plus appropriée, en reconnaîssant les suivants cas :

- quand $b = 0$, on peut résoudre par réarrangement $x^2 = - \frac c a$ ;

- quand $c = 0$, on peut factoriser $ax$ pour avoir $a x (\frac b a x + \frac c a) = 0$ ;

- si c'est un carré parfait, utiliser les identités remarquables $(A \pm B)^2$ pour factoriser ;

- si les nombres sont petits, factoriser par trinôme ;

- et sinon, utiliser la formule de Viète.

(Certains cas spéciaux sont aussi inclus : l'équation de premier degré, ou de type $0 = 1$, ou $0 = 0$ ; ceux-ci apparaissent avec une faible probabilité.)

Pour ce faire, l'outil permet de produire des fiches d'exercices avec des équations du second degré à résoudre le plus efficacement possible par les élèves.  Avec les exercices sont générées des solutions recommandées, choisies parmi les méthodes énumérées ci-dessus.  L'utilisation recommandée de l'outil est après avoir discuter et entraîné les différentes méthodes indépendamment, ayant expliqué l'utilité de chercher une méthode efficace, de distribuer une feuille par élève, chacune générée séparément, et de les laisser travailler à les résoudre.  Une fois une proportion suffisante des exercices résolus, l'enseignant·e peut procéder à une mise en commun lors de laquelle chaque élève — par exemple — expose l'équation dont la méthode de résolution a été perçue comme la moins évidente.

Ce projet entre dans le contexte d'entraîner la compétence de base « utiliser avec souplesse l'outillage mathématique » donné dans l'*Annexe au plan d'études cadre du 9 juin 1994 pour les écoles de maturité : Compétences de base en mathématiques et en langue première constitutives de l'aptitude générale aux études supérieures, du 17 mars 2016*. 


## Structure de l'outil

L'outil se présente comme quatre fichiers dans une archive `.zip` : la README, un fichier `codeQuadratique.lua`, un fichier `main-quadratique.tex` et un fichier `preamble-quadratique.tex`.  

- Le `*.lua` contient la majorité de l'algorithme servant à produire les questions.

- Le `preamble-*.tex` enclenche un petit nombre de paquets, librement distribués dans TEXLive, MikTEX ou sur www.ctan.org.  Ceux-ci comprennent `luacode` (automatique avec LuaLaTeX) et `luacas`, utilisé pour simplifier algébriquement certaines des équations-réponses. Dans le préambule, plusieurs commandes sont définies qui se réfèrent au `*.lua`.

- Le `main-*.tex` enclenche le préambule puis se charge de la mise en page du document.


## Utilisation de l'outil

L'outil est conçue pour que, après avoir décompressé l'archive `.zip`, il suffise d'ouvrir le fichier `main-*.pdf` dans votre éditeur TeX favori et de le compiler pour obtenir une fiche complète et utilisable.  C'est un outil « prêt à l'emploi » (« *plug and play* »). 

Il vous faut seulement vous assurer que vous ayez une distribution LaTeX à jour, et **compiler le document avec le moteur LuaLaTeX** (et non pdfLaTeX ou XeLaTeX). 

***

Le document `main-*.tex` consiste en une série de 24 exercices, mis en page préalablement à travers les commandes
```tex
\foreach \n in {1,2,...,24}{\afullroutine{\n}}
```
et `\showallquestions` et `\showallanswers`.

Quelques commandes additionnelles sont également proposées pour une mise en page alternative :

- `\aprintqna` : imprime l'équation sur une ligne, suivie de la réponse.

- `\amakequestion` : à utiliser en mode mathématique (*mathmode*), génère une équation à résoudre.

- `\amakeanswer` : à utiliser en mode texte, donne la solution recommandée à la dernière équation générée par 

Les deux dernières sont plus modulables, pouvant être utilisées pour placer l'équation et la réponse plus librement, par exemple au sein d'une plus grande feuille de travail avec d'autres types de questions.

Si vous le souhaitez, vous pouvez modifier quelques réglages dans l'algorithme qui décide des polynômes et des méthodes pour les résoudre.  Ces réglages sont tous dans la section intitulée `(EDITABLE) PREAMBLE` du fichier `.lua`. En particulier, vous avez accès aux fonctionnalités suivantes :

- choisir la graine pour la générations de nombres pseudoaléatoires, en modifiant le paramètre de la fonction `math.randomseed()` ;

- décider quels polynômes sont estimés faciles à factoriser par trinôme, en modifiant la fonction booléenne `easy_factor()` ;

- déterminer la probabilité que les solutions d'un exercice donné soient des nombres entiers, en modifiant la fonction booléenne `whether_from_factored_form()` ;

- fixer, dans le cas de solutions entières, la proportion avec laquelle un carré parfait sera imposée, avec la fonction booléenne `enforce_perfect_square()`.

***

Pour produire plusieurs feuilles différentes d'un coup, afin de pouvoir par exemple les distribuer individuellement à une classe de 20 élèves, nous n'avons malheureusement pas trouvé d'autre solution que d'appeler plusieurs fois le moteur LuaLaTeX depuis un programme externe. Par exemple, sur Linux, vous pouvez taper le code suivant dans Bash depuis le dossier contenant `main-*.tex` :

```bash
for i in {1..20}; do lualatex -jobname feuille-$i main-quadratique.tex; done
```
Il faudra cependant adapter ces commandes à la syntaxe particulière de votre système opératoire. Un autre exemple, pour Windows : ouvrez le dossier contenant `main-*.tex`, effectuez un clic-droit et sélectionner *Ouvrir dans le Terminal*. (Vérifiez que celui-ci soit bien la Windows PowerShell.) Dans le terminal, vous pouvez ensuite taper :
```powershell
for ($var = 1; $var -le 20; $var++) {lualatex.exe -jobname feuille-$var main-quadratique.tex}
```
Il vous faudra donc vous familiariser avec la variante qui vous conviendra. *N.b.* — il vous faudra aussi adapter le nom de votre moteur LuaLaTeX (`lualatex`, `lualatex.exe` ou autre).

## Licence et attributions 

Cet outil est distribué avec la licence [GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3.0.html) par ses auteurs :

- Alexandros Rispo Constantinou

Une [page GitHub pour cet outil](https://github.com/tytyvillus/laboratoire-didactique) sera bientôt aussi disponible.
