// ==========================================================
//  Boîtes modulaires vissées à partir des tubes carton de bobines
//  UNE bague universelle (taraudée) à chaque bout de tube,
//  et tout le reste se visse dedans :
//    - fond          : pied à ergots qui se verrouille (quart de tour) sur le couvercle d'une autre pile
//    - couvercle     : encastré sous un rebord à encoches qui reçoit la pile du dessus
//    - manchon       : (option) relie deux tubes bout à bout pour une double box
//  Les piles se posent et se verrouillent entre elles d'un quart de tour.
//  Ouvrir dans OpenSCAD > Fenêtre > Customizer pour régler.
// ==========================================================

/* [Pièce à générer] */
piece = "assemblage"; // [assemblage, eclate, coupe, test, bague, fond, fond_integre, couvercle, manchon]

/* [Tube carton (à mesurer !)] */
// Diamètre extérieur du tube (bobine carton Bambu Lab ≈ 88)
diam_tube = 88;
// Épaisseur de la paroi carton
epaisseur_tube = 2.5;
// Hauteur du tube (sert seulement à l'aperçu)
hauteur_tube = 60;

/* [Taille du tube Bambu Lab] */
// M : Ø ext 86,4-88,5 / Ø int 82,2-83,0 (M et M épais)  -  L : Ø ext 88,5-89,4 / Ø int 82,9-84,0
taille = "L"; // [M, L]

/* [Emboîtement du tube] */
profondeur = 6;
// Jeu radial de chaque côté du carton
jeu_tube = 0.4;
// Petites nervures qui mordent le carton (anti-rotation)
nervures = true;

/* [Filetage] */
// Pas du filet (mm par tour)
pas = 4;
// Profondeur du filet = 2 x excentrique
excentrique = 0.8;
// Longueur filetée
longueur_filet = 6;
// Jeu du filetage (0.3 serré, 0.5 facile)
jeu_filet = 0.35;

/* [Empilage et verrouillage entre piles] */
// Jeu entre le pied du fond et le rebord du couvercle
jeu_empilage = 0.2;
// Jeu vertical des ergots sous la lèvre
jeu_vertical = 0.2;
// Serrage en fin de rotation (rampe sous la lèvre) : 0 = juste en contact
serrage_verrou = 0.05;
// Nombre d'ergots du quart de tour
ergots = 3; // [2:6]
// Rotation pour verrouiller (degrés)
course = 30;
// Largeur angulaire des ergots / des encoches
a_erg = 22;
a_enc = 26;

/* [Hidden] */
$fn = 128;
e   = excentrique;
c   = jeu_tube;
R1  = diam_tube / 2 + c;                  // intérieur paroi ext. du canal
R2  = R1 + 2.4;                            // extérieur de toutes les pièces
r3  = diam_tube / 2 - epaisseur_tube - c;  // extérieur paroi int. du canal
r4  = r3 - 1.6;                            // passage intérieur
rm  = R1 - e - jeu_filet;                  // rayon du cercle générateur du filet mâle
// rainure selon la taille de tube (l'extérieur et le filetage ne changent pas)
Rs    = taille == "L" ? 89.9 / 2 : R1;       // paroi extérieure de la rainure
r3t   = taille == "L" ? 82.5 / 2 : r3;       // paroi intérieure de la rainure
rib_c = taille == "L" ? Rs + 0.1 : R1 + 0.2; // centre des nervures
plafond = 1.0;
Lf  = longueur_filet;                      // longueur taraudage (bague)
Lm  = Lf - 0.5;                            // longueur filet mâle
Hb  = profondeur + plafond + Lf;           // hauteur de la bague
h_coll = 4;                                // collerette moletée
cham = 1.0;                                // chanfrein d'entrée

// ---------- outils ----------
module anneau(ro, ri, h) {
    difference() { cylinder(r = ro, h = h); translate([0, 0, -1]) cylinder(r = ri, h = h + 2); }
}
// filet rond : cercle excentré extrudé en hélice (pas à droite)
module filet(r, h) {
    linear_extrude(height = h, twist = -360 * h / pas, slices = ceil(h / pas * 60), convexity = 6)
        translate([e, 0]) circle(r = r, $fn = 96);
}
module male(h, bore) {
    difference() {
        intersection() {
            filet(rm, h);
            union() {   // pointe chanfreinée pour engager facilement
                cylinder(r = R2, h = h - 1.2);
                translate([0, 0, h - 1.2]) cylinder(r1 = rm + e, r2 = rm - e - 0.2, h = 1.2);
            }
        }
        translate([0, 0, -1]) cylinder(r = bore, h = h + 2);
    }
}
module moletage(h) {
    for (i = [0 : 59]) rotate(i * 6) translate([R2 + 0.3, 0, -1]) cylinder(r = 1.1, h = h + 2, $fn = 12);
}
// collerette : dessous chanfreiné (imprimable), dessus plat
module collerette(ri) {
    difference() {
        union() {
            cylinder(r1 = rm + e, r2 = R1 + cham, h = R1 + cham - rm - e);
            translate([0, 0, R1 + cham - rm - e]) cylinder(r = R2, h = h_coll - (R1 + cham - rm - e));
        }
        translate([0, 0, -1]) cylinder(r = ri, h = h_coll + 2);
        moletage(h_coll);
    }
}

// ---------- Rainure qui reçoit le carton ----------
module canal_tube(h) {
    anneau(R2, Rs, h);
    anneau(r3t, r4, h);
    if (nervures) for (k = [0 : 11]) rotate(k * 30 + 15)
        translate([rib_c, 0, 0]) cylinder(r = 0.6, h = h, $fn = 12);
}

// ---------- Bague universelle ----------
// z = 0 : côté tube ; le taraudage s'ouvre vers le haut
module bague() {
    // canal du tube
    canal_tube(profondeur);
    // plafond = butée des pièces vissées
    translate([0, 0, profondeur - 0.01]) anneau(R2, r4, plafond + 0.02);
    // taraudage
    translate([0, 0, profondeur + plafond]) difference() {
        translate([0, 0, -0.01]) cylinder(r = R2, h = Lf + 0.01);
        translate([0, 0, -0.01]) filet(rm + jeu_filet, Lf + 0.02);
        translate([0, 0, Lf - cham]) cylinder(r1 = R1, r2 = R1 + cham + 0.01, h = cham + 0.01);
        moletage(Lf);
    }
}

// ---------- Verrouillage quart de tour entre piles ----------
// Le pied du fond porte des ergots ; le rebord du couvercle a une lèvre
// à encoches. On pose, on tourne dans le sens horaire, c'est verrouillé.
Rg    = R2 - 1.4;                    // fond de gorge du rebord
r_pied = R2 - 4;                     // rayon du pied
Rl    = r_pied + jeu_empilage;       // bord intérieur de la lèvre
t_erg = 2.5;                         // épaisseur des ergots
h_g   = t_erg + jeu_vertical;         // hauteur de la gorge
h_rebord = h_g + (Rg - Rl) + 0.8;    // hauteur du rebord
h_pied = h_rebord + 0.5;
h_fond = h_pied + (R2 - r_pied) + 0.8;

module part_angulaire(ro, ri, h, a0, a1) {
    intersection() {
        anneau(ro, ri, h);
        linear_extrude(h) polygon(concat([[0, 0]],
            [for (k = [0 : 12]) 3 * ro * [cos(a0 + (a1 - a0) * k / 12), sin(a0 + (a1 - a0) * k / 12)]]));
    }
}

// ---------- Fond ----------
// S'imprime pied sur le plateau (ergots posés sur le plateau, dessus à 45°).
module fond() {
    b = rm - e - 2;
    cylinder(r = r_pied, h = 1.6);   // plancher
    difference() {
        union() {
            cylinder(r = r_pied, h = h_pied);
            translate([0, 0, h_pied]) cylinder(r1 = r_pied, r2 = R2, h = R2 - r_pied);
            translate([0, 0, h_pied + R2 - r_pied]) cylinder(r = R2, h = 0.8);
        }
        translate([0, 0, 1.6]) cylinder(r = b, h = h_fond);
        translate([0, 0, h_pied]) moletage(h_fond);
    }
    // ergots du quart de tour
    for (k = [0 : ergots - 1]) rotate(k * 360 / ergots - a_erg / 2)
        rotate_extrude(angle = a_erg, $fn = 128) polygon([
            [r_pied - 0.5, 0], [Rg - jeu_empilage, 0], [Rg - jeu_empilage, t_erg],
            [r_pied - 0.5, t_erg + (Rg - jeu_empilage) - (r_pied - 0.5)]]);
    translate([0, 0, h_fond - 0.01]) male(Lm + 0.01, b);
}

// ---------- Fond en une pièce ----------
// Pied à ergots (quart de tour) + plancher + rainure qui reçoit le carton.
// Remplace fond + bague du bas. S'imprime pied sur le plateau.
module fond_integre() {
    cylinder(r = r_pied, h = 1.6);   // plancher
    difference() {
        union() {
            cylinder(r = r_pied, h = h_pied);
            translate([0, 0, h_pied]) cylinder(r1 = r_pied, r2 = R2, h = R2 - r_pied);
            translate([0, 0, h_pied + R2 - r_pied]) cylinder(r = R2, h = 0.8);
        }
        translate([0, 0, 1.6]) cylinder(r = r4, h = h_fond);
    }
    for (k = [0 : ergots - 1]) rotate(k * 360 / ergots - a_erg / 2)
        rotate_extrude(angle = a_erg, $fn = 128) polygon([
            [r_pied - 0.5, 0], [Rg - jeu_empilage, 0], [Rg - jeu_empilage, t_erg],
            [r_pied - 0.5, t_erg + (Rg - jeu_empilage) - (r_pied - 0.5)]]);
    translate([0, 0, h_fond - 0.01]) canal_tube(profondeur + 0.01);
}

// ---------- Couvercle ----------
// S'imprime tel quel : disque sur le plateau, rebord vers le haut.
module couvercle() {
    b  = rm - e - 1.6;
    zt = h_coll + h_rebord;
    cylinder(r = rm - e - 0.4, h = 1.6);                          // disque
    translate([0, 0, Lm + 0.01]) rotate([180, 0, 0]) male(Lm + 0.01, b);
    translate([0, 0, Lm]) {
        difference() {
            rotate_extrude($fn = 128) polygon([
                [b, 0], [rm + e, 0], [R1 + cham, R1 + cham - rm - e], [R2, R1 + cham - rm - e],
                [R2, zt], [Rl + 0.6, zt], [Rl, zt - 0.6],
                [Rl, h_coll + h_g + (Rg - Rl)], [Rg, h_coll + h_g], [Rg, h_coll], [b, h_coll]]);
            moletage(zt);
            // encoches de la lèvre
            for (k = [0 : ergots - 1]) {
                a = k * 360 / ergots;
                translate([0, 0, h_coll + h_g - 0.01])
                    part_angulaire(Rg + 0.01, Rl - 1, h_rebord, a - a_enc / 2, a + a_enc / 2);
            }
        }
        for (k = [0 : ergots - 1]) {
            a = k * 360 / ergots;
            s = a - course - a_erg / 2;
            // butée de fin de course (verrouillé)
            translate([0, 0, h_coll]) part_angulaire(Rg + 0.1, Rl + 0.2, h_g, s - 4.5, s - 0.5);
            // butée anti-retour : on ne peut tourner que dans le sens horaire
            translate([0, 0, h_coll]) part_angulaire(Rg + 0.1, Rl + 0.2, h_g, a + a_enc / 2 + 0.5, a + a_enc / 2 + 4.5);
            // rampe sous la lèvre : rattrape le jeu et plaque les boîtes en fin de course
            rampe(a + -a_enc / 2 - 1, s);
        }
    }
}

module rampe(phi0, phi1) {
    N  = 24;
    wm = (h_g - t_erg) + jeu_empilage + serrage_verrou;
    zA = h_coll + h_g + (Rg - Rl);
    zB = h_coll + h_g;
    st = (phi0 - phi1) / N;
    for (i = [0 : N - 1]) {
        w = wm * (i + 1) / N;
        rotate(phi0 - (i + 1) * st) rotate_extrude(angle = st + 0.05, $fn = 360)
            polygon([[Rl, zA - w], [Rg + 0.01, zB - w], [Rg + 0.01, zB + 0.01], [Rl, zA + 0.01]]);
    }
}

// flèche circulaire dans le sens horaire + mot FERMER
module fleche_fermer(r) {
    lw = 3;
    a0 = 150; a1 = 30;                       // l'arc va de 150° à 30° (sens horaire)
    for (i = [0 : 23]) hull() for (t = [i, i + 1]) {
        a = a0 - (a0 - a1) * t / 24;
        translate(r * [cos(a), sin(a)]) circle(d = lw, $fn = 16);
    }
    // pointe
    translate(r * [cos(a1), sin(a1)]) rotate(a1)
        polygon([[-4.5, 3.5], [4.5, 3.5], [0, -4.5]] + [[0, 0], [0, 0], [0, 0]]);
    text("FERMER", size = 6, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
}

// ---------- Manchon (double box) ----------
// Relie deux tubes bout à bout, sans filetage : les tubes s'enfoncent
// par le haut et par le bas. Un point de colle le rend définitif.
module manchon() {
    module canal_nervure() {
        canal_tube(profondeur);
    }
    canal_nervure();
    translate([0, 0, profondeur - 0.01]) anneau(R2, r4, 1.6 + 0.02);
    translate([0, 0, profondeur + 1.6]) canal_nervure();
}

// ---------- Bague de test ----------
// Juste la rainure : pour vérifier que le carton s'emboîte avant d'imprimer le reste.
module test_emboitement() {
    canal_tube(profondeur);
    translate([0, 0, profondeur - 0.01]) anneau(R2, r4, 1.0);
    // repère de taille en relief sur le dessus
    translate([0, 0, profondeur + 0.99]) linear_extrude(0.6)
        translate([0, (r4 + R2) / 2]) text(taille, size = 5, halign = "center", valign = "center",
                                           font = "Liberation Sans:style=Bold");
}

// ---------- Aperçus ----------
module tube(h) { color("Tan") anneau(diam_tube / 2, diam_tube / 2 - epaisseur_tube, h); }

// Un bloc = bague retournée + tube + bague. z0 = dessus de la collerette du dessous.
// renvoie (via la fonction) la cote du dessus de la bague haute
function haut_bloc(z0, ht) = z0 + ht - 2 * profondeur + 2 * Hb;
module bloc(z0, ht, col) {
    translate([0, 0, z0 + Hb]) rotate([180, 0, 0]) color(col) bague();
    translate([0, 0, z0 + Hb - profondeur]) tube(ht);
    translate([0, 0, z0 + Hb - 2 * profondeur + ht]) color(col) bague();
}
// pose un fond à la cote z (dessous du pied) ; renvoie le z0 du bloc
module fond_a(z, col) { translate([0, 0, z]) color(col) fond(); }
module couvercle_sur(z, col) { translate([0, 0, z - Lm]) color(col) couvercle(); }
module manchon_a(z, col) { translate([0, 0, z]) color(col) manchon(); }

// boîte complète posée à la cote z ; renvoie la cote d'appui pour la boîte suivante
function boite_dessus(z, ht, k) = haut_bloc(z + h_fond + k, ht) + k + h_coll;
module boite(z, ht, col, k = 0) {
    fond_a(z, col);
    bloc(z + h_fond + k, ht, col);
    couvercle_sur(haut_bloc(z + h_fond + k, ht) + k, col);
}

module assemblage(k = 0) {
    ht = hauteur_tube;
    d  = 2 * R2 + 30;
    // 1) boîte simple
    translate([-d, 0, 0]) boite(0, ht * 0.6, "DarkOrange", k);
    // 2) une boîte posée (pas vissée) sur une autre
    {
        boite(0, ht * 0.6, "MediumSeaGreen", k);
        boite(boite_dessus(0, ht * 0.6, k) + 2 * k, ht * 0.6, "Crimson", k);
    }
    // 3) double box (manchon) + une boîte posée dessus
    translate([d, 0, 0]) {
        fond_a(0, "Gold");
        translate([0, 0, h_fond + k + Hb]) rotate([180, 0, 0]) color("Gold") bague();
        zt1 = h_fond + k + Hb - profondeur;                 // bas du tube 1
        translate([0, 0, zt1]) tube(ht);
        manchon_a(zt1 + ht - profondeur + k, "MediumPurple");
        zt2 = zt1 + ht + 1.6 + 2 * k;                       // bas du tube 2
        translate([0, 0, zt2]) tube(ht);
        ztop = zt2 + ht - profondeur + k;
        translate([0, 0, ztop]) color("Gold") bague();
        couvercle_sur(ztop + Hb + k, "Gold");
        boite(ztop + Hb + 3 * k + h_coll, ht * 0.6, "Crimson", k);
    }
}

module coupe_empilage() {
    intersection() {
        union() {
            boite(0, 30, "MediumSeaGreen");
            boite(boite_dessus(0, 30, 0), 30, "Crimson");
        }
        translate([0, 0, -1]) cube([200, 200, 400]);
    }
}

// ---------- Sélection ----------
if (piece == "assemblage") assemblage(0);
else if (piece == "eclate") assemblage(15);
else if (piece == "coupe") coupe_empilage();
else if (piece == "bague") bague();
else if (piece == "fond") fond();
else if (piece == "fond_integre") fond_integre();
else if (piece == "couvercle") couvercle();
else if (piece == "manchon") manchon();
else if (piece == "test") test_emboitement();
