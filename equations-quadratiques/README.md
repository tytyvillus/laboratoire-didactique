À FAIRE: LICENCE, ATTRIBUTIONS, LUALATEX


# Outil : résoudre efficacement une équation de second degré

Le présent outil est conçu pour permettre à des élèves d'entraîner la résolution d'équations de deuxième degré $a x^2 + b x + c = 0$ en utilisant la méthode la plus appropriée, en reconnaîssant les suivants cas :

- quand $b = 0$, on peut résoudre par réarrangement $x^2 = - c/a$ ;

- quand $c = 0$, on peut factoriser $ax$ pour avoir $a x (b/a * x + c/a) = 0$ ;

- si c'est un carré parfait, utiliser les identités remarquables $(A \pm B)^2$ pour factoriser ;

- si les nombres sont petits, factoriser par trinôme ;

- et sinon, utiliser la formule de Viète.

Certains cas spéciaux sont aussi inclus : l'équation de premier degré, ou de type $0 = 1$, ou $0 = 0$ ; ceux-ci apparaissent avec une faible probabilité.

Ce projet entre dans le contexte d'entraîner la compétence de base « utiliser avec souplesse l'outillage mathématique » donné dans l'*Annexe au plan d'études cadre du 9 juin 1994 pour les écoles de maturité : Compétences de base en mathématiques et en langue première constitutives de l'aptitude générale aux études supérieures, du 17 mars 2016*.


## Structure de la ressource

La ressource se présente comme quatre fichiers dans une archive `.zip` : la README, un fichier `codeQuadratique.lua`, un fichier `main-quadratique.tex` et un fichier `preamble-quadratique.tex`.  

- Le `*.lua` contient la majorité de l'algorithme servant à produire les questions.

- Le `preamble-*.tex` enclenche un petit nombre de paquets, librement distribués dans TEXLive, MikTEX ou sur www.ctan.org.  Ceux-ci comprennent `luacode` (automatique avec LuaLaTeX) et `luacas`, utilisé pour simplifier algébriquement certaines des équations-réponses. Dans le préambule, plusieurs commandes sont définies qui se réfèrent au `*.lua`.

- Le `main-*.tex` enclenche le préambule puis se charge de la mise en page du document.

## Utilisation de la ressource

La ressource est conçue pour que, après avoir décompressé l'archive `.zip`, il suffise d'ouvrir le fichier `main-*.pdf` et de le compiler pour obtenir une fiche complète et utilisable.  C'est une ressource « prête à l'emploi » (« *plug and play* »).

...

Quelques commandes additionnelles sont également proposées pour une mise en page alternative:

- `\aprintqna`: imprime l'équation sur une ligne, suivie de la réponse.

- `\amakequestion`: à utiliser en mode mathématique (*mathmode*), génère une équation à résoudre.

- `\amakeanswer`: à utiliser en mode texte, donne la solution recommandée à la dernière équation générée par 

Les deux dernières sont plus modulables, pouvant être utilisées pour placer l'équation et la réponse plus librement, par exemple au sein d'une plus grande feuille de travail avec d'autres types de questions.


## Licence et attributions 

Cet outil est distribué avec la licence [GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3.0.html) par ses auteurs:

- Alexandros Rispo Constantinou

