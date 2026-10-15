-- Mart: who-is-who-pa
-- Tabella leggera con le colonne usate dalla dashboard (+ flag domicili digitali)

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
    uo_resp_telefono,
    uo_mail,
    uo_tipo_mail,
    codice_uni_aoo,
    denominazione_aoo,
    rtd_nome,
    rtd_cognome,
    rtd_mail,
    ente_ha_domicilio,
    uo_ha_domicilio,
    uo_domicilio_digitale,
    uo_tipo_domicilio
FROM clean_input
ORDER BY denominazione_ente, descrizione_uo
