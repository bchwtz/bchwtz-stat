SOURCES=$(shell find . -name *.Rmd)
SOURCES := $(wildcard *.Rmd)
TARGETS=$(SOURCES:%.Rmd=%.pdf)
GIFTARGETS=$(SOURCES:%.Rmd=%.gif)

%.pdf: %.Rmd
	@echo "$< -> $@"
	@Rscript -e "rmarkdown::render('$<')"

%.gif: %.pdf
		@echo "$< -> $@"
		@mkdir -p gifs
		@convert -delay 250 -geometry 480x360 '$<'[0-25] gifs/$@
	
default: $(TARGETS)

gif: $(GIFTARGETS)

clean:
	rm -rf $(TARGETS)
	rm -rf *_cache
	rm -rf *_files
	rm -rf *.log

clean-cache:
	rm -rf *_cache
	rm -rf *_files
	rm -rf *.log