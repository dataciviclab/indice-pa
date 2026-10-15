"""Trasformazione Digitale — RTD, servizi digitali, servizi UO."""

import streamlit as st
from sources import (
    categorie_servizi_uo,
    kpi_digitale,
    kpi_totali,
    tipologie_servizi_digitali,
    top_enti_servizi_digitali,
)

st.title("Trasformazione Digitale")
st.caption("RTD, servizi digitali, servizi delle UO e domicili digitali — art. 17 e 6-ter CAD")

# -- KPI ----------------------------------------------------------------
kpi = kpi_digitale()
kpi_tot = kpi_totali()
c1, c2, c3, c4 = st.columns(4)
c1.metric("Enti con RTD", f"{kpi['enti_con_rtd']:,}")
c2.metric("Servizi digitali", f"{kpi['totale_servizi_digitali']:,}")
c3.metric("Servizi UO", f"{kpi['totale_servizi_uo']:,}")
pct_dom = kpi_tot["enti_con_domicilio"] / kpi_tot["enti"] if kpi_tot["enti"] else 0
c4.metric("Enti con domicilio digitale", f"{kpi_tot['enti_con_domicilio']:,}", f"{pct_dom:.1%}")

# -- Top enti servizi digitali ------------------------------------------
st.subheader("Top enti per servizi digitali")
df_top = top_enti_servizi_digitali()
st.dataframe(
    df_top,
    width="stretch",
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
        width="stretch",
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
        width="stretch",
        hide_index=True,
        column_config={
            "categoria_servizio": st.column_config.TextColumn("Categoria", width="large"),
            "n": st.column_config.NumberColumn("N° servizi", width="small"),
            "n_enti": st.column_config.NumberColumn("N° enti", width="small"),
        },
    )
