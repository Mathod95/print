# CLAUDE.md — Boîtes modulaires (tubes carton Bambu Lab)

Contexte pour reprendre ce projet dans une nouvelle session. Le README.md décrit le projet pour un humain ; ce fichier dit **comment travailler dessus**.

## L'utilisateur
- Parle **français**, écrit vite et en langage parlé. Répondre en français, court et concret.
- Imprimante : **Bambu Lab P1S, buse 0.4**. Filament : **Bambu PLA Matte**. Plaque Textured PEI. Logiciel : Bambu Studio.
- **N'a pas d'outil de mesure** (pas de pied à coulisse). Pour une cote, la déduire de fichiers qu'il fournit (STL/3MF d'autres modèles), de photos, ou de la méthode de la bande de papier (circonférence ÷ π).
- Veut des **livrables prêts à imprimer** : un seul `.3mf` Bambu Studio, pièces **réparties proprement par plateau**, réglages P1S / PLA Matte inclus.
- Choisit souvent « tout sur un seul plateau » quand ça tient.

## Décisions prises (ne pas revenir dessus sans qu'il le demande)
- **Taille L uniquement** : la rainure L accepte tous ses tubes (M, M épais et L). La taille M existe dans le .scad mais n'est plus livrée.
- **3 pièces par boîte** : fond en une pièce (`fond_integre`) + bague (haut) + couvercle. **Manchon** en option pour une boîte double. Les jointures vissées et la jointure fermée ont été **abandonnées**.
- **Sens d'empilage** : les **ergots sont sous le FOND**, le **COUVERCLE reçoit** (rebord à encoches). L'utilisateur a déjà confondu fond et couvercle : toujours les décrire clairement (fond = orange, en bas, dents dessous ; couvercle = vert, en haut, bord cranté).
- **Verrou quart de tour dans un seul sens** (horaire, 30°), avec butée anti-retour et rampe de serrage sous la lèvre.
- **Pas de flèche en relief** sur le couvercle (retirée à sa demande).
- **Pas de lamelles souples** pour serrer le carton : nervures rigides, et colle si un tube flotte.

## Erreurs à ne pas refaire
- **Ne jamais supposer une cote de tube.** La v1 était dessinée pour Ø 100 mm (valeur inventée) ; ses tubes font ~Ø 88 / 83. Ça a coûté un tirage complet.
- Annoncer clairement ce qui est **vérifié en simulation**, ce qui est **déduit**, et ce qui est **testé en vrai**. Il demande « tu es sûr ? ».
- Les tubes Bambu existent en **plusieurs tailles** : M (Ø ext 86,4–87,7 / int 82,2–83,0), M épais (86,9–88,5 / 82,2–83,0), L (88,5–89,4 / 82,9–84,0).

## Fichiers
- `boites_modulaires_L.scad` : **source unique**, paramétrique. Pièces via `-D piece="…"` : `fond_integre`, `bague`, `couvercle`, `manchon`, `test` (et anciennes : `fond` vissé, `assemblage`, `eclate`, `coupe`). Taille via `-D taille="L"` (défaut) ou `"M"`.
- `stl/` : les 4 STL de la version actuelle.
- `Boite_L_P1S_PLA_Matte_un_plateau.3mf` : projet Bambu Studio livré (1 plateau, 4 pièces).
- `outils/make_bambu_project.py` : génère le projet Bambu Studio à partir des STL (liste `parts` + `PLATES` en haut du script).
- `outils/resolve.py` + `outils/profils/` : profils Bambu officiels résolus (héritages + includes) pour P1S 0.4 / 0.20mm Standard @BBL X1C / Bambu PLA Matte @BBL P1S 0.4 nozzle, tag BambuStudio `v02.08.04.61`.

## Géométrie clé (dans le .scad)
- Extérieur de toutes les pièces : `R2` = 46,8 (Ø 93,6). **Ne pas changer** : filetage, verrou et compatibilité entre boîtes en dépendent.
- Rainure (`canal_tube`) : seule partie qui dépend de `taille` (`Rs`, `r3t`, `rib_c`). L : parois Ø 82,5 / 89,9, nervures Ø 88,9. M : Ø 82,2 / 88,8, nervures Ø 88,0.
- Emboîtement du carton `profondeur` = 6 mm. Bague `Hb` = 13 mm. Fond 17,2 mm. Couvercle 15,4 mm. Manchon 13,6 mm.
- Filetage : rond, `pas` 4, `excentrique` 0,8, `longueur_filet` 6, `jeu_filet` 0,35.
- Verrou : `ergots` 3, `course` 30°, `jeu_empilage` 0,2, `jeu_vertical` 0,2, `serrage_verrou` 0,05 (réglage à ajuster après essai réel).
- Hauteur d'une boîte simple ≈ tube + 28 mm ; boîte double ≈ 2 tubes + 30 mm ; pas d'empilage ≈ tube + 22 mm.

## Comment vérifier une modification
- Exporter : `openscad -o x.stl -D 'piece="couvercle"' boites_modulaires_L.scad`. Vérifier `is_watertight` avec trimesh.
- **Collisions** : `intersection(){ pièce A ; translate/rotate pièce B }` exporté en STL → vide = pas de contact. Pour le verrou, tester les positions : posé 0°, mauvais sens +5°, 15°, 30° (léger serrage attendu), 35° (butée), verrouillé + soulevé 0,6 mm (doit bloquer). Positionnement : `translate([0,0,Lm+h_coll+dz]) rotate(a) fond_integre()` sur `couvercle()`.
- Filetage : bague + couvercle à `translate([0,0,Hb-Lm]) rotate(a)` ; balayer `a` par pas de 30°, au moins un angle doit donner une intersection vide.
- Avec 2 cœurs, chaque test prend 1 à 5 min (`$fn=48–64`).
- **Rendus** : `xvfb-run -a openscad -o img.png …` ; pour un .scad qui fait `include` du fichier principal, passer `-D 'piece="aucun"'` sinon l'assemblage par défaut s'affiche aussi.

## Générer le projet Bambu Studio
`cd outils && python3 make_bambu_project.py ../Sortie.3mf`
- Format projet Bambu : objets en `3D/Objects/object_N.model` + composants, `Metadata/model_settings.config` (objets, plateaux `plater_id`/`plater_name`, `model_instance`), `Metadata/project_settings.config` (JSON).
- Les options « par variante d'extrudeur » sont **réduites à la variante 0** (« Direct Drive Standard ») ; listes dans `profils/variant_sets.json`.
- Plateaux sur 2 colonnes, décalage 256 × 1,2 = 307,2 mm (colonne → +X, rangée → −Y).
- Zones à éviter sur P1S : **zone interdite** X 0–18 / Y 0–28, et **ligne de purge** le long de l'avant (Y ≈ 1–2, X 18–240, plus un retour en X ≈ 240 jusqu'à Y ≈ 11). Garder les pièces à Y ≥ 4.
- 4 pièces de Ø 93,6 tiennent largement sur un plateau (grille 2×2, centres 72 / 186). 6 pièces tiennent mais à ~1,6 mm d'écart.
- Le fichier n'a **jamais été ouvert dans Bambu Studio** depuis cet environnement. Si l'utilisateur signale un souci d'ouverture : « Importer la géométrie uniquement » puis choisir les 3 profils.

## Pistes ouvertes
- Ajuster `serrage_verrou` après le premier essai réel du verrou (jeu restant → 0,10–0,15 ; trop dur → 0).
- Manchon mixte M/L si un jour il mélange des tailles dans une boîte double.
- Projet parallèle évoqué : **rail pour boîtes IKEA SAMLA sous un banc** (22 l et 45 l, ancien modèle, glissement sur 39 cm, rails en L aux bouts + rail en T au milieu). En attente des cotes du rebord (débord, épaisseur, pattes de coin).
