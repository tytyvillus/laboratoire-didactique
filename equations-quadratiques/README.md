# Démarrage rapide

Pour démarrer rapidement l'utilisation de cet outil sans vous soucier de tous les aboutissants de sa création, vous pouvez consulter le fichier [`QUICKSTART.md`](./QUICKSTART.md) ci-joint. Il contient également des conseils sur la modification facile de l'outil.

Si vous lisez ce document depuis un autre chose que la page GitHub, sachez qu'en suivant le lien [pour le dépôt du projet](https://github.com/tytyvillus/laboratoire-didactique) vous pouvez lire des versions de ce guide avec mise en page élégante et d'abord facile.

# Résoudre efficacement une équation de second degré

## Présentation 

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

L'outil se présente comme cinq fichiers dans une archive `.zip` : le QUICKSTART, la README, un fichier `codeQuadratique.lua`, un fichier `main-quadratique.tex` et un fichier `preamble-quadratique.tex`.  

- Le `*.lua` contient la majorité de l'algorithme servant à produire les questions.

- Le `preamble-*.tex` enclenche un petit nombre de paquets, librement distribués dans TEXLive, MikTEX ou sur www.ctan.org.  Ceux-ci comprennent `luacode` (automatique avec LuaLaTeX) et `luacas`, utilisé pour simplifier algébriquement certaines des équations-réponses. Dans le préambule, plusieurs commandes sont définies qui se réfèrent au `*.lua`.

- Le `main-*.tex` enclenche le préambule puis se charge de la mise en page du document.

## Utilisation de l'outil

### Démarrage rapide

L'outil est disposé afin que, après avoir décompressé l'archive `.zip`, il suffise d'ouvrir le fichier `main-*.pdf` dans votre éditeur TeX favori et de le compiler pour obtenir une fiche complète et utilisable.  C'est un outil « prêt à l'emploi » (« *plug and play* »). 

Il vous faut seulement vous assurer que vous ayez une distribution LaTeX à jour, et **compiler le document avec le moteur LuaLaTeX** (et non pdfLaTeX ou XeLaTeX). 

#### Version Overleaf

Une version en ligne est aussi mise à disposition si vous ne voulez pas devoir installer LaTeX localement. Le lien est [celui-ci](https://www.overleaf.com/read/tsmdmkhnrzjq#7569b4). Pour pouvoir modifier le document, il faudra vous créer une copie personnelle: le plus simple est de vous créer un compte sur Overleaf, ouvrir le lien donné puis de créer une copie du projet en cliquant sur le bouton « copie » :

![Bouton « copie » dans Overleaf, mis en évidence avec une grande flèche verte.](../images/copier-d-overleaf-oq.png)

Assurez-vous, si le document refuse de compiler, que le compilateur soit bien sélectionné comme LuaLaTeX et non pas pdfTeX. Vous accéder à ce paramètre depuis le menu en haut à gauche d'Overleaf.

### Modifier le document : mains à la pâte

#### Depuis le `.tex`

Le document `main-*.tex` consiste en une série de 24 exercices, mis en page algorithmiquement avec les commandes
```tex
\foreach \n in {1,2,...,24}{\afullroutine{\n}}
```
et `\showallquestions` et `\showallanswers`.

Quelques commandes additionnelles sont également proposées pour une mise en page alternative directement depuis `main-*.tex` :

- `\aprintqna` : imprime l'équation sur une ligne, suivie de la réponse.

- `\amakequestion` : à utiliser en mode mathématique (*mathmode*), génère une équation à résoudre.

- `\amakeanswer` : à utiliser en mode texte, donne la solution recommandée à la dernière équation générée par `\amakequestion`

Les deux dernières sont plus modulables, pouvant être utilisées pour placer l'équation et la réponse plus librement, par exemple au sein d'une plus grande feuille de travail avec d'autres types de questions.

#### Depuis le code `.lua`

Si vous le souhaitez, vous pouvez modifier quelques réglages dans l'algorithme qui décide des polynômes et des méthodes pour les résoudre.  Ces réglages sont tous dans la section intitulée `(EDITABLE) PREAMBLE` du fichier `.lua`. En particulier, vous avez accès aux fonctionnalités suivantes :

- choisir la graine pour la générations de nombres pseudoaléatoires, en modifiant le paramètre de la fonction `math.randomseed()` — *si vous voulez pouvoir garder vos feuilles d'une fois à une autre, il vous faut fixer ce paramètre **avant** la compilation* ;

- choisir la terminologie pour la formule de Viète (de base `formule = [[formule quad.\@]]`, que vous pouvez remplacer par `formule = [[formule de Viète]]` par exemple) ;

- déterminer la probabilité que les solutions d'un exercice donné soient des nombres entiers, en modifiant la fonction booléenne `whether_from_factored_form()` ;

- fixer, dans le cas de solutions entières, la proportion avec laquelle un carré parfait sera imposée, avec la fonction booléenne `enforce_perfect_square()` ;

- décider quels polynômes sont estimés faciles à factoriser par trinôme, en modifiant la fonction booléenne `easy_factor()` [pour utilisat·eu·rice·s avancé·e·s].

#### Accès à des fonctions additionnelles 

Pour les utilisat·eu·rice·s les plus téméraires, quelques dernières fonctions sont également fournies à LaTeX depuis le code Lua. C'est la dernière section du code `mainQuadratique.tex`, qui ressemble à ceci :

```lua
-- INTERFACE WITH LUALATEX ENGINE --

-- Export user-accessible functions (renamed using syntax `new = old`):
return { 
    polynomial = generate_polynomial, -- returns {a, b, c, num_sols, x1, x2, rat}
    methodString = pick_method, -- provides recommended method
    printEquation = cas_equation, -- question preprinted for LaTeX
    answer = answer_line, -- answer preprinted for LaTeX
    fullRoutine = full_routine, -- whole shebang
    printQnA = print_questions_and_answers, -- alternative, single-equation formatting style
}
```

Pour accéder à ces fonctions, il faut les appeler depuis un document `.tex`. C'est ce qui est déjà fait dans `preamble-*.tex` pour certaines de celles-ci, avec les commandes suivantes.

```tex
% Activer les fonctions dans le code / Load lua code:
\directlua{codeA = require "codeQuadratique"} 

% Convertir fonctions de code.lua en commandes LaTeX / Extract useful functions as LaTeX commands:
\newcommand{\afullroutine}[1]{\directlua{codeA.fullRoutine(#1)}} % format par défaut / default style

%[...]
```

La syntaxe de ces fonctions est documentée dans le fichier `mainQuadratique.lua` directement.

### Traitement par lot

Pour produire plusieurs feuilles différentes d'un coup, afin de pouvoir par exemple les distribuer individuellement à une classe de 20 élèves, nous n'avons malheureusement pas trouvé d'autre solution que d'appeler plusieurs fois le moteur LuaLaTeX depuis un programme externe. Par exemple, sur Linux, vous pouvez taper le code suivant dans Bash depuis le dossier contenant `main-*.tex` :

```bash
for i in {1..20}; do lualatex -jobname feuille-$i main-quadratique.tex; done
```
Il faudra cependant adapter ces commandes à la syntaxe particulière de votre système opératoire. Un autre exemple, pour Windows : ouvrez le dossier contenant `main-*.tex`, effectuez un clic-droit et sélectionner *Ouvrir dans le Terminal*. (Vérifiez que celui-ci soit bien la Windows PowerShell.) Dans le terminal, vous pouvez ensuite taper :
```powershell
for ($var = 1; $var -le 20; $var++) {lualatex.exe -jobname feuille-$var main-quadratique.tex}
```
Il vous faudra donc vous familiariser avec la variante qui vous conviendra. *N.b.* — il vous faudra aussi adapter le nom de votre moteur LuaLaTeX (`lualatex`, `lualatex.exe` ou autre).

### Intégration avec l'autre outil du même projet

Dans le cadre de ce laboratoire didactique, deux outils ont été créés : l'un sur les systèmes d'équations et l'autre sur les équations du second degré. Si vous voulez pouvoir combiner les deux types de questions dans un seul et même document, créez un dossier contenant les fichiers `codeQuadratique.lua` et `codeSysteme.lua`. Ensuite, créez un fichier `preamble.tex` et copiez-y le code suivant (n'oubliez pas de sauvegarder).

```tex
%!TeX root = main.tex

% --- PRÉAMBULE  --- 

% langue et police:
\usepackage[quiet]{fontspec}
\usepackage{polyglossia} \setmainlanguage[variant=swiss]{french}

% calculs internes:
\usepackage{luacas}

% maths:
\usepackage{amsmath} 
\usepackage{amssymb}
\usepackage[warnings-off={mathtools-colon,mathtools-overbracket}, math-style=ISO,]{unicode-math} 
\usepackage[locale = FR, round-precision = 3, round-mode = figures, round-pad = false,]{siunitx} 
% vvvvvvvvvvvvvvvvvvvvv
%	\newcommand{\num}[1]{#1}
%% 	^ à décommenter si vous voulez vous débarasser de ‹siunitx›
%% 	^ uncomment if you want to get rid of ‹siunitx›

% choix esthétiques, facultatifs:
\let\oldemptyset\emptyset
\let\emptyset\varnothing

% permettent mise en page:
\usepackage{multicol}
\usepackage{pgffor}

% date et heure
\usepackage[timesep=., showzone=false, hourminsep=h, minsecsep=m,]{datetime2} % permet les horodatages 


% ---- ANSWER-PRINTING STYLE FROM https://tex.stackexchange.com/a/15354 ----

% Define answer environment 

\newbox\allanswers
\setbox\allanswers=\vbox{}

\newenvironment{customanswer}
{\global\setbox\allanswers=\vbox\bgroup
	\unvbox\allanswers
	\vspace{-4pt}
}
{\bigbreak\egroup}

\newcommand{\showallanswers}{\par\unvbox\allanswers}

% Define question environment

\newbox\allquestions
\setbox\allquestions=\vbox{}

\newenvironment{customquestion}
{\global\setbox\allquestions=\vbox\bgroup
	\unvbox\allquestions
}
{\bigbreak\egroup}

\newcommand{\showallquestions}{\par\unvbox\allquestions}


%% ---------- PROVIDE \timestamp COMMAND -------------
% -- from https://flaterco.com/util/timestamp.sty --

\makeatletter

\newcount\@DT@modctr
\newcount\@dtctr

\def\@modulo#1#2{%
	\@DT@modctr=#1\relax
	\divide \@DT@modctr by #2\relax
	\multiply \@DT@modctr by #2\relax
	\advance #1 by -\@DT@modctr}

\newcommand{\xxivtime}{%
	\@dtctr=\time%
	\divide\@dtctr by 60
	\ifnum\@dtctr<10 0\fi\the\@dtctr.%
	\@dtctr=\time%
	\@modulo{\@dtctr}{60}%
	\ifnum\@dtctr<10 0\fi\the\@dtctr%
}

\newcommand{\timestamp}{\the\year-%
	\ifnum\month<10 0\fi\the\month-%
	\ifnum\day<10 0\fi\the\day\ \xxivtime}

\makeatother


% ---------------- ACCÈS AU CODE LUA: -----------------

% Aide-mémoire Lua: https://devhints.io/lua

%% OUTIL SECOND DEGRÉ

% Activer les fonctions dans le code:
% Load lua code:
\directlua{codeA = require "codeQuadratique"} 

% Pour le format par défaut:
\newcommand{\afullroutine}[1]{\directlua{codeA.fullRoutine(#1)}}

% Pour imprimer question immédiatement suivie de réponse:
\newcommand{\aprintqna}{\directlua{codeA.printQnA()}}

% Pour librement produire question, et séparément la réponse
\newcommand{\amakequestion}{% 
	% MUST BE INSERTED IN MATHMODE: \(\amakequestion\)
		\directlua{%
			polynomialcoeffs = codeA.polynomial()
			eqn = codeA.printEquation(table.unpack(polynomialcoeffs,1,3))
			tex.print(eqn)
		}
	}
\newcommand{\amakeanswer}{%
	% IN TEXTMODE
		\directlua{%
			tex.print(codeA.answer(table.unpack(polynomialcoeffs)))
		}
	}

%% OUTIL SYSTÈME D'ÉQUATIONS

% Activer les fonctions dans le code:
% Load lua code:
\directlua{codeB = require "codeSysteme"} 

% Pour le format par défaut:
\newcommand{\bfullroutine}[1]{\directlua{codeB.fullRoutine(#1)}}

% Pour imprimer question immédiatement suivie de réponse:
\newcommand{\bprintqna}{\directlua{codeB.printQnA()}}

% Pour librement produire question, et séparément la réponse
\newcommand{\bmakequestion}{% 
	% MUST BE INSERTED IN MATHMODE: \(\amakequestion\)
		\directlua{%
			coeffs, num_sols, x, y = codeB.polynomial(0.2)
			eqn = codeB.printEquation(coeffs)
			tex.print(eqn)
		}
	}
\newcommand{\bmakeanswer}{%
	% IN TEXTMODE
		\directlua{%
			tex.print(codeB.answer(coeffs, num_sols, x, y))
		}
	}

```

Une fois que c'est fait, vous pouvez créer un fichier `main.tex` (toujours dans le même dossier) et le remplir comme vous convient, tant que vous n'oubliez pas d'y inclure le préambule avec la commande `\input{preamble.tex}`. Une idée de base depuis laquelle travailler est la suivante.

```tex
\documentclass[a4paper, 11pt]{article}
\usepackage[margin=2cm]{geometry}
\input{preamble.tex}

\begin{document} \thispagestyle{empty}

	\foreach \n in {1,2,...,12}{\afullroutine{\n}} % prépare les questions/réponses
	\begin{multicols}{3} \showallquestions \end{multicols} % imprime la liste des questions
	~\medskip \showallanswers   % espace vertical, puis imprime la liste des réponses

	\medskip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	\hbox to \linewidth{\leaders\hbox to 4pt{\hss · \hss}\hfil} % séparation entre les parties

	\setbox\allanswers=\vbox{} 	% vider la boîte des réponses
	\setbox\allquestions=\vbox{}	% vider la boîte des questions

	\medskip %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	\foreach \n in {1,2,...,9}{\bfullroutine{\n}} % prépare les questions/réponses
	\begin{multicols}{3} \showallquestions \end{multicols} % imprime la liste des questions
	~\medskip \showallanswers   % espace vertical, puis imprime la liste des réponses

\end{document}
```

Un exemple de fiche créée suivant cette procédure est disponible [sur Overleaf](https://www.overleaf.com/read/wzdcckddkjzy#f3d012).

***

## Licence et attributions 

Cet outil est distribué avec la licence [GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3.0.html) par ses auteurs :

- Alexandros Rispo Constantinou

Une [page GitHub pour cet outil](https://github.com/tytyvillus/laboratoire-didactique) est également disponible.
