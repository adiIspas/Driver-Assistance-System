% Structura codului:
% ruleazaProiect.m                                <--- (optional) completati pasul 3
%  + obtineDescriptoriExemplePozitive.m           <--- trebuie sa completati aceasta functie
%  + obtineDescriptoriExempleNegative.m           <--- trebuie sa completati aceasta functie
%  + antreneazaClasificator.m                     <--- functie scrisa in intregime
%    + calculeazaAcurateteClasificator.m          <--- functie scrisa in intregime
%  + vizualizeazaTemplateHOG.m                    <--- functie scrisa in intregime
%  + calculeazaPrecizieClasificator.m             <--- functie scrisa in intregime
%  + ruleazaDetectorFacial.m                      <--- trebuie sa completati aceasta functie
%    + eliminaNonMaximele.m                       <--- functie scrisa in intregime
%  + evalueazaDetectii.m                          <--- functie scrisa in intregime
%    + calculeazaPrecizieClasificator.m           <--- functie scrisa in intregime
%  + vizualizeazaDetectiiInImagineCuAdnotari.m    <--- functie scrisa in intregime
%  + vizualizeazaDetectiiInImagineFaraAdnotari.m  <--- functie scrisa in intregime

%% Pasul 0 - initializam parametri
%seteaza path-urile pentru seturile de date: antrenare, test
% clear
% clc


%% 
% Pasul 3. (optional) Antrenare cu exemple puternic negative (detectii cu scor >0 din cele 274 de imagini negative)
% Daca implementati acest pas ar trebui sa modificati functia ruleazaDetectorFacial.m
% astfel incat sa va returneze descriptorii detectiilor cu scor >0 din cele 274 imagini negative
% completati codul in continuare


%% 
% Pasul 4. Ruleaza detectorul facial pe imaginile de test.
tic
[detectii, scoruriDetectii, imageIdx] = ruleazaDetectorFacial(parametri);
toc
%% 
% Pasul 5. Evalueaza si vizualizeaza detectiile
% Pentru imagini pentru care exista adnotari (cele din setul de date  CMU+MIT) folositi functia vizualizeazaDetectiiInImagineCuAdnotari.m,
% pentru imagini fara adnotari (cele realizate la curs si laborator) folositi functia vizualizeazaDetectiiInImagineFaraAdnotari.m,

if (parametri.existaAdnotari)
    [gt_ids, gt_detectii, gt_existaDetectie, tp, fp, detectii_duplicat] = evalueazaDetectii(detectii, scoruriDetectii, imageIdx, parametri.numeDirectorAdnotariTest);
    vizualizeazaDetectiiInImagineCuAdnotari(detectii, scoruriDetectii, imageIdx, tp, fp, parametri.numeDirectorExempleTest, parametri.numeDirectorAdnotariTest);
else
    vizualizeazaDetectiiInImagineFaraAdnotari(detectii, scoruriDetectii, imageIdx, parametri.numeDirectorExempleTest);
end
