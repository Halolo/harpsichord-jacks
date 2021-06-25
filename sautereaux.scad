$fn = 250;

//L_mod_m2 = 11;
//L_mod_m3 = 43;

l = 12;
L_base = 136;
L = L_base - (is_undef(L_mod_m3) ? 0 : L_mod_m3);
e = 3.5;

l_bas = is_undef(L_mod_m3) ? 10.5 : 10;

l_extrude = l-l_bas;
L_top_base = 21;
L_top = L_top_base + (is_undef(L_mod_m2) ? 0 : L_mod_m2);
L_extrude = L - L_top;

l_logement = 5.5;
L_logement = 35.5;
L_logement_pos_base = 12;
L_logement_pos = L_logement_pos_base + (is_undef(L_mod_m2) ? 0 : L_mod_m2);

axe_pos_base = 104;
axe_pos = axe_pos_base - (is_undef(L_mod_m2) ? 0 : L_mod_m2) - (is_undef(L_mod_m3) ? 0 : L_mod_m3);

r_axe = e/4;
spacer = 0.35;
spacer_btm = spacer + 0.05;
h_cone = e/2-0.5;

bec_axe_pos = 9.75;
l_bec_base = 4.5;
l_bec_tip = 4;

module axe(offset=0) union() {
    translate([(l-l_extrude-l_logement)/2+spacer,axe_pos,e/2]) rotate([0,90,0]) cylinder(h_cone,h_cone+offset,r_axe+offset);
    translate([(l-l_extrude+l_logement)/2-h_cone-spacer,axe_pos,e/2]) rotate([0,90,0]) cylinder(h_cone,r_axe+offset,h_cone+offset);
    translate([0,axe_pos,e/2]) rotate([0,90,0]) cylinder(l-l_extrude,r_axe+offset,r_axe+offset);
}

module body() union() {
    l_languette = 0.85;
    L_languette = 18;

    L_languette_pos = L - L_top + 1.5;
    l_languette_pos = l - l_languette - 2;

    l_ressort = 0.7;
    L_ressort = 5;
    e_ressort = 2;

    r_vis_bec = 0.85 + 0.025;
 
    r_vis_base = 1 + 0.025;
    h_vis_base = 10;
 
    difference() {
        cube([l,L,e]);
        union() {
            translate([l-l_extrude,0,0]) cube([l_extrude,L_extrude,e]);
            translate([l_languette_pos,L_languette_pos,0]) cube([l_languette,L_languette,e]);
            translate([(l-l_extrude-l_logement)/2,L-L_logement-L_logement_pos,0]) cube([l_logement,L_logement,e]);
            translate([(l-l_extrude-l_ressort)/2,L-L_logement-L_logement_pos-L_ressort,e-e_ressort]) cube([l_ressort,L_ressort,e_ressort]);
            translate([(l-l_extrude)/2,L,e/2]) rotate([90,0,0]) cylinder(L_logement_pos,r_vis_bec,r_vis_bec);
            translate([(l-l_extrude)/2,0,e/2]) rotate([-90,0,0]) cylinder(h_vis_base,r_vis_base,r_vis_base);
        }
    }
    translate([(l-l_extrude-l_logement)/2,axe_pos-e/2,0]) cube([spacer,e,e]);
    translate([(l-l_extrude+l_logement)/2-spacer,axe_pos-e/2,0]) cube([spacer,e,e]);
    axe();

    translate([(l-l_extrude-l_logement)/2,axe_pos-8,e/2]) cylinder(e, spacer_btm, spacer_btm, center = true);
    translate([(l-l_extrude+l_logement)/2,axe_pos-8,e/2]) cylinder(e, spacer_btm, spacer_btm, center = true);
}

BecPoints = [
  [0, 0, 0], //0
  [12.5, 0, 0], //1
  [27, (l_bec_base-l_bec_tip)/2, 0], //2
  [30, (l_bec_base-l_bec_tip)/2, 0], //3
  [30, l_bec_tip+(l_bec_base-l_bec_tip)/2, 0], //4
  [27, l_bec_tip+(l_bec_base-l_bec_tip)/2, 0], //5
  [12.5, l_bec_base, 0], //6
  [0, l_bec_base, 0], //7

  [0, 0, 3], //8
  [12.5, 0, e], //9
  [27, (l_bec_base-l_bec_tip)/2, 2], //10
  [27, l_bec_tip+(l_bec_base-l_bec_tip)/2, 2], //11
  [12.5, l_bec_base, e], //12
  [0, l_bec_base, 3]]; //13

BecFaces = [
  [0,1,7], // bottom
  [6,7,1],
  [1,2,6],
  [2,5,6],
  [2,3,5],
  [3,4,5],

  [9,1,0], // front
  [0,8,9],
  [10,2,1],
  [1,9,10],
  [10,3,2],
  
  [12,9,8], // top
  [8,13,12],
  [11,10,9],
  [9,12,11],
  [4,3,10],
  [10,11,4],

  [11,5,4], // back
  [12,6,5],
  [5,11,12],
  [13,7,6],
  [6,12,13],
  
  [13,8,0], // left
  [0,7,13]];
  
adj=26.5-14;
hyp=sqrt(adj*adj+(e-2)*(e-2));
angle=acos(adj/hyp);

module bec() translate([(l_bec_base+l-l_extrude)/2,axe_pos-r_axe-bec_axe_pos,0]) rotate([0,0,90]) difference() {
  polyhedron( BecPoints, BecFaces );
  translate([24,(l_bec_base-2.5)/2,0]) rotate([0,angle,0]) cube([0.45,2.5,5]);
}

difference() {
    bec();
    axe(offset=0.2);
}
body();