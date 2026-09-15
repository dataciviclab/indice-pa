-- Clean: ipa_enti
-- Anagrafica completa enti da IPA (Indice PA), fonte AgID.
-- Dump CSV con encoding UTF-8, delim ',', header.
-- Include tutte le categorie: PA, Stazioni Appaltanti, Gestori, Società, ecc.
-- Fonte: https://indicepa.gov.it/ipa-dati

SELECT DISTINCT
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Tipologia) AS tipologia,
    normalize_string(Codice_Categoria) AS codice_categoria,
    normalize_string(Codice_natura) AS codice_natura,
    normalize_string(Codice_ateco) AS codice_ateco,
    CASE WHEN normalize_string(Ente_in_liquidazione) IN ('S','s') THEN TRUE
         WHEN normalize_string(Ente_in_liquidazione) IN ('N','n') THEN FALSE
         ELSE NULL END AS ente_in_liquidazione,
    normalize_string(Codice_MIUR) AS codice_miur,
    normalize_string(Codice_ISTAT) AS codice_istat,
    normalize_string(Acronimo) AS acronimo,
    CASE WHEN LOWER(TRIM(Nome_responsabile)) IN ('da_indicare', 'da compilare', 'non indicato', 'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc') THEN NULL ELSE normalize_string(Nome_responsabile) END AS nome_responsabile,
    CASE WHEN LOWER(TRIM(Cognome_responsabile)) IN ('da_indicare', 'da compilare', 'non indicato', 'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc') THEN NULL ELSE normalize_string(Cognome_responsabile) END AS cognome_responsabile,
    normalize_string(Titolo_responsabile) AS titolo_responsabile,
    normalize_string(Codice_comune_ISTAT) AS codice_comune_istat,
    normalize_string(Codice_catastale_comune) AS codice_catastale_comune,
    normalize_string(CAP) AS cap,
    normalize_string(Indirizzo) AS indirizzo,
    normalize_string(Mail1) AS mail1,
    normalize_string(Tipo_Mail1) AS tipo_mail1,
    normalize_string(Mail2) AS mail2,
    normalize_string(Tipo_Mail2) AS tipo_mail2,
    normalize_string(Mail3) AS mail3,
    normalize_string(Tipo_Mail3) AS tipo_mail3,
    normalize_string(Mail4) AS mail4,
    normalize_string(Tipo_Mail4) AS tipo_mail4,
    normalize_string(Mail5) AS mail5,
    normalize_string(Tipo_Mail5) AS tipo_mail5,
    normalize_string(Sito_istituzionale) AS sito_istituzionale,
    normalize_string(Data_aggiornamento) AS data_aggiornamento
FROM raw_input
WHERE normalize_string(Codice_IPA) IS NOT NULL
ORDER BY denominazione_ente
