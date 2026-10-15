-- Clean: who-is-who-pa
-- Compose da ipa_enti + ipa_unita_organizzative + ipa_aree_organizzative_omogenee + ipa_rtd + ipa_categorie_enti
--        + ipa_domicili_digitali + ipa_domicili_digitali_uo
-- Ogni riga = un'unità organizzativa con contesto ente, responsabile, RTD, categoria leggibile e domicili digitali
-- I support vengono eseguiti prima del compose; i path sono gestiti dal toolkit.
-- Nota: i domicili sono pre-aggregati (ente e UO) per preservare il grain = 1 riga per UO.

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
),

dd_ente AS (
    SELECT
        codice_ipa,
        COUNT(*) AS n_domicili_ente,
        COUNT(*) FILTER (WHERE tipo_domicilio_digitale = 'PEC') AS n_pec_ente,
        COUNT(*) FILTER (WHERE tipo_domicilio_digitale = 'SERC') AS n_serc_ente
    FROM '{support.ipa_domicili_digitali.clean}'
    GROUP BY codice_ipa
),

dd_uo AS (
    SELECT
        codice_uni_uo,
        COUNT(*) AS n_domicili_uo,
        MIN(domicilio_digitale) AS domicilio_digitale,
        MIN(tipo_domicilio_digitale) AS tipo_domicilio_digitale
    FROM '{support.ipa_domicili_digitali_uo.clean}'
    GROUP BY codice_uni_uo
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

    -- Domicili digitali (ente e UO, pre-aggregati)
    COALESCE(dd_ente.n_domicili_ente, 0) AS ente_n_domicili,
    COALESCE(dd_ente.n_pec_ente, 0) AS ente_n_pec,
    COALESCE(dd_ente.n_serc_ente, 0) AS ente_n_serc,
    (dd_ente.codice_ipa IS NOT NULL) AS ente_ha_domicilio,
    COALESCE(dd_uo.n_domicili_uo, 0) AS uo_n_domicili,
    dd_uo.domicilio_digitale AS uo_domicilio_digitale,
    dd_uo.tipo_domicilio_digitale AS uo_tipo_domicilio,
    (dd_uo.codice_uni_uo IS NOT NULL) AS uo_ha_domicilio,

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
LEFT JOIN dd_ente ON uo.codice_ipa = dd_ente.codice_ipa
LEFT JOIN dd_uo ON uo.codice_uni_uo = dd_uo.codice_uni_uo
ORDER BY e.denominazione_ente, uo.descrizione_uo
