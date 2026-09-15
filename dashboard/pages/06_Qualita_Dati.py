"""Qualità Dati — copertura campi, placeholder, problemi noti."""

import streamlit as st
import pandas as pd
from sources import load_mart

st.title("Qualità Dati")
st.caption("Verifica completezza e pulizia dei dati IPA")

# -- Carica dati --------------------------------------------------------
df_enti = load_mart("ipa_enti", slug="ipa_enti")
df_uo = load_mart()
df_aoo = load_mart("ipa_aree_organizzative_omogenee", slug="ipa_aree_organizzative_omogenee")

# -- KPI qualità --------------------------------------------------------
st.subheader("Indici di completezza")

placeholder_names = {'comandante', 'rtd', 'da_indicare', 'da compilare', 'non indicato', 
                     'non assegnato', 'non', 'n.d.', 'n/d', '-', 'nc', 'non specificato',
                     'non previsto', 'non attribuito', 'non individuato'}

uo_valid = df_uo[~df_uo["uo_resp_nome"].str.lower().isin(placeholder_names) | df_uo["uo_resp_nome"].isna()]

c1, c2, c3, c4 = st.columns(4)

pct_resp = 100 * uo_valid['uo_resp_nome'].notna().sum() / len(df_uo)
c1.metric("UO con resp. reale", f"{uo_valid['uo_resp_nome'].notna().sum():,}", f"{pct_resp:.1f}%")

pct_mail = 100 * df_uo['uo_mail'].notna().sum() / len(df_uo)
c2.metric("UO con email", f"{df_uo['uo_mail'].notna().sum():,}", f"{pct_mail:.1f}%")

pct_proto = 100 * df_aoo['protocollo_informatico'].notna().sum() / len(df_aoo)
c3.metric("AOO con protocollo", f"{df_aoo['protocollo_informatico'].notna().sum():,}", f"{pct_proto:.1f}%")

pct_sito = 100 * df_enti['sito_istituzionale'].notna().sum() / len(df_enti)
c4.metric("Enti con sito", f"{df_enti['sito_istituzionale'].notna().sum():,}", f"{pct_sito:.1f}%")

# -- Dettaglio problemi -------------------------------------------------
st.subheader("Problemi rilevati")

col1, col2 = st.columns(2)

with col1:
    st.markdown("**UO con nomi placeholder** (trattati come NULL)")
    placeholder_counts = df_uo[df_uo["uo_resp_nome"].str.lower().isin(placeholder_names)]["uo_resp_nome"].str.lower().value_counts().reset_index()
    placeholder_counts.columns = ["placeholder", "n"]
    st.dataframe(placeholder_counts, width="stretch", hide_index=True)

with col2:
    st.markdown("**Responsabili per tipologia ente**")
    df_tip = (
        df_uo.groupby("tipologia")
        .agg(n_uo=("codice_uni_uo", "count"), 
             con_resp=("uo_resp_nome", lambda x: x.notna().sum()))
        .reset_index()
    )
    df_tip["copertura_pct"] = (100 * df_tip["con_resp"] / df_tip["n_uo"]).round(1)
    df_tip = df_tip.sort_values("n_uo", ascending=False)
    st.dataframe(
        df_tip[["tipologia", "n_uo", "con_resp", "copertura_pct"]],
        width="stretch",
        hide_index=True,
        column_config={
            "tipologia": st.column_config.TextColumn("Tipologia", width="large"),
            "n_uo": st.column_config.NumberColumn("N° UO", width="small"),
            "con_resp": st.column_config.NumberColumn("Con resp.", width="small"),
            "copertura_pct": st.column_config.NumberColumn("Copertura %", width="small", format="%.1f%%"),
        },
    )

# -- Copertura email per tipo -------------------------------------------
st.subheader("Copertura contatti per tipo mail")
email_stats = pd.DataFrame({
    "Tipo": ["PEC", "Altro", "Nessuna"],
    "N° UO": [
        int((df_uo["uo_tipo_mail"] == "Pec").sum()),
        int((df_uo["uo_tipo_mail"] == "Altro").sum()),
        int(df_uo["uo_mail"].isna().sum()),
    ],
})
email_stats["pct"] = (100 * email_stats["N° UO"] / len(df_uo)).round(1)
st.dataframe(
    email_stats[["Tipo", "N° UO", "pct"]],
    width="stretch",
    hide_index=True,
    column_config={
        "Tipo": st.column_config.TextColumn("Tipo", width="medium"),
        "N° UO": st.column_config.NumberColumn("N° UO", width="small"),
        "pct": st.column_config.NumberColumn("Percentuale", width="small", format="%.1f%%"),
    },
)

# -- Note ---------------------------------------------------------------
st.info("""
**Note sulla qualità dati IPA:**
- I valori placeholder (`Comandante`, `RTD`, `da_indicare`, `non`) vengono trattati come NULL nel clean
- Il campo `protocollo_informatico` è opzionale e molti enti non lo compilano
- La copertura PEC è all'83% degli enti, ma solo al 48% delle UO
- Il 17% delle UO non ha un'AOO associata
""")

