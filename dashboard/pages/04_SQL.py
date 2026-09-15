"""Query SQL — esegui query SQL arbitrarie sul clean layer."""

import streamlit as st
import pandas as pd
from sources import query

st.title("Query SQL")
st.caption("Esegui query SQL sul compose who_is_who_pa")

st.info("La tabella disponibile è `clean_input` con tutte le colonne del compose.")

# -- Esempi -------------------------------------------------------------
with st.expander("Esempi di query"):
    st.code(
        """-- Trova tutti gli uffici del Comune di Bologna
SELECT descrizione_uo, uo_resp_nome, uo_resp_cognome, uo_resp_email
FROM clean_input
WHERE denominazione_ente = 'Comune di Bologna'
ORDER BY descrizione_uo;

-- Enti con più di 100 UO
SELECT denominazione_ente, COUNT(*) as n_uo
FROM clean_input
GROUP BY denominazione_ente
HAVING n_uo > 100
ORDER BY n_uo DESC;

-- Uffici con PEC istituzionale
SELECT denominazione_ente, descrizione_uo, uo_mail
FROM clean_input
WHERE uo_tipo_mail = 'Pec'
LIMIT 100;""",
        language="sql",
    )

# -- Input --------------------------------------------------------------
sql = st.text_area(
    "Query SQL",
    height=150,
    placeholder="SELECT * FROM clean_input LIMIT 100",
)

# -- Esecuzione ---------------------------------------------------------
if st.button("Esegui", type="primary") and sql.strip():
    with st.spinner("Esecuzione in corso..."):
        try:
            df = query(sql)
            st.success(f"{len(df)} righe restituite")
            st.dataframe(df, width="stretch", hide_index=True)
        except Exception as e:
            st.error(f"Errore: {e}")
