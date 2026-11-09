# Boîtes modulaires empilables — tubes carton de bobines Bambu Lab

Des boîtes de rangement fabriquées à partir des **tubes carton** récupérés sur les bobines Bambu Lab vides.
On imprime seulement les bords (fond, bague, couvercle) : le tube carton forme la paroi de la boîte.

- Les boîtes **s'empilent et se verrouillent** entre elles d'un quart de tour.
- On peut joindre **deux tubes** pour faire une boîte double.
- Toutes les boîtes s'empilent entre elles, simples ou doubles.

![Boîte simple, boîte double, simple sur double](dessin_boites_simple_double_empilees.png)

---

## Fichiers

| Fichier | Contenu |
|---|---|
| `Boite_L_P1S_PLA_Matte_un_plateau.3mf` | Projet Bambu Studio prêt à imprimer : les 4 pièces taille L sur un plateau (P1S, buse 0.4, Bambu PLA Matte) |
| `boites_modulaires_L.scad` | Source OpenSCAD paramétrique (tailles M et L, jeux, serrage…) |
| `dessin_boites_simple_double_empilees.png` | Vue assemblée et éclatée des montages |
| `fond_coupe.png` | Coupe du fond expliquée |
| `stl/` | Les 4 pièces en STL (fond, bague, couvercle, manchon — taille L) |
| `outils/` | Script qui régénère le projet Bambu Studio à partir des STL, avec les profils P1S / PLA Matte |
| `CLAUDE.md` | Notes pour reprendre le projet avec Claude |

---

## Les pièces

| Pièce | Couleur sur les dessins | Rôle | Hauteur |
|---|---|---|---|
| **Fond L** | orange | En bas de la boîte. Pied à 3 ergots dessous (verrou quart de tour) + rainure qui reçoit le carton. | 17,2 mm |
| **Bague L** | bleu | En haut du tube. Reçoit le couvercle vissé. | 13,0 mm |
| **Couvercle** | vert | Se visse sur la bague. Son rebord à encoches reçoit le fond de la boîte du dessus. | 15,4 mm |
| **Manchon L** *(option)* | violet | Relie deux tubes bout à bout pour une boîte double. | 13,6 mm |

Toutes les pièces font **Ø 93,6 mm** à l'extérieur.

**Repère simple :** l'orange (fond) est toujours **en bas** d'une boîte, le vert (couvercle) toujours **en haut**.
Le fond a des petites dents dessous, le couvercle a un bord cranté.

---

## Montages

### Boîte simple — 3 pièces + 1 tube
```
Couvercle   (vissé)
Bague L
Tube carton
Fond L
```

### Boîte double — 4 pièces + 2 tubes
```
Couvercle   (vissé)
Bague L
Tube carton
Manchon L
Tube carton
Fond L
```
Les deux tubes d'une boîte double doivent être de la **même taille** (M ou L).

### Empiler deux boîtes
Pose la boîte du dessus de façon à ce que les **3 ergots de son fond** tombent dans les **3 encoches du couvercle** du dessous.
Tourne-la ensuite **dans le sens des aiguilles d'une montre** (≈ 30°) jusqu'à la butée : elle est verrouillée.
Pour la retirer, tourne-la en sens inverse et soulève.

- Le verrouillage ne fonctionne **que dans un sens** : une butée anti-retour empêche de tourner dans l'autre.
- En fin de course, une rampe sous la lèvre du couvercle **plaque** les deux boîtes l'une contre l'autre, pour supprimer le jeu.
- Pour ouvrir la boîte du dessous, dévisse **toute la pile du dessus** avec son couvercle, en tenant la boîte du bas par sa bague.

### Hauteurs (tube de hauteur *h*)

| Montage | Hauteur totale |
|---|---|
| Boîte simple | h + 28 mm |
| Boîte double | 2h + 30 mm |
| Chaque boîte simple ajoutée sur une pile | + h + 22 mm |

---

## Tailles de tubes Bambu Lab

Bambu Lab utilise **plusieurs tailles de tubes carton**. Plages relevées par la communauté
(source : l'auteur du modèle *Bambu spool container* sur MakerWorld) :

| Taille | Ø extérieur | Ø intérieur |
|---|---|---|
| M | 86,4 – 87,7 mm | 82,2 – 83,0 mm |
| M épais | 86,9 – 88,5 mm | 82,2 – 83,0 mm |
| L | 88,5 – 89,4 mm | 82,9 – 84,0 mm |

Rainures prévues dans ce projet :

| Taille de rainure | Paroi intérieure | Nervures | Paroi extérieure | Tubes acceptés |
|---|---|---|---|---|
| **L** *(par défaut)* | Ø 82,5 | Ø 88,9 | Ø 89,9 | tous les tubes testés (M, M épais et L) |
| M | Ø 82,2 | Ø 88,0 | Ø 88,8 | M et M épais seulement |

**Taille L recommandée** : elle a accepté tous les tubes testés.
Les nervures sont rigides : un gros tube L est bien serré, alors qu'un petit tube M garde un peu de jeu.
Comme le fond et la bague restent montés pour de bon, une **goutte de colle** (colle chaude ou vinylique) règle le problème sur les tubes qui flottent.

Seules la rainure du fond, de la bague et du manchon dépendent de la taille.
L'extérieur, le filetage et le verrou sont identiques : **le couvercle est le même pour toutes les tailles**, et toutes les boîtes s'empilent entre elles.

---

## Impression

| Réglage | Valeur |
|---|---|
| Imprimante | Bambu Lab P1S, buse 0.4 |
| Profil | 0.20mm Standard @BBL X1C |
| Filament | Bambu PLA Matte |
| Plaque | Textured PEI |
| Supports | **Aucun** |
| Orientation | Celle du fichier, ne pas retourner les pièces |

- **Fond** : pied et ergots sur le plateau, rainure vers le haut.
- **Couvercle** : disque sur le plateau, rebord vers le haut.
- **Bague et manchon** : rainure côté plateau.

Dans Bambu Studio : *Fichier → Ouvrir un projet*.
Si un réglage ne se charge pas, choisis *Importer la géométrie uniquement* et sélectionne les profils ci-dessus à la main.
Si tu n'as pas besoin du manchon, supprime-le du plateau avant de lancer l'impression.

---

## Caractéristiques techniques

| Élément | Valeur |
|---|---|
| Emboîtement du carton | 6 mm, 12 nervures anti-rotation |
| Filetage bague / couvercle | filet rond, pas 4 mm, profondeur 1,6 mm, longueur 6 mm, jeu 0,35 mm |
| Verrou entre boîtes | 3 ergots, rotation 30° sens horaire, butée de fin + butée anti-retour |
| Jeu du pied dans le rebord | 0,2 mm (radial) |
| Jeu vertical des ergots | 0,2 mm, rattrapé par la rampe en fin de course |
| Serrage en fin de rotation | 0,05 mm |

---

## Personnaliser (OpenSCAD)

Ouvre `boites_modulaires_L.scad` dans [OpenSCAD](https://openscad.org), puis *Fenêtre → Customizer*.

| Paramètre | Rôle | Conseil |
|---|---|---|
| `piece` | pièce à générer (`fond_integre`, `bague`, `couvercle`, `manchon`, `test`…) | exporter chaque pièce en STL |
| `taille` | `L` ou `M` | `L` par défaut |
| `jeu_filet` | jeu du filetage | ↑ 0,45 si le vissage force |
| `serrage_verrou` | serrage en fin de quart de tour | ↑ 0,10–0,15 s'il reste du jeu, ↓ 0 si trop dur |
| `jeu_empilage` | jeu du pied dans le rebord | ↑ 0,3 si la boîte du dessus rentre mal |
| `jeu_vertical` | jeu des ergots sous la lèvre | — |
| `nervures` | nervures dans la rainure | `true` |

La pièce `test` est une simple rainure de 7 mm de haut, avec la lettre de la taille en relief : pratique pour tester un tube en quelques minutes.

---

## État des vérifications

**Vérifié en simulation** sur le modèle 3D :
- le couvercle se visse à fond dans la bague sans collision ;
- le verrou :
  - posé, la boîte entre sans contact ;
  - dans le mauvais sens, elle est bloquée ;
  - à 15°, elle tourne librement ;
  - à 30°, le serrage léger est en place ;
  - au-delà, la butée la bloque ;
  - verrouillée, elle ne peut plus être soulevée ;
- toutes les pièces sont des volumes fermés (maillages étanches).

**Testé en vrai :**
- rainure M : 6 tubes sur 13 rentrent ;
- rainure L : tous les tubes rentrent.

**Pas encore testé en vrai :** le verrou quart de tour avec rampe et le fond en une pièce.
Les jeux (0,2 à 0,35 mm) sont des valeurs classiques pour une P1S en PLA, mais le PLA Matte peut serrer un peu plus.
Imprime d'abord une boîte avant de lancer une série.

---

## Historique

1. Bague universelle vissée aux deux bouts du tube, avec fond et couvercle vissés.
2. Le couvercle reçoit le fond de la boîte du dessus pour l'empilage.
3. Ajout du verrou quart de tour entre les piles.
4. Jointures vissées remplacées par un **manchon** sans filetage.
5. Recalage sur les vrais tubes Bambu : Ø 88 / 83 au lieu de 100. Bague abaissée à 13 mm.
6. Ajout de la **taille L**, pour les tubes plus gros.
7. **Fond en une pièce**, à la place de fond + bague : 3 pièces par boîte au lieu de 4.
8. Verrou **dans un seul sens**, avec butée anti-retour et **rampe de serrage** pour supprimer le jeu.
