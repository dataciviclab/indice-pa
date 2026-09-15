-- Mart: ipa_servizi_uo_riepilogo — servizi per ente
-- Conta i servizi erogati per ente, con breakdown per categoria.

SELECT
    codice_ipa,
    denominazione_ente,
    COUNT(*) AS n_servizi,
    COUNT(DISTINCT codice_uni_uo) AS n_uo_con_servizi,
    COUNT(DISTINCT id_servizio) AS n_servizi_unici,
    COUNT(DISTINCT categoria_servizio) AS n_categorie
FROM clean_input
GROUP BY codice_ipa, denominazione_ente
ORDER BY n_servizi DESC
