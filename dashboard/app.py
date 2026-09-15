"""IPA — Anagrafe PA e Trasformazione Digitale Dashboard."""

import streamlit as st

st.set_page_config(
    page_title="IPA · Anagrafe PA",
    page_icon="🏛️",
    layout="wide",
    initial_sidebar_state="expanded",
)

pages = {
    "": [
        st.Page("pages/01_Panoramica.py", title="Panoramica", icon="📊", default=True),
    ],
    "Esplora": [
        st.Page("pages/02_Cerca_Ufficio.py", title="Cerca Ufficio", icon="🔍"),
        st.Page("pages/03_Scheda_Ente.py", title="Scheda Ente", icon="🏛️"),
    ],
    "Digitale": [
        st.Page("pages/05_Transformazione_Digitale.py", title="Trasformazione Digitale", icon="💻"),
    ],
    "Qualità": [
        st.Page("pages/06_Qualita_Dati.py", title="Qualità Dati", icon="🔍"),
    ],
    "Strumenti": [
        st.Page("pages/04_SQL.py", title="Query SQL", icon="🛠️"),
    ],
}

pg = st.navigation(pages, position="sidebar")
pg.run()
