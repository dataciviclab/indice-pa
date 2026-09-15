-- Clean: ipa_categorie_enti
-- Tabella di lookup categorie enti IPA.
-- Fonte: https://indicepa.gov.it/ipa-dati

SELECT DISTINCT
    normalize_string(Codice_categoria) AS codice_categoria,
    normalize_string(Nome_categoria) AS nome_categoria,
    normalize_string(Tipologia_categoria) AS tipologia_categoria,
    normalize_string(SFE) AS sfe,
    normalize_string(UTD) AS utd,
    normalize_string(NSO) AS nso,
    normalize_string(AOO) AS aoo,
    normalize_string(UO) AS uo
FROM raw_input
WHERE normalize_string(Codice_categoria) IS NOT NULL
ORDER BY codice_categoria
