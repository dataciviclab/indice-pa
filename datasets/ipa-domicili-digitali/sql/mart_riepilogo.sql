-- Mart: ipa_domicili_digitali_riepilogo — domicili per ente
-- Conta domicili digitali (PEC/SERC) e indirizzi distinti per ente.

SELECT
    codice_ipa,
    denominazione_ente,
    nome_categoria,
    COUNT(*) AS n_domicili,
    COUNT(*) FILTER (WHERE tipo_domicilio_digitale = 'PEC') AS n_pec,
    COUNT(*) FILTER (WHERE tipo_domicilio_digitale = 'SERC') AS n_serc,
    COUNT(*) FILTER (WHERE codice_uni_aoo <> '') AS n_con_aoo,
    COUNT(DISTINCT domicilio_digitale) AS n_indirizzi_distinti,
    MIN(data_pubblicazione) AS prima_pubblicazione,
    MAX(data_aggiornamento) AS ultimo_aggiornamento
FROM clean_input
GROUP BY codice_ipa, denominazione_ente, nome_categoria
ORDER BY n_domicili DESC
