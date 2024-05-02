# Guide de démarrage rapide

##  « Je ne gère pas l'informatique » : version en ligne

Si vous voulez rapidement accéder au projet sans trop avoir à mettre les mains à la pâte, vous pouvez accéder à une [version en ligne](https://www.overleaf.com/read/hmxjgqgkkmcq#9ccf30). Il faut en créer une copie. Pour cela, le plus simple est de vous créer un compte sur Overleaf, d’ouvrir le lien ci-dessus puis de créer une copie du projet en cliquant sur le bouton « copie » :

![Bouton « copie » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/copier-d-overleaf-oq.png)

- Assurez-vous, si le document refuse de compiler, que le compilateur soit bien sélectionné comme LuaLaTeX et non pas pdfTeX. Vous accéder à ce paramètre depuis le menu en haut à gauche d'Overleaf.

Vous pouvez aussi télécharger les fichiers et les compiler avec **une version à jour** de LaTeX sur votre ordinateur en choisissant LuaLaTeX :

![Bouton « téléchargement » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/telecharger-d-overleaf-oq.png)

Pour une présentation plus complète, vous êtes invité·e à lire la README, notamment la [section sur l'utilisation de l'outil](./README.md#utilisation-de-loutil).

***

## Personnalisation de l'outil

Deux aspects de l'outil sont modifiables : la fiche visible (`.tex`) et le code de génération des exercices (`.lua`). Le premier est particulièrement adapté à la modification par utilisat·eu·rice·s non techniques.

### Modifier les `.tex`

L'outil contient deux documents `.tex` : le fichier principal `main-systeme.tex` et son préambule `preamble-systeme.tex`.

#### Fichier principal

La plupart des modifications sont apportable dans le fichier  `main-systeme.tex`. En l'ouvrant (sur Overleaf, il suffit de cliquer dessus pour l'ouvrir), vous pourrez personnaliser les aspects suivants.

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

Si vous voulez refaire depuis le début la mise en page, sachez que le document minimal qui fonctionne encore selon le même modèle est le suivant. Tout le reste du `main-systeme.tex` est cosmétique. C'est à vous de voir ce que vous voulez retirer, ajouter ou retenir.

```tex
\documentclass[a4paper, 11pt]{article}
\input{preamble-quadratique.tex}

\begin{document}

	\foreach \n in {1,2,...,24}{\afullroutine{\n}} % prépare les questions/réponses

	\showallquestions % imprime la liste des questions

	\showallanswers % imprime la liste des réponses

\end{document}

```

##### Autres modifications

Si vous le souhaitez, vous pouvez modifier quelques réglages dans l'algorithme qui décide des polynômes et des méthodes pour les résoudre.  Ces réglages sont tous dans la section intitulée `(EDITABLE) PREAMBLE` du fichier `.lua`. En particulier, vous avez accès aux fonctionnalités suivantes :

- choisir la graine pour la générations de nombres pseudoaléatoires, en modifiant le paramètre de la fonction `math.randomseed()` — *si vous voulez pouvoir garder vos feuilles d'une fois à une autre, il vous faut fixer ce paramètre **avant** la compilation* ;

- déterminer la probabilité que le système généré soit singulier, en modifiant la variable `probability_singular` ;
