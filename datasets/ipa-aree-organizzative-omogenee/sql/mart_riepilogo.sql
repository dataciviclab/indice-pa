-- Mart: ipa_aree_organizzative_omogenee — riepilogo per ente
-- Conta le AOO per ente con indicatori di completezza (responsabili, protocollo).

SELECT
    codice_ipa,
    denominazione_ente,
    COUNT(*) AS n_aoo,
    COUNT(nome_responsabile) AS con_responsabile,
    COUNT(mail1) AS con_mail1,
    COUNT(protocollo_informatico) AS con_protocollo,
    ROUND(100.0 * COUNT(nome_responsabile) / COUNT(*), 1) AS pct_con_responsabile,
    ROUND(100.0 * COUNT(protocollo_informatico) / COUNT(*), 1) AS pct_con_protocollo
FROM clean_input
GROUP BY codice_ipa, denominazione_ente
ORDER BY n_aoo DESC
