clear, clc

numeDirectorSetDate = 'data/';
parametri.numeDirectorExemplePozitive = fullfile(numeDirectorSetDate, 'exemplePozitive');                                   
parametri.numeDirectorExempleNegative = fullfile(numeDirectorSetDate, 'exempleNegative'); 

parametri.numeDirectorExempleTest=fullfile(numeDirectorSetDate,'exempleTest/masini');
parametri.numeDirectorAdnotariTest=fullfile(numeDirectorSetDate,'exempleTest/masini_adnotari/ground_truth_bboxes.txt');

parametri.existaAdnotari = 1;
parametri.numeDirectorSalveazaFisiere = fullfile(numeDirectorSetDate,'salveazaFisiere/');
mkdir(parametri.numeDirectorSalveazaFisiere);

parametri.dimensiuneFereastra = 64;              
parametri.dimensiuneCelulaHOG = 8;               
parametri.dimensiuneDescriptorCelula = 31;       
parametri.overlap = 0.3;   
parametri.threshold = 3.5;                        

load('data/salveazaFisiere/model_antrenare_8');
parametri.svms = svms;

[detectii, scoruriDetectii, imageIdx] = ruleazaDetectorMasina(parametri);

if (parametri.existaAdnotari)
    [gt_ids, gt_detectii, gt_existaDetectie, tp, fp, detectii_duplicat] = evalueazaDetectii(detectii, scoruriDetectii, imageIdx, parametri.numeDirectorAdnotariTest);
    vizualizeazaDetectiiInImagineCuAdnotari(detectii, scoruriDetectii, imageIdx, tp, fp, parametri.numeDirectorExempleTest, parametri.numeDirectorAdnotariTest);
end