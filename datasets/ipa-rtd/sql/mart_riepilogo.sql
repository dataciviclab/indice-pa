-- Mart: ipa_rtd_riepilogo — RTD per ente
-- Conta le UO con RTD assegnato per ente.

SELECT
    codice_ipa,
    denominazione_ente,
    nome_categoria,
    tipologia,
    COUNT(*) AS n_rtd,
    COUNT(DISTINCT nome_responsabile || ' ' || cognome_responsabile) AS n_persone,
    COUNT(mail_responsabile) AS con_mail,
    COUNT(telefono_responsabile) AS con_telefono
FROM clean_input
GROUP BY codice_ipa, denominazione_ente, nome_categoria, tipologia
ORDER BY n_rtd DESC
