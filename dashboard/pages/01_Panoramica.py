"""Panoramica — KPI principali dell'anagrafe IPA."""

import streamlit as st
from sources import (
    kpi_totali, enti_per_categoria, top_enti_per_uo,
    copertura_responsabili, enti_in_liquidazione, vertici_per_titolo,
    get_last_updated,
)

st.title("Panoramica")
st.caption(f"Anagrafe IPA — IndicePA · AgID | Aggiornato: {get_last_updated()}")

# -- KPI ----------------------------------------------------------------
kpi = kpi_totali()
liq = enti_in_liquidazione()
c1, c2, c3, c4 = st.columns(4)
c1.metric("Enti", f"{kpi['enti']:,}")
c2.metric("Unità organizzative", f"{kpi['uo']:,}")
c3.metric("Aree organizzative", f"{kpi['aoo']:,}")
c4.metric("Enti in liquidazione", f"{liq}")

# -- Copertura responsabili ---------------------------------------------
cop = copertura_responsabili()
st.progress(cop["pct"], text=f"Copertura responsabili UO: {cop['pct']:.1%} ({cop['con_responsabile']:,} / {cop['totale_uo']:,})")

# -- Due colonne --------------------------------------------------------
col1, col2 = st.columns(2)

with col1:
    st.subheader("Enti per categoria")
    df_cat = enti_per_categoria()
    st.dataframe(
        df_cat[["nome_categoria", "n_enti"]].head(15),
        width="stretch",
        hide_index=True,
        column_config={
            "nome_categoria": st.column_config.TextColumn("Categoria", width="large"),
            "n_enti": st.column_config.NumberColumn("N° enti", width="small"),
        },
    )

with col2:
    st.subheader("Vertici della PA")
    df_vert = vertici_per_titolo()
    st.dataframe(
        df_vert,
        width="stretch",
        hide_index=True,
        column_config={
            "vertice_ente_titolo": st.column_config.TextColumn("Titolo", width="medium"),
            "n_enti": st.column_config.NumberColumn("N° enti", width="small"),
        },
    )

# -- Top enti per numero UO (da mart_riepilogo) -------------------------
st.subheader("Enti con più unità organizzative")
df_top = top_enti_per_uo()
st.dataframe(
    df_top,
    width="stretch",
    hide_index=True,
    column_config={
        "denominazione_ente": st.column_config.TextColumn("Ente", width="large"),
        "n_uo": st.column_config.NumberColumn("N° UO", width="small"),
        "n_aoo": st.column_config.NumberColumn("N° AOO", width="small"),
        "pct_con_responsabile": st.column_config.NumberColumn("Copertura resp.", width="small", format="%.1f%%"),
    },
)
