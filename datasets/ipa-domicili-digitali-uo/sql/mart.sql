-- Mart: ipa_domicili_digitali_uo — pass-through
-- Domicili digitali delle UO, anagrafica completa.

SELECT * FROM clean_input
ORDER BY denominazione_ente, descrizione_uo
