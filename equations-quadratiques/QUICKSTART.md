# Guide de démarrage rapide

##  « Je ne gère pas l'informatique » : version en ligne

Si vous voulez rapidement accéder au projet sans trop avoir à mettre les mains à la pâte, vous pouvez accéder à une [version en ligne](https://www.overleaf.com/read/tsmdmkhnrzjq#7569b4). Il faut en créer une copie. Pour cela, le plus simple est de vous créer un compte sur Overleaf, d’ouvrir le lien ci-dessus puis de créer une copie du projet en cliquant sur le bouton « copie » :

![Bouton « copie » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/copier-d-overleaf-oq.png)

- Assurez-vous, si le document refuse de compiler, que le compilateur soit bien sélectionné comme LuaLaTeX et non pas pdfTeX. Vous accéder à ce paramètre depuis le menu en haut à gauche d'Overleaf.

Vous pouvez aussi télécharger les fichiers et les compiler avec **une version à jour** de LaTeX sur votre ordinateur en choisissant LuaLaTeX :

![Bouton « téléchargement » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/telecharger-d-overleaf-oq.png)

Pour une présentation plus complète, vous êtes invité·e à lire la README, notamment la [section sur l'utilisation de l'outil](./README.md#utilisation-de-loutil).

***

## Personnalisation de l'outil

Deux aspects de l'outil sont modifiables : la fiche visible (`.tex`) et le code de génération des exercices (`.lua`). Le premier est particulièrement adapté à la modification par utilisat·eu·rice·s non techniques.

### Modifier les `.tex`

L'outil contient deux documents `.tex` : le fichier principal `main-quadratique.tex` et son préambule `preamble-quadratique.tex`.

#### Fichier principal

La plupart des modifications sont apportable dans le fichier  `main-quadratique.tex`. En l'ouvrant (sur Overleaf, il suffit de cliquer dessus pour l'ouvrir), vous pourrez personnaliser les aspects suivants.

##### Consigne 

Cherchez le bloc de texte suivant, et modifiez-y la consigne comme bon vous semble.

```tex
%%%%%%%%%%%%%%% CONSIGNE %%%%%%%%%%%%%%%%

{\small\em Résolvez ces équations en utilisant à chaque fois la méthode la plus rapide possible. (N'oubliez pas d'écrire l'équation sous la forme standard si elle ne l'est pas déjà.) Une fois toutes les équations résolues, vérifiez vos réponses dans le corrigé. Indiquez pour chaque question si vous avez utilisé la même méthode que le corrigé ou non. Vous n'avez pas droit à la calculatrice.}

```

##### Nombre de questions

Pour modifier le nombre de questions imprimées, cherchez le bloc suivant et remplacez `24` par le nombre qui vous arrange.

```tex
%%%%%%% GÉNÈRE LES QUESTIONS DANS UNE BOÎTE VIRTUELLE %%%%%%%

\raggedright
\foreach \n in {1,2,...,24}{\afullroutine{\n}}

```

##### Horodatages

Pour facilement pouvoir retrouver la fiche de réponses pour chaque fiche d'exercices, un horodatage (*timestamp* en anglais) a été fourni. Ceci peut-être utile dans le cas où les exercices sont séparés de leurs solutions en découpant le long des traits tillés.

Si cette fonctionnalité ne vous sert pas, effacez dans les deux sections intitulées `[...] HORODATAGE [...]` les caractères suivants (ni plus ni moins).

```tex
\\{\tiny\sffamily (générés le \DTMtoday\ à \DTMcurrenttime s)}
```

##### Refaire la mise en page 

Si vous voulez refaire depuis le début la mise en page, sachez que le document minimal qui fonctionne encore selon le même modèle est le suivant. Tout le reste du `main-quadratique.tex` est cosmétique. C'est à vous de voir ce que vous voulez retirer, ajouter ou retenir.

```tex
\documentclass[a4paper, 11pt]{article}
\input{preamble-quadratique.tex}

\begin{document}

	\foreach \n in {1,2,...,24}{\afullroutine{\n}} % prépare les questions/réponses

	\showallquestions % imprime la liste des questions

	\showallanswers % imprime la liste des réponses

\end{document}

```

##### Mises en page alternatives

Si vous voulez *vraiment* complètement refaire la mise en page, quelques commandes additionnelles vous sont fournies, à utiliser depuis le fichier `main-*.tex` :

- `\aprintqna` : imprime l'équation sur une ligne, suivie de la réponse.

- `\amakequestion` : à utiliser en mode mathématique (*mathmode*, c.-à-d. `$\amakequestion$`), génère une équation à résoudre.

- `\amakeanswer` : à utiliser en mode texte, donne la solution recommandée à la dernière équation générée par `\amakequestion`.

Les deux dernières sont plus modulables, pouvant être utilisées pour placer l'équation et la réponse plus librement, par exemple au sein d'une plus grande feuille de travail avec d'autres types de questions.

##### Autres modifications

Si vous le souhaitez, vous pouvez également modifier quelques réglages dans l'algorithme qui décide des polynômes et des méthodes pour les résoudre.  Ces réglages sont tous dans la section intitulée `(EDITABLE) PREAMBLE` du fichier `.lua`. En particulier, vous avez accès aux fonctionnalités suivantes :

- choisir la graine pour la générations de nombres pseudoaléatoires, en modifiant le paramètre de la fonction `math.randomseed()` — *si vous voulez pouvoir garder vos feuilles d'une fois à une autre, il vous faut fixer ce paramètre **avant** la compilation* ;

- choisir la terminologie pour la formule de Viète (de base `formule = [[formule quad.\@]]`, que vous pouvez remplacer par `formule = [[formule de Viète]]` par exemple) ;

- déterminer la probabilité que les solutions d'un exercice donné soient des nombres entiers, en modifiant la fonction booléenne `whether_from_factored_form()` ;

- fixer, dans le cas de solutions entières, la proportion avec laquelle un carré parfait sera imposée, avec la fonction booléenne `enforce_perfect_square()` ;

- décider quels polynômes sont estimés faciles à factoriser par trinôme, en modifiant la fonction booléenne `easy_factor()` [pour utilisat·eu·rice·s avancé·e·s].

***

## Plus d'informations

D'autres conseils et modes d'utilisation sont donnés dans la [README](./README.md), notamment pour le traitement par lots (génération automatique de plusieurs fiches d'un coup avec une version locale de LuaLaTeX). Il y a aussi une version combinant cet outil avec son jumeau sur les systèmes d'équations, disponible [sur Overleaf](https://www.overleaf.com/read/wzdcckddkjzy#f3d012). Pour son mode d'emploi, consulter la README.


