-- Mart: ipa_domicili_digitali — pass-through
-- Domicili digitali di enti e AOO, anagrafica completa.

SELECT * FROM clean_input
ORDER BY denominazione_ente, codice_ipa, codice_uni_aoo
