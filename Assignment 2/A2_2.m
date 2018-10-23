G1 = impyramid(video_yiq, 'reduce');   G2 = impyramid(G1, 'reduce');
G3 = impyramid(G2, 'reduce');   G4 = impyramid(G3, 'reduce');
G5 = impyramid(G4, 'reduce');   G6 = impyramid(G5, 'reduce');

L0 = LaplacianPyramid(video_yiq, G1);  L1 = LaplacianPyramid(G1, G2);
L2 = LaplacianPyramid(G2, G3);  L3 = LaplacianPyramid(G3, G4);
L4 = LaplacianPyramid(G4, G5);  %L5 = LaplacianPyramid(G5, G6);

%LP{1} = L0; LP{2} = L1; LP{3} = L2;
%LP{4} = L3; LP{5} = L4; LP{6} = L5;

clear G1;
clear G2;
clear G3;
clear G4;
clear G5;
clear G6;