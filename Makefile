# Makefile for LaTeX Curriculum Vitae
#
# Jason Blevins <jrblevin@sdf.lonestar.org>
# Durham, December 12, 2006

CV = cv-us

LATEX = latex
LATEXFLAGS = -interaction=nonstopmode
BIBTEX = bibtex
PDFLATEX = pdflatex
DVIPS = dvips
DVIPSFLAGS = -t letter

DISTFILES = *.aux *.log *~ *.blg *.bbl *.dvi *.toc
CLEANFILES = $(DISTFILES) *.ps *.pdf *.zip *.tar.gz
TEMPLATE_FILES = Makefile $(CV).tex

all: $(CV).pdf

$(CV).pdf: $(CV).tex
	$(PDFLATEX) $(LATEXFLAGS) $(CV).tex

archive: cv-template.tar.gz

cv-template.tar.gz: $(TEMPLATE_FILES)
	-mkdir cv-template
	cp $(TEMPLATE_FILES) cv-template
	tar zcvf cv-template.tar.gz cv-template
	-rm -rf cv-template

clean:
	-rm -f $(CLEANFILES)

distclean:
	-rm -f $(DISTFILES)
