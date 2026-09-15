-- Clean: ipa_unita_organizzative
-- Anagrafica unità organizzative (UO) degli enti PA da IndicePA (AgID).
-- Ogni riga rappresenta una UO, con codice univoco e riferimento gerarchico
-- al padre (codice_uni_uo_padre) per ricostruzione dell'albero organizzativo.
-- Fonte: https://indicepa.gov.it/ipa-dati
-- Formato originale: XLSX → letto via pandas.read_excel (openpyxl).

SELECT DISTINCT
    normalize_string(Codice_IPA) AS codice_ipa,
    normalize_string(Denominazione_ente) AS denominazione_ente,
    normalize_string(Codice_fiscale_ente) AS codice_fiscale_ente,
    normalize_string(Codice_uni_uo) AS codice_uni_uo,
    normalize_string(Codice_uni_aoo) AS codice_uni_aoo,
    normalize_string(Codice_uni_uo_padre) AS codice_uni_uo_padre,
    normalize_string(Descrizione_uo) AS descrizione_uo,
    normalize_string(Data_istituzione) AS data_istituzione,
    CASE WHEN LOWER(TRIM(Nome_responsabile)) IN ('da_indicare', 'da compilare', 'non indicato', 'comandante', 'rtd', 'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc', 'non specificato', 'non previsto', 'non attribuito', 'non individuato') THEN NULL ELSE normalize_string(Nome_responsabile) END AS nome_responsabile,
    CASE WHEN LOWER(TRIM(Cognome_responsabile)) IN ('da_indicare', 'da compilare', 'non indicato', 'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc', 'non specificato', 'non previsto', 'non attribuito', 'non individuato') THEN NULL ELSE normalize_string(Cognome_responsabile) END AS cognome_responsabile,
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
    normalize_string(Data_aggiornamento) AS data_aggiornamento,
    normalize_string(Url) AS url
FROM raw_input
WHERE normalize_string(Codice_uni_uo) IS NOT NULL
ORDER BY denominazione_ente, descrizione_uo
