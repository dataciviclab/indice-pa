# DataCivicLab — IndicePA Intelligence
# Anagrafe della Pubblica Amministrazione italiana

TOOLKIT = toolkit
PREFIX = indice-pa
YEARS = 2026

DATASETS := $(shell find datasets -name dataset.yml 2>/dev/null | sort)
COMPOSES := $(shell find compose -name dataset.yml 2>/dev/null | sort)

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ── Pipeline execution ────────────────────────────────────────────────────────

.PHONY: run
run: ## Run all datasets
	@for f in $(DATASETS); do \
		echo "=== $$f ==="; \
		$(TOOLKIT) run --config "$$f" --years $(YEARS) || exit 1; \
	done

.PHONY: run-compose
run-compose: ## Run compose (who-is-who-pa)
	@for f in $(COMPOSES); do \
		echo "=== $$f ==="; \
		$(TOOLKIT) run --config "$$f" --years $(YEARS) || exit 1; \
	done

.PHONY: run-all
run-all: run run-compose ## Run everything: datasets + compose

run-%: ## Run single dataset: make run-ipa-enti
	$(TOOLKIT) run --config datasets/$*/dataset.yml --years $(YEARS)

# ── Quality ───────────────────────────────────────────────────────────────────

.PHONY: check
check: ## Validate all configs
	@for f in $(DATASETS) $(COMPOSES); do \
		echo "→ $$f"; \
		$(TOOLKIT) run preflight --config "$$f" > /dev/null 2>&1 || exit 1; \
	done
	@echo "✅ All configs valid"

.PHONY: preflight
preflight: ## Check all dataset configs (verbose)
	@for f in $(DATASETS) $(COMPOSES); do \
		echo "→ $$f"; \
		$(TOOLKIT) inspect config --config "$$f" 2>&1 | head -3; \
	done

.PHONY: status
status: ## Show pipeline status
	@echo "=== Pipeline Status ==="
	@for ds in datasets/*/; do \
		name=$$(basename "$$ds"); \
		last_run=$$(ls -t out/data/_runs/$$name/*/ 2>/dev/null | head -1); \
		if [ -n "$$last_run" ]; then \
			status=$$(cat "out/data/_runs/$$name/$$last_run"/*.json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('status','?'))" 2>/dev/null || echo "?"); \
			echo "  $$name: $$status"; \
		else \
			echo "  $$name: no runs"; \
		fi \
	done

# ── Dashboard ─────────────────────────────────────────────────────────────────

.PHONY: dashboard
dashboard: ## Run Streamlit dashboard
	cd dashboard && streamlit run app.py

# ── Registry ──────────────────────────────────────────────────────────────────

.PHONY: registry registry-write
registry: ## Build registry (dry-run)
	$(TOOLKIT) registry build --prefix indice-pa

registry-write: ## Build and write registry
	$(TOOLKIT) registry build --prefix indice-pa --write

# ── Cleanup ───────────────────────────────────────────────────────────────────

.PHONY: clean
clean: ## Remove all output
	rm -rf out/data/_runs out/data/probe out/data/raw out/data/clean out/data/mart .tmp/

.PHONY: clean-runs
clean-runs: ## Remove only run logs
	rm -rf out/data/_runs/
