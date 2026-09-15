"""Scheda Ente — dettaglio ente con UO, RTD e servizi."""

import streamlit as st
from sources import elenco_entite, info_ente, scheda_ente, servizi_digitali_ente, servizi_uo_ente

st.title("Scheda Ente")
st.caption("Dettaglio anagrafico, unità organizzative, servizi e RTD")

# -- Selezione ente -----------------------------------------------------
df_ent = elenco_entite()
ente = st.selectbox("Seleziona un ente", df_ent["denominazione_ente"].tolist())

if not ente:
    st.stop()

# -- Info ente (dal compose) --------------------------------------------
info = info_ente(ente)
if not info:
    st.warning("Ente non trovato")
    st.stop()

c1, c2, c3, c4 = st.columns(4)
c1.metric("Codice IPA", info.get("codice_ipa", ""))
c2.metric("Tipologia", info.get("tipologia", ""))
c3.metric("Categoria", info.get("codice_categoria", ""))
c4.metric("N° UO", info["n_uo"])

vertice = f"{info.get('vertice_titolo', '')} {info.get('vertice_nome', '')} {info.get('vertice_cognome', '')}".strip()
if vertice:
    st.info(f"**Vertice:** {vertice}")

sito = info.get("sito", "")
if sito:
    st.write(f"**Sito istituzionale:** {sito}")

# -- RTD ----------------------------------------------------------------
df_uo = scheda_ente(ente)
rtd_rows = df_uo[df_uo["rtd_nome"].notna()]
if not rtd_rows.empty:
    rtd = rtd_rows.iloc[0]
    st.success(f"**RTD:** {rtd.get('rtd_nome', '')} {rtd.get('rtd_cognome', '')} — {rtd.get('rtd_mail', '')}")

# -- Tabs ---------------------------------------------------------------
tab_uo, tab_sd, tab_su = st.tabs(["Unità Organizzative", "Servizi Digitali", "Servizi UO"])

with tab_uo:
    st.subheader(f"Unità organizzative ({len(df_uo)})")
    st.dataframe(
        df_uo[[
            "descrizione_uo", "uo_resp_nome", "uo_resp_cognome",
            "uo_resp_email", "uo_resp_telefono", "uo_mail", "uo_tipo_mail",
            "denominazione_aoo",
        ]],
        use_container_width=True,
        hide_index=True,
        column_config={
            "descrizione_uo": st.column_config.TextColumn("Unità organizzativa", width="large"),
            "uo_resp_nome": st.column_config.TextColumn("Nome", width="small"),
            "uo_resp_cognome": st.column_config.TextColumn("Cognome", width="small"),
            "uo_resp_email": st.column_config.TextColumn("Email responsabile", width="medium"),
            "uo_resp_telefono": st.column_config.TextColumn("Telefono", width="small"),
            "uo_mail": st.column_config.TextColumn("Email UO", width="medium"),
            "uo_tipo_mail": st.column_config.TextColumn("Tipo", width="small"),
            "denominazione_aoo": st.column_config.TextColumn("AOO", width="medium"),
        },
    )

with tab_sd:
    df_sd = servizi_digitali_ente(ente)
    if df_sd.empty:
        st.warning(f"NESSUN servizio digitale registrato per **{ente}**")
        st.caption(f"Gli enti con servizi digitali sono 3.420 su 23.532 totali ({100*3420/23532:.1f}%)")
    else:
        st.subheader(f"Servizi digitali ({len(df_sd)})")
        st.dataframe(
            df_sd,
            use_container_width=True,
            hide_index=True,
            column_config={
                "tipologia_servizio": st.column_config.TextColumn("Tipologia", width="large"),
                "descrizione_servizio": st.column_config.TextColumn("Servizio", width="large"),
                "url_servizio": st.column_config.LinkColumn("URL", width="medium"),
            },
        )

with tab_su:
    df_su = servizi_uo_ente(ente)
    if df_su.empty:
        st.warning(f"NESSUN servizio UO registrato per **{ente}**")
        st.caption(f"Gli enti con servizi UO sono 1.332 su 23.532 totali ({100*1332/23532:.1f}%)")
    else:
        st.subheader(f"Servizi per UO ({len(df_su)})")
        st.dataframe(
            df_su,
            use_container_width=True,
            hide_index=True,
            column_config={
                "descrizione_uo": st.column_config.TextColumn("UO", width="large"),
                "categoria_servizio": st.column_config.TextColumn("Categoria", width="medium"),
                "descrizione_servizio": st.column_config.TextColumn("Servizio", width="large"),
            },
        )
