-- Clean: ipa_rtd
-- Responsabili della Transizione al Digitale (RTD) art. 17 CAD.
-- Ogni riga = una UO con il nominativo del RTD assegnato.
-- Fonte: https://indicepa.gov.it/ipa-dati

SELECT DISTINCT
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Nome_Categoria) AS nome_categoria,
    normalize_string(Codice_uni_uo) AS codice_uni_uo,
    normalize_string(Descrizione_uo) AS descrizione_uo,
    normalize_string(Data_istituzione) AS data_istituzione,
    CASE WHEN LOWER(TRIM(Nome_responsabile)) IN ('da_indicare', 'da compilare', 'non indicato', 'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc') THEN NULL ELSE normalize_string(Nome_responsabile) END AS nome_responsabile,
    CASE WHEN LOWER(TRIM(Cognome_responsabile)) IN ('da_indicare', 'da compilare', 'non indicato', 'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc') THEN NULL ELSE normalize_string(Cognome_responsabile) END AS cognome_responsabile,
    normalize_string(Mail_responsabile) AS mail_responsabile,
    normalize_string(Telefono_responsabile) AS telefono_responsabile,
    normalize_string(Mail1) AS mail1,
    normalize_string(Tipo_Mail1) AS tipo_mail1,
    normalize_string(Mail2) AS mail2,
    normalize_string(Tipo_Mail2) AS tipo_mail2,
    normalize_string(Mail3) AS mail3,
    normalize_string(Tipo_Mail3) AS tipo_mail3,
    normalize_string(Codice_comune_ISTAT) AS codice_comune_istat,
    normalize_string(Codice_catastale_comune) AS codice_catastale_comune,
    normalize_string(CAP) AS cap,
    normalize_string(Indirizzo) AS indirizzo,
    normalize_string(Telefono) AS telefono,
    normalize_string(Fax) AS fax,
    normalize_string(Data_aggiornamento) AS data_aggiornamento,
    normalize_string(Tipologia) AS tipologia,
    normalize_string(Codice_categoria) AS codice_categoria
FROM raw_input
WHERE normalize_string(Codice_uni_uo) IS NOT NULL
  AND normalize_string(Nome_responsabile) IS NOT NULL
ORDER BY denominazione_ente, descrizione_uo
