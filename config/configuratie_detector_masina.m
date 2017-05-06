parametri.dimensiuneFereastra = 64;              
parametri.dimensiuneCelulaHOG = 8;            
parametri.dimensiuneDescriptorCelula = 31;
parametri.extensie = 'png';
parametri.threshold = 2.5;  
parametri.path = 'eval_car/data/salveazaFisiere';

fisiereExemplePozitive = {
    'data/vehicles/Far'
    'data/vehicles/Left'
    'data/vehicles/MiddleClose'
    'data/vehicles/Right'
    };
parametri.fisiereExemplePozitive = fisiereExemplePozitive;

fisiereExempleNegative = {
    'data/non-vehicles/Far'
    'data/non-vehicles/Left'
    'data/non-vehicles/MiddleClose'
    'data/non-vehicles/Right'
    };
parametri.fisiereExempleNegative = fisiereExempleNegative;

parametri.svms = antreneazaClasificatorMulticlasa(parametri);