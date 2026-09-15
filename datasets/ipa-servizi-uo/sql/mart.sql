-- Mart: ipa_servizi_uo — pass-through
-- Servizi per UO, anagrafica completa.

SELECT * FROM clean_input
ORDER BY denominazione_ente, descrizione_uo, descrizione_servizio
