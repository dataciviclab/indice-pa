"""Data sources — loader per il compose who_is_who_pa, dataset upstream e trasformazione digitale.

Uses lab_connectors to read from GCS in production, local files in dev.
"""

from __future__ import annotations

import json
from pathlib import Path

import pandas as pd
import streamlit as st
from lab_connectors.duckdb.queries import load_mart_table, query_clean

# -- Config --------------------------------------------------------------
PREFIX = "indice-pa/"
YEARS = [2026]
_REPO = Path(__file__).resolve().parent.parent
_REGISTRY = _REPO / "registry" / "registry.json"


def _detect_local_root() -> str | None:
    """Detect local output directory for fallback."""
    data_dir = _REPO / "out" / "data"
    if data_dir.is_dir() and any(data_dir.rglob("*.parquet")):
        return str(data_dir)
    return None


_LOCAL_ROOT = _detect_local_root()


def _mart(slug: str, table: str, year: int = 2026) -> pd.DataFrame:
    """Load a mart table via lab_connectors with local fallback."""
    return load_mart_table(slug, table, year, prefix=PREFIX, local_root=_LOCAL_ROOT)


def load_mart(table: str = "who_is_who_pa", year: int = 2026, slug: str = "") -> pd.DataFrame:
    """Public wrapper for backward compatibility."""
    return _mart(slug or "who_is_who_pa", table, year)


def get_last_updated() -> str:
    """Read last_updated from registry."""
    try:
        if _REGISTRY.exists():
            data = json.loads(_REGISTRY.read_text())
            return data.get("updated_at", "N/A")
    except Exception:
        pass
    return "N/A"


@st.cache_data(ttl=3600, show_spinner=False)
def query(sql: str, year: int = 2026, slug: str = "") -> pd.DataFrame:
    return query_clean(slug or "who_is_who_pa", sql, [year], prefix=PREFIX, local_root=_LOCAL_ROOT)


# -- Compose (cached once) -----------------------------------------------

@st.cache_data(ttl=3600, show_spinner=False)
def _load_compose() -> pd.DataFrame:
    """Load the compose mart once, shared across all functions."""
    return _mart("who_is_who_pa", "who_is_who_pa", 2026)


# -- Panoramica ---------------------------------------------------------

@st.cache_data(ttl=3600, show_spinner=False)
def kpi_totali():
    df = _load_compose()
    return {
        "enti": int(df["codice_ipa"].nunique()),
        "uo": int(len(df)),
        "aoo": int(df["codice_uni_aoo"].dropna().nunique()),
        "con_responsabile": int(df["uo_resp_nome"].notna().sum()),
    }


@st.cache_data(ttl=3600, show_spinner=False)
def enti_per_categoria():
    df = _load_compose()
    return (
        df[df["nome_categoria"].notna()]
        .groupby(["codice_categoria", "nome_categoria"])
        .agg(n_enti=("codice_ipa", "nunique"))
        .reset_index()
        .sort_values("n_enti", ascending=False)
    )


@st.cache_data(ttl=3600, show_spinner=False)
def top_enti_per_uo(top_n=15):
    df = _mart("ipa_unita_organizzative", "ipa_unita_organizzative_riepilogo")
    return df[["denominazione_ente", "n_uo", "n_aoo", "pct_con_responsabile"]].sort_values("n_uo", ascending=False).head(top_n)


@st.cache_data(ttl=3600, show_spinner=False)
def copertura_responsabili():
    df = _mart("ipa_unita_organizzative", "ipa_unita_organizzative_riepilogo")
    totale = int(df["n_uo"].sum())
    con_resp = int((df["n_uo"] * df["pct_con_responsabile"] / 100).sum())
    return {
        "totale_uo": totale,
        "con_responsabile": con_resp,
        "pct": con_resp / totale if totale > 0 else 0,
    }


@st.cache_data(ttl=3600, show_spinner=False)
def enti_in_liquidazione():
    df = _mart("ipa_enti", "ipa_enti_riepilogo")
    return int(df["in_liquidazione"].sum())


@st.cache_data(ttl=3600, show_spinner=False)
def vertici_per_titolo():
    df = _load_compose()
    return (
        df[df["vertice_ente_titolo"].notna()]
        .groupby("vertice_ente_titolo")
        .agg(n_enti=("codice_ipa", "nunique"))
        .reset_index()
        .sort_values("n_enti", ascending=False)
        .head(10)
    )


# -- Cerca Ufficio ------------------------------------------------------

@st.cache_data(ttl=3600, show_spinner=False)
def cerca_ufficio(search: str = "", ente: str = "", limit: int = 200) -> pd.DataFrame:
    df = _load_compose()
    if search:
        s = search.lower()
        mask = (
            df["descrizione_uo"].str.lower().str.contains(s, na=False)
            | df["uo_resp_nome"].str.lower().str.contains(s, na=False)
            | df["uo_resp_cognome"].str.lower().str.contains(s, na=False)
            | df["rtd_nome"].str.lower().str.contains(s, na=False)
            | df["rtd_cognome"].str.lower().str.contains(s, na=False)
        )
        df = df[mask]
    if ente:
        df = df[df["denominazione_ente"].str.lower() == ente.lower()]
    cols = [
        "denominazione_ente", "descrizione_uo", "uo_resp_nome", "uo_resp_cognome",
        "uo_resp_email", "uo_mail", "uo_tipo_mail", "denominazione_aoo",
        "rtd_nome", "rtd_cognome", "rtd_mail",
    ]
    return df[cols].head(limit)


@st.cache_data(ttl=3600, show_spinner=False)
def elenco_entite():
    df = _load_compose()
    return df[["denominazione_ente"]].drop_duplicates().sort_values("denominazione_ente")


# -- Scheda Ente --------------------------------------------------------

@st.cache_data(ttl=3600, show_spinner=False)
def scheda_ente(nome_ente: str) -> pd.DataFrame:
    df = _load_compose()
    return df[df["denominazione_ente"].str.lower() == nome_ente.lower()]


@st.cache_data(ttl=3600, show_spinner=False)
def info_ente(nome_ente: str) -> dict:
    df = _load_compose()
    row = df[df["denominazione_ente"].str.lower() == nome_ente.lower()].iloc[0] if not df[df["denominazione_ente"].str.lower() == nome_ente.lower()].empty else None
    if row is None:
        return {}
    return {
        "denominazione_ente": row.get("denominazione_ente", ""),
        "codice_ipa": row.get("codice_ipa", ""),
        "tipologia": row.get("tipologia", ""),
        "codice_categoria": row.get("codice_categoria", ""),
        "vertice_titolo": row.get("vertice_ente_titolo", ""),
        "vertice_nome": row.get("vertice_ente_nome", ""),
        "vertice_cognome": row.get("vertice_ente_cognome", ""),
        "sito": row.get("sito_istituzionale", ""),
        "n_uo": int(df[df["denominazione_ente"].str.lower() == nome_ente.lower()].shape[0]),
    }


# -- Trasformazione Digitale --------------------------------------------

@st.cache_data(ttl=3600, show_spinner=False)
def kpi_digitale():
    df_rtd = _mart("ipa_rtd", "ipa_rtd_riepilogo")
    df_sd = _mart("ipa_servizi_digitali", "ipa_servizi_digitali_riepilogo")
    df_su = _mart("ipa_servizi_uo", "ipa_servizi_uo_riepilogo")
    return {
        "enti_con_rtd": int(len(df_rtd)),
        "totale_rtd": int(df_rtd["n_rtd"].sum()),
        "enti_con_servizi_digitali": int(len(df_sd)),
        "totale_servizi_digitali": int(df_sd["n_servizi_digitali"].sum()),
        "enti_con_servizi_uo": int(len(df_su)),
        "totale_servizi_uo": int(df_su["n_servizi"].sum()),
    }


@st.cache_data(ttl=3600, show_spinner=False)
def top_enti_servizi_digitali(top_n=15):
    df = _mart("ipa_servizi_digitali", "ipa_servizi_digitali_riepilogo")
    return df[["denominazione_ente", "n_servizi_digitali", "n_tipologie", "pct_con_url"]].sort_values("n_servizi_digitali", ascending=False).head(top_n)


@st.cache_data(ttl=3600, show_spinner=False)
def tipologie_servizi_digitali():
    df = _mart("ipa_servizi_digitali", "ipa_servizi_digitali")
    return (
        df[df["tipologia_servizio"].notna()]
        .groupby("tipologia_servizio")
        .agg(n=("codice_ipa", "count"), n_enti=("codice_ipa", "nunique"))
        .reset_index()
        .sort_values("n", ascending=False)
        .head(15)
    )


@st.cache_data(ttl=3600, show_spinner=False)
def categorie_servizi_uo():
    df = _mart("ipa_servizi_uo", "ipa_servizi_uo")
    return (
        df[df["categoria_servizio"].notna()]
        .groupby("categoria_servizio")
        .agg(n=("codice_ipa", "count"), n_enti=("codice_ipa", "nunique"))
        .reset_index()
        .sort_values("n", ascending=False)
    )


@st.cache_data(ttl=3600, show_spinner=False)
def servizi_digitali_ente(nome_ente: str) -> pd.DataFrame:
    df = _mart("ipa_servizi_digitali", "ipa_servizi_digitali")
    return df[df["denominazione_ente"] == nome_ente][
        ["tipologia_servizio", "descrizione_servizio", "url_servizio"]
    ]


@st.cache_data(ttl=3600, show_spinner=False)
def servizi_uo_ente(nome_ente: str) -> pd.DataFrame:
    df = _mart("ipa_servizi_uo", "ipa_servizi_uo")
    return df[df["denominazione_ente"] == nome_ente][
        ["descrizione_uo", "categoria_servizio", "descrizione_servizio"]
    ]
