.SILENT: all clean build serve
OUT_DIR	:= docs
TUTO_MARKDOWN = $(shell find . -maxdepth 1 -mindepth 1 -name \*.md -a -not -name README.md -not -name index.md | xargs)

# `make build` generates codelabs
# without forcing the update of codelabs static content/dependencies
build: $(TUTO_MARKDOWN)
	echo ">> Export markdown tutorials as codelabs:"
	@- $(foreach TUTO,$^, \
		echo "- $(TUTO)"; \
		claat export --prefix "../" -o docs $(TUTO); \
	)
	echo ">> Jekyll configuration for index page copied to docs/"; \
	cp _config.yml index.md docs; \
	echo ">> Fetching codelabs dependencies: it may take some time!"; \
	cd  $(OUT_DIR) && claat build; \

# `make serve` starts a web server to serve
# the codelabs locally
serve:
	echo ">> Serving your codelabs locally"; \
	cd $(OUT_DIR) && claat serve

# `make clean` removes the output directory (i.e. /docs)
clean:
	rm -rf $(OUT_DIR)

all: clean build serve
