-- Mart: who-is-who-pa
-- Tabella leggera con le 17 colonne usate dalla dashboard

SELECT
    codice_ipa,
    denominazione_ente,
    codice_categoria,
    nome_categoria,
    tipologia,
    vertice_ente_titolo,
    descrizione_uo,
    uo_resp_nome,
    uo_resp_cognome,
    uo_resp_email,
    uo_mail,
    uo_tipo_mail,
    codice_uni_aoo,
    denominazione_aoo,
    rtd_nome,
    rtd_cognome,
    rtd_mail
FROM clean_input
ORDER BY denominazione_ente, descrizione_uo
