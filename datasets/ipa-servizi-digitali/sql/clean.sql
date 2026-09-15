-- Clean: ipa_servizi_digitali
-- Servizi digitali erogati in rete dagli enti (art. 1 CAD).
-- Ogni riga = un servizio digitale dell'ente con URL.
-- Fonte: https://indicepa.gov.it/ipa-dati

SELECT DISTINCT
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Nome_Categoria) AS nome_categoria,
    normalize_string(Id_servizio) AS id_servizio,
    normalize_string(Tipologia_servizio) AS tipologia_servizio,
    normalize_string(Descrizione_servizio) AS descrizione_servizio,
    normalize_string(Url_servizio) AS url_servizio,
    normalize_string(Data_aggiornamento) AS data_aggiornamento
FROM raw_input
WHERE normalize_string(Codice_IPA) IS NOT NULL
  AND normalize_string(Id_servizio) IS NOT NULL
ORDER BY denominazione_ente, descrizione_servizio
