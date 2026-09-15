-- Mart: ipa_unita_organizzative — riepilogo per ente
-- Conta le UO per ente con indicatori di completezza (responsabili, mail, AOO).

SELECT
    codice_ipa,
    denominazione_ente,
    COUNT(*) AS n_uo,
    COUNT(DISTINCT codice_uni_aoo) AS n_aoo,
    COUNT(codice_uni_uo_padre) AS con_padre,
    COUNT(nome_responsabile) AS con_responsabile,
    COUNT(mail_responsabile) AS con_mail_responsabile,
    COUNT(mail1) AS con_mail1,
    ROUND(100.0 * COUNT(nome_responsabile) / COUNT(*), 1) AS pct_con_responsabile,
    ROUND(100.0 * COUNT(mail1) / COUNT(*), 1) AS pct_con_mail
FROM clean_input
GROUP BY codice_ipa, denominazione_ente
ORDER BY n_uo DESC
