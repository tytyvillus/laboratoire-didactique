##  « Je ne gère pas l'informatique » : version en ligne

Si vous voulez rapidement accéder au projet sans trop avoir à mettre les mains à la pâte, vous pouvez accéder à une [version en ligne](https://www.overleaf.com/read/dvscttnjwmfm#f98bc7). Il faut en créer une copie. Pour cela, le plus simple est de vous créer un compte sur Overleaf, d’ouvrir le lien ci-dessus puis de créer une copie du projet en cliquant sur le bouton « copie » :

![Bouton « copie » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/copier-d-overleaf-oq.png)

- Assurez-vous, si le document refuse de compiler, que le compilateur soit bien sélectionné comme LuaLaTeX et non pas pdfTeX. Vous accéder à ce paramètre depuis le menu en haut à gauche d'Overleaf.

Vous pouvez aussi télécharger les fichiers et les compiler avec **une version à jour** de LaTeX sur votre ordinateur en choisissant LuaLaTeX :

![Bouton « téléchargement » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/telecharger-d-overleaf-oq.png)

Pour une présentation plus complète, vous êtes invité·e à lire le reste de ce document, notamment la [section sur l'utilisation de l'outil](#utilisation-de-loutil).

***

# Résoudre efficacement un système de deux équations linéaires

## Présentation 

Le présent outil est conçu pour permettre à des élèves d'entraîner la résolution de systèmes d'équations linéaires de la forme 
```math
\left\{\begin{array}{c} ax + by + c = 0 \\ dx + ey + f = 0 \end{array} \right.
```
en utilisant la méthode la plus appropriée, en reconnaîssant les cas suivants :

- quand $a = 0 \text{ ou 1}$ ou $b = 0 \text{ ou 1}$, on peut isoler directement l'une des deux inconnues dans la première équation ;

- quand $d = 0$ ou $e=0$, on peut isoler directement l'une des deux inconnues dans la deuxième équation;

- si l'une des équations est un multiple de l'autre, le nombre de solutions est infini (droites confondues);

- si le déterminant de la matrice des coefficients est nul et que les deux équations ne sont pas multiples l'une de l'autre, alors les droites sont parallèles;

- si $a \mod b \equiv 0$ ou inversément, on divise toute l'équation par $b$, respectivement $a$ et on retombe dans le premier cas abordé ci-dessus; idem si $d \mod e \equiv 0$ ou inversément;

- et sinon, faire de la combinaison linéaire (via règle de Cramer si elle est connue).


Pour ce faire, l'outil permet de produire des fiches d'exercices avec des systèmes d'équations linéaires (deux ou trois) à résoudre le plus efficacement possible par les élèves.  Avec les exercices sont générées des solutions recommandées, choisies parmi les méthodes énumérées ci-dessus.  L'utilisation recommandée de l'outil est à faire après avoir discuté et entraîné les différentes méthodes indépendamment, en ayant expliqué l'utilité de chercher une méthode efficace. Ensuite, il conviendra de distribuer une feuille par élève, chacune générée séparément, et de les laisser travailler à les résoudre.  Une fois une proportion suffisante des exercices résolus, l'enseignant·e peut procéder à une mise en commun lors de laquelle chaque élève — par exemple — expose l'équation dont la méthode de résolution a été perçue comme la moins évidente.

Ce projet entre dans le contexte d'entraîner la compétence de base « utiliser avec souplesse l'outillage mathématique » donné dans l'*Annexe au plan d'études cadre du 9 juin 1994 pour les écoles de maturité : Compétences de base en mathématiques et en langue première constitutives de l'aptitude générale aux études supérieures, du 17 mars 2016*. 


## Structure de l'outil

L'outil se présente comme quatre fichiers dans une archive `.zip` : la README, un fichier `codeSysteme.lua`, un fichier `main-systeme.tex` et un fichier `preamble-systeme.tex`.  

- Le `*.lua` contient la majorité de l'algorithme servant à produire les questions.

- Le `preamble-*.tex` enclenche un petit nombre de paquets, librement distribués dans TEXLive, MikTEX ou sur www.ctan.org.  Ceux-ci comprennent `luacode` (automatique avec LuaLaTeX) et `luacas`, utilisé pour simplifier algébriquement certaines des équations-réponses. Dans le préambule, plusieurs commandes sont définies qui se réfèrent au `*.lua`.

- Le `main-*.tex` enclenche le préambule puis se charge de la mise en page du document.


## Utilisation de l'outil

L'outil est conçue pour que, après avoir décompressé l'archive `.zip`, il suffise d'ouvrir le fichier `main-*.pdf` dans votre éditeur TeX favori et de le compiler pour obtenir une fiche complète et utilisable.  C'est un outil « prêt à l'emploi » (« *plug and play* »). 

Il vous faut seulement vous assurer que vous ayez une distribution LaTeX à jour, et **compiler le document avec le moteur LuaLaTeX** (et non pdfLaTeX ou XeLaTeX).
***

### Modifier le document : mains à la pâte

Le document `main-*.tex` consiste en une série de 10 exercices, mis en page préalablement à travers les commandes
```tex
\foreach \n in {1,2,...,10}{\afullroutine{\n}}
```
et `\showallquestions` et `\showallanswers`.


Si vous le souhaitez, vous pouvez modifier quelques réglages dans l'algorithme qui décide des polynômes et des méthodes pour les résoudre.  Ces réglages sont tous dans la section intitulée `(EDITABLE) PREAMBLE` du fichier `.lua`. En particulier, vous avez accès aux fonctionnalités suivantes :

- choisir la graine pour la générations de nombres pseudoaléatoires, en modifiant le paramètre de la fonction `math.randomseed()` ;
- choisir la probabilité d'avoir une matrice de coefficients qui soit singulière, en modifiant le paramètre `probability_singular`;

***

Pour produire plusieurs feuilles différentes d'un coup, afin de pouvoir par exemple les distribuer individuellement à une classe de 20 élèves, nous n'avons malheureusement pas trouvé d'autre solution que d'appeler plusieurs fois le moteur LuaLaTeX depuis un programme externe. Par exemple, sur Linux, vous pouvez taper le code suivant dans Bash depuis le dossier contenant `main-*.tex` :

```bash
for i in {1..20}; do lualatex -jobname feuille-$i main-systeme.tex; done
```

Il faudra cependant adapter ces commandes à la syntaxe particulière de votre système opératoire. Un autre exemple, pour Windows : ouvrez le dossier contenant `main-*.tex`, effectuez un clic-droit et sélectionner *Ouvrir dans le Terminal*. (Vérifiez que celui-ci soit bien la Windows PowerShell.) Dans le terminal, vous pouvez ensuite taper :

```powershell
for ($var = 1; $var -le 20; $var++) {lualatex.exe -jobname feuille-$var main-systeme.tex}
```

Il vous faudra donc vous familiariser avec la variante qui vous conviendra. *N.b.* — il vous faudra aussi adapter le nom de votre moteur LuaLaTeX (`lualatex`, `lualatex.exe` ou autre).

## Licence et attributions 

Cet outil est distribué avec la licence [GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3.0.html) par ses auteurs :

- Alexandros Rispo Constantinou et Mathias Blaise

Une [page GitHub pour cet outil](https://github.com/tytyvillus/laboratoire-didactique) sera bientôt aussi disponible.

