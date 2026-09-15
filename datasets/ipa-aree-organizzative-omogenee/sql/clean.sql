-- Clean: ipa_aree_organizzative_omogenee
-- Anagrafica Aree Organizzative Omogenee (AOO) degli enti PA da IndicePA (AgID).
-- Ogni AOO corrisponde a un registro di protocollo dell'ente e raggruppa
-- le Unità Organizzative (UO) per area (es. Area Amministrativa, Area Tecnica).
-- Fonte: https://indicepa.gov.it/ipa-dati
-- Formato originale: XLSX → letto via pandas.read_excel (openpyxl).

SELECT DISTINCT
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Codice_uni_aoo) AS codice_uni_aoo,
    normalize_string(Denominazione_aoo) AS denominazione_aoo,
    normalize_string(Data_istituzione) AS data_istituzione,
    normalize_string(Nome_responsabile) AS nome_responsabile,
    normalize_string(Cognome_responsabile) AS cognome_responsabile,
    normalize_string(Mail_responsabile) AS mail_responsabile,
    normalize_string(Telefono_responsabile) AS telefono_responsabile,
    normalize_string(Codice_comune_ISTAT) AS codice_comune_istat,
    normalize_string(Codice_catastale_comune) AS codice_catastale_comune,
    normalize_string(CAP) AS cap,
    normalize_string(Indirizzo) AS indirizzo,
    normalize_string(Telefono) AS telefono,
    normalize_string(Fax) AS fax,
    normalize_string(Mail1) AS mail1,
    normalize_string(Tipo_Mail1) AS tipo_mail1,
    normalize_string(Mail2) AS mail2,
    normalize_string(Tipo_Mail2) AS tipo_mail2,
    normalize_string(Mail3) AS mail3,
    normalize_string(Tipo_Mail3) AS tipo_mail3,
    normalize_string(Protocollo_informatico) AS protocollo_informatico,
    normalize_string(URI_Protocollo_informatico) AS uri_protocollo_informatico,
    normalize_string(Data_aggiornamento) AS data_aggiornamento,
    normalize_string(cod_AOO) AS cod_aoo
FROM raw_input
WHERE normalize_string(Codice_uni_aoo) IS NOT NULL
  AND normalize_string(Denominazione_aoo) IS NOT NULL
ORDER BY denominazione_ente, denominazione_aoo
