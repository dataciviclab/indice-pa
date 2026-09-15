"""Cerca Ufficio — ricerca per nome ufficio, responsabile, ente."""

import streamlit as st
from sources import cerca_ufficio, elenco_entite

st.title("Cerca Ufficio")
st.caption("Cerca un ufficio o un responsabile nell'anagrafe IPA")

# -- Filtri -------------------------------------------------------------
col1, col2 = st.columns([2, 1])
with col1:
    search = st.text_input("Cerca per nome ufficio, responsabile, cognome o RTD", placeholder="es. Segreteria, Rossi, Protocollo, Mineo")
with col2:
    df_ent = elenco_entite()
    ente = st.selectbox("Filtra per ente", [""] + df_ent["denominazione_ente"].tolist())

# -- Risultati ----------------------------------------------------------
df = cerca_ufficio(search=search, ente=ente)
st.info(f"{len(df)} risultati")

st.dataframe(
    df,
    use_container_width=True,
    hide_index=True,
    column_config={
        "denominazione_ente": st.column_config.TextColumn("Ente", width="medium"),
        "descrizione_uo": st.column_config.TextColumn("Unità organizzativa", width="large"),
        "uo_resp_nome": st.column_config.TextColumn("Nome resp.", width="small"),
        "uo_resp_cognome": st.column_config.TextColumn("Cognome resp.", width="small"),
        "uo_resp_email": st.column_config.TextColumn("Email responsabile", width="medium"),
        "uo_mail": st.column_config.TextColumn("Email UO", width="medium"),
        "uo_tipo_mail": st.column_config.TextColumn("Tipo", width="small"),
        "denominazione_aoo": st.column_config.TextColumn("AOO", width="medium"),
        "rtd_nome": st.column_config.TextColumn("RTD Nome", width="small"),
        "rtd_cognome": st.column_config.TextColumn("RTD Cognome", width="small"),
        "rtd_mail": st.column_config.TextColumn("RTD Email", width="medium"),
    },
)
