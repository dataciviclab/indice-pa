-- Clean: ipa_servizi_uo
-- Servizi erogati dalle Unità Organizzative.
-- Ogni riga = una coppia UO-servizio.
-- Fonte: https://indicepa.gov.it/ipa-dati

SELECT DISTINCT
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Nome_Categoria) AS nome_categoria,
    normalize_string(Codice_uni_uo) AS codice_uni_uo,
    normalize_string(Descrizione_uo) AS descrizione_uo,
    normalize_string(Id_servizio) AS id_servizio,
    normalize_string(Categoria_servizio) AS categoria_servizio,
    normalize_string(Descrizione_servizio) AS descrizione_servizio,
    normalize_string(Data_aggiornamento) AS data_aggiornamento
FROM raw_input
WHERE normalize_string(Codice_uni_uo) IS NOT NULL
  AND normalize_string(Id_servizio) IS NOT NULL
ORDER BY denominazione_ente, descrizione_uo, descrizione_servizio
