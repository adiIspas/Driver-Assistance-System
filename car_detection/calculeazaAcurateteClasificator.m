function [acuratete, rataExempleAdevaratPozitive, rataExempleFalsPozitive, rataAdevaratNegative, rataFalsNegative] = calculeazaAcurateteClasificator( scoruriClasificator, etichete )
% calculeazaAcurateteClasificator Calculeaza acuratetea pentru un
% clasificator dat
%
%   scoruriClasificator         = scorurile obtinute de clasificator
%   etichete                    = etichetele datelor
%
%   acuratete                   = acuratetea clasificatorului
%   rataExempleAdevaratPozitive = rata datelor clasificate adevarat pozitive
%   rataExempleFalsPozitive     = rata datelor clasificate fals pozitive
%   rataAdevaratNegative        = rata datelor clasificate adevarat negative
%   rataFalsNegative            = rata datelor clasificate fals negativ

    clasificareCorecta = sign(scoruriClasificator .* etichete);
    acuratete = 1 - sum(clasificareCorecta <= 0)/length(clasificareCorecta);
    fprintf('  acuratete:   %.4f\n', acuratete);

    exempleAdevaratPozitive = (scoruriClasificator >= 0) & (etichete >= 0);
    rataExempleAdevaratPozitive = sum( exempleAdevaratPozitive ) / length( exempleAdevaratPozitive);
    fprintf('  rata exemple adevarat pozitive: %.4f\n', rataExempleAdevaratPozitive);

    exempleFalsPozitive = (scoruriClasificator >= 0) & (etichete < 0);
    rataExempleFalsPozitive = sum( exempleFalsPozitive ) / length( exempleFalsPozitive);
    fprintf('  rata exemple fals pozitive: %.4f\n', rataExempleFalsPozitive);

    exempleAdevaratNegative = (scoruriClasificator < 0) & (etichete < 0);
    rataAdevaratNegative = sum( exempleAdevaratNegative ) / length( exempleAdevaratNegative);
    fprintf('  rata exemple adevarat negative: %.4f\n', rataAdevaratNegative);

    exempleFalsNegative = (scoruriClasificator < 0) & (etichete >= 0);
    rataFalsNegative = sum( exempleFalsNegative ) / length( exempleFalsNegative);
    fprintf('  rata exemple fals pozitive: %.4f\n', rataFalsNegative);