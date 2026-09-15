"""Trasformazione Digitale — RTD, servizi digitali, servizi UO."""

import streamlit as st
from sources import (
    kpi_digitale, top_enti_servizi_digitali,
    tipologie_servizi_digitali, categorie_servizi_uo,
)

st.title("Trasformazione Digitale")
st.caption("RTD, servizi digitali e servizi delle UO — art. 17 CAD")

# -- KPI ----------------------------------------------------------------
kpi = kpi_digitale()
c1, c2, c3 = st.columns(3)
c1.metric("Enti con RTD", f"{kpi['enti_con_rtd']:,}")
c2.metric("Servizi digitali", f"{kpi['totale_servizi_digitali']:,}")
c3.metric("Servizi UO", f"{kpi['totale_servizi_uo']:,}")

# -- Top enti servizi digitali ------------------------------------------
st.subheader("Top enti per servizi digitali")
df_top = top_enti_servizi_digitali()
st.dataframe(
    df_top,
    use_container_width=True,
    hide_index=True,
    column_config={
        "denominazione_ente": st.column_config.TextColumn("Ente", width="large"),
        "n_servizi_digitali": st.column_config.NumberColumn("N° servizi", width="small"),
        "n_tipologie": st.column_config.NumberColumn("N° tipologie", width="small"),
        "pct_con_url": st.column_config.NumberColumn("Con URL", width="small", format="%.1f%%"),
    },
)

# -- Due colonne --------------------------------------------------------
col1, col2 = st.columns(2)

with col1:
    st.subheader("Tipologie servizi digitali")
    df_tip = tipologie_servizi_digitali()
    st.dataframe(
        df_tip[["tipologia_servizio", "n", "n_enti"]].head(10),
        use_container_width=True,
        hide_index=True,
        column_config={
            "tipologia_servizio": st.column_config.TextColumn("Tipologia", width="large"),
            "n": st.column_config.NumberColumn("N° servizi", width="small"),
            "n_enti": st.column_config.NumberColumn("N° enti", width="small"),
        },
    )

with col2:
    st.subheader("Categorie servizi UO")
    df_cat = categorie_servizi_uo()
    st.dataframe(
        df_cat[["categoria_servizio", "n", "n_enti"]].head(10),
        use_container_width=True,
        hide_index=True,
        column_config={
            "categoria_servizio": st.column_config.TextColumn("Categoria", width="large"),
            "n": st.column_config.NumberColumn("N° servizi", width="small"),
            "n_enti": st.column_config.NumberColumn("N° enti", width="small"),
        },
    )
