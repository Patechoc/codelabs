.SILENT: all clean build serve
OUT_DIR	:= docs
TUTO_MARKDOWN = $(shell find . -maxdepth 1 -mindepth 1 -name \*.md -a -not -name README.md -not -name index.md | xargs)

all: clean build serve

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

serve:
	echo ">> Serving your codelabs locally"; \
	cd $(OUT_DIR) && claat serve

clean:
	rm -rf $(OUT_DIR)
