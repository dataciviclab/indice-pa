-- Mart: ipa_rtd — pass-through
-- RTD per ogni UO, anagrafica completa.

SELECT * FROM clean_input
ORDER BY denominazione_ente, descrizione_uo
