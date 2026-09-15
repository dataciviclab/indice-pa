-- Mart: ipa_servizi_digitali_riepilogo — servizi digitali per ente
-- Conta i servizi digitali per ente, con breakdown per tipologia.

SELECT
    codice_ipa,
    denominazione_ente,
    COUNT(*) AS n_servizi_digitali,
    COUNT(DISTINCT tipologia_servizio) AS n_tipologie,
    COUNT(url_servizio) AS con_url,
    ROUND(100.0 * COUNT(url_servizio) / COUNT(*), 1) AS pct_con_url
FROM clean_input
GROUP BY codice_ipa, denominazione_ente
ORDER BY n_servizi_digitali DESC
