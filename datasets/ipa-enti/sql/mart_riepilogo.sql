-- Mart: ipa_enti — riepilogo per categoria e tipologia
-- Conta gli enti per codice_categoria e tipologia, con indicatori di completezza.

SELECT
    codice_categoria,
    tipologia,
    COUNT(*) AS n_enti,
    COUNT(codice_fiscale_ente) AS con_codice_fiscale,
    COUNT(codice_miur) AS con_codice_miur,
    COUNT(codice_istat) AS con_codice_istat,
    COUNT(nome_responsabile) AS con_responsabile,
    COUNT(sito_istituzionale) AS con_sito,
    SUM(CASE WHEN ente_in_liquidazione THEN 1 ELSE 0 END) AS in_liquidazione,
    ROUND(100.0 * COUNT(nome_responsabile) / COUNT(*), 1) AS pct_con_responsabile
FROM clean_input
GROUP BY codice_categoria, tipologia
ORDER BY n_enti DESC
