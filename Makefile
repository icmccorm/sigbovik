BIBTEX := bibtex
CLEAN := git clean
CP := cp
GS := ghostscript
TEX := pdflatex

REVIEWS := $(subst .tex,.pdf,$(wildcard reviews/SIGBOVIK_2019_*))

proceedings.pdf: main-matter.pdf
	$(GS) -sOutputFile=$@ -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH $<

main-matter.pdf: titlepage.pdf copyright-page.pdf $(REVIEWS) papers.tex
titlepage.pdf: TEX := xelatex

.PHONY: clean
clean:
	$(CLEAN) -fX

%.pdf: %.tex
	cd $(shell dirname $<) && \
		$(TEX) $(shell basename $<)
	grep '^\\citation' $(subst .tex,.aux,$(filter %.tex,$^)) >/dev/null && $(BIBTEX) $* || true
	cd $(shell dirname $<) && \
		$(TEX) $(shell basename $<)
	cd $(shell dirname $<) && \
		$(TEX) $(shell basename $<)
