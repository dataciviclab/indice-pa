-- Clean: who-is-who-pa
-- Compose da ipa_enti + ipa_unita_organizzative + ipa_aree_organizzative_omogenee + ipa_rtd + ipa_categorie_enti
-- Ogni riga = un'unità organizzativa con contesto ente, responsabile, RTD e categoria leggibile
-- I support vengono eseguiti prima del compose; i path sono gestiti dal toolkit.

WITH enti AS (
    SELECT * FROM '{support.ipa_enti.clean}'
),

uo AS (
    SELECT * FROM '{support.ipa_unita_organizzative.clean}'
),

aoo AS (
    SELECT * FROM '{support.ipa_aree_organizzative_omogenee.clean}'
),

rtd AS (
    SELECT * FROM '{support.ipa_rtd.clean}'
),

categorie AS (
    SELECT * FROM '{support.ipa_categorie_enti.clean}'
)

SELECT
    -- Ente
    e.codice_ipa,
    e.denominazione_ente,
    e.codice_fiscale_ente,
    e.codice_categoria,
    c.nome_categoria,
    c.tipologia_categoria,
    e.tipologia,
    e.codice_istat,
    e.acronimo,
    e.titolo_responsabile AS vertice_ente_titolo,
    e.nome_responsabile AS vertice_ente_nome,
    e.cognome_responsabile AS vertice_ente_cognome,
    e.sito_istituzionale,

    -- UO
    uo.codice_uni_uo,
    uo.descrizione_uo,
    uo.codice_uni_uo_padre,
    uo.data_istituzione AS uo_data_istituzione,
    uo.nome_responsabile AS uo_resp_nome,
    uo.cognome_responsabile AS uo_resp_cognome,
    uo.mail_responsabile AS uo_resp_email,
    uo.telefono_responsabile AS uo_resp_telefono,
    uo.mail1 AS uo_mail,
    uo.tipo_mail1 AS uo_tipo_mail,
    uo.mail2 AS uo_mail2,
    uo.tipo_mail2 AS uo_tipo_mail2,

    -- AOO
    aoo.codice_uni_aoo,
    aoo.denominazione_aoo,
    aoo.nome_responsabile AS aoo_resp_nome,
    aoo.cognome_responsabile AS aoo_resp_cognome,
    aoo.mail1 AS aoo_mail,
    aoo.tipo_mail1 AS aoo_tipo_mail,
    aoo.protocollo_informatico,
    aoo.uri_protocollo_informatico,

    -- RTD (Responsabile Transizione Digitale)
    rtd.nome_responsabile AS rtd_nome,
    rtd.cognome_responsabile AS rtd_cognome,
    rtd.mail_responsabile AS rtd_mail,

    -- Sede
    uo.codice_comune_istat,
    uo.codice_catastale_comune,
    uo.cap,
    uo.indirizzo,
    e.codice_comune_istat AS ente_codice_comune_istat

FROM uo
LEFT JOIN enti e ON uo.codice_ipa = e.codice_ipa
LEFT JOIN aoo ON uo.codice_uni_aoo = aoo.codice_uni_aoo
LEFT JOIN rtd ON uo.codice_uni_uo = rtd.codice_uni_uo
LEFT JOIN categorie c ON e.codice_categoria = c.codice_categoria
ORDER BY e.denominazione_ente, uo.descrizione_uo
