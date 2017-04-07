%% Seteaza path-urile pentru seturile de date: antrenare, test

numeDirectorSetDate = 'data/'; %
parametri.numeDirectorExemplePozitive = fullfile(numeDirectorSetDate, 'exemplePozitive');                                   %exemple pozitive de antrenare: 36x36 fete cropate
parametri.numeDirectorExempleNegative = fullfile(numeDirectorSetDate, 'exempleNegative');                                   %exemple negative de antrenare: imagini din care trebuie sa selectati ferestre 36x36
parametri.numeDirectorExemplePuternicNegative = fullfile(numeDirectorSetDate, 'exemplePuternicNegative');  
parametri.numeDirectorExempleTest=fullfile(numeDirectorSetDate,'exempleTest/test');
parametri.numeDirectorAdnotariTest = fullfile(numeDirectorSetDate,'exempleTest/CMU+MIT_adnotari/ground_truth_bboxes.txt');  %fisierul cu adnotari pentru exemplele test din dataset-ul CMU+MIT
parametri.existaAdnotari = 0;
parametri.numeDirectorSalveazaFisiere = fullfile(numeDirectorSetDate,'salveazaFisiere/');
mkdir(parametri.numeDirectorSalveazaFisiere);
%seteaza valori pentru diferiti parametri
parametri.dimensiuneFereastra = 64;              %exemplele pozitive (fete de oameni cropate) au 36x36 pixeli
parametri.dimensiuneCelulaHOG = 8;               %dimensiunea celulei
parametri.dimensiuneDescriptorCelula = 31;       %dimensiunea descriptorului unei celule
parametri.overlap = 0.3;                         %cat de mult trebuie sa se suprapuna doua detectii pentru a o elimina pe cea cu scorul mai mic
parametri.antrenareCuExemplePuternicNegative = 0;%(optional)antrenare cu exemple puternic negative
parametri.genereazaExemplePuternicNegative = 0;
parametri.numarExemplePozitive = 1475;           %numarul exemplelor pozitive
parametri.numarExempleNegative = 2000;          %numarul exemplelor negative
parametri.threshold = 1.3;                        %toate ferestrele cu scorul > threshold si maxime locale devin detectii
parametri.vizualizareTemplateHOG = 0;            %vizualizeaza template HOG

% %% Pasul 1. Incarcam exemplele pozitive (cropate) si exemple negative generate
% %exemple pozitive
% numeFisierDescriptoriExemplePozitive = [parametri.numeDirectorSalveazaFisiere 'descriptoriExemplePozitive_' num2str(parametri.dimensiuneCelulaHOG) '_' ...
%     num2str(parametri.numarExemplePozitive) '.mat'];
% temp = load(numeFisierDescriptoriExemplePozitive);
% descriptoriExemplePozitive = temp.descriptoriExemplePozitive;
% disp('Am incarcat descriptorii pentru exemplele pozitive');
% 
% %exemple negative
% numeFisierDescriptoriExempleNegative = [parametri.numeDirectorSalveazaFisiere 'descriptoriExempleNegative_' num2str(parametri.dimensiuneCelulaHOG) '_' ...
%     num2str(parametri.numarExempleNegative) '.mat'];
% temp = load(numeFisierDescriptoriExempleNegative);
% descriptoriExempleNegative = temp.descriptoriExempleNegative;
% disp('Am incarcat descriptorii pentru exemplele negative');
% 
% disp('Am obtinut exemplele de antrenare');
% %% Pasul 2. Invatam clasificatorul liniar
%  exempleAntrenare = [descriptoriExemplePozitive;descriptoriExempleNegative]';
%  eticheteExempleAntrenare = [ones(size(descriptoriExemplePozitive,1),1); -1*ones(size(descriptoriExempleNegative,1),1)];
%  [w, b] = antreneazaClasificator(exempleAntrenare,eticheteExempleAntrenare);
%  parametri.w = w;
%  parametri.b = b;

parametri.svms = antreneazaClasificatorMulticlasa();