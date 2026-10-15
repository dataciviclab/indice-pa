-- Clean: ipa_domicili_digitali
-- Domicili digitali (PEC / SERC) di enti e AOO — art. 1 comma 1 lett. n-ter CAD.
-- Ogni riga = un indirizzo elettronico associato a un ente o a una sua AOO.
-- Fonte: https://indicepa.gov.it/ipa-dati (package domicili-digitali, aggiornamento giornaliero)

SELECT DISTINCT
    normalize_string(Domicilio_digitale) AS domicilio_digitale,
    UPPER(normalize_string(Tipo_domicilio_digitale)) AS tipo_domicilio_digitale,
    normalize_string(Data_pubblicazione) AS data_pubblicazione,
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Nome_Categoria) AS nome_categoria,
    COALESCE(normalize_string(Codice_uni_aoo), '') AS codice_uni_aoo,
    normalize_string(Descrizione_aoo) AS descrizione_aoo,
    normalize_string(Data_aggiornamento) AS data_aggiornamento
FROM raw_input
WHERE normalize_string(Domicilio_digitale) IS NOT NULL
  AND normalize_string(Codice_IPA) IS NOT NULL
ORDER BY denominazione_ente, codice_ipa
