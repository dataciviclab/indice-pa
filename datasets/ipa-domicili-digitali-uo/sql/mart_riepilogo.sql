-- Mart: ipa_domicili_digitali_uo_riepilogo — domicili UO per ente
-- Conta UO con domicilio digitale e indirizzi distinti per ente.

SELECT
    codice_ipa,
    MAX(denominazione_ente) AS denominazione_ente,
    COUNT(*) AS n_domicili_uo,
    COUNT(DISTINCT codice_uni_uo) AS n_uo_con_domicilio,
    COUNT(*) FILTER (WHERE tipo_domicilio_digitale = 'PEC') AS n_pec,
    COUNT(*) FILTER (WHERE tipo_domicilio_digitale = 'SERC') AS n_serc,
    COUNT(DISTINCT domicilio_digitale) AS n_indirizzi_distinti
FROM clean_input
GROUP BY codice_ipa
ORDER BY n_domicili_uo DESC
