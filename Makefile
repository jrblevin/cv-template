# $Id: Makefile,v 1.3 2004/05/31 22:36:52 jrblevin Exp $

###########################################################################
## BEGIN CONFIGURATION SECTION

# Project base filename where your main tex file is $(BASENAME).tex
BASENAME = cv-us

# Any supporting files needed to compile $(BASENAME).tex such as
# included tex files or figures
SUPPORTS = cv-us.html

# Uncomment the next two lines if you wish to use bibtex.  These lines
# assume the bib file is $(BASENAME).bib.  Modify if needed.
BIBFILE = #$(BASENAME).bib
BBLFILE = #$(BASENAME).bbl

# Program locations and options
LATEX = latex
LATEXFLAGS = -interaction=nonstopmode
BIBTEX = bibtex
PDFLATEX = pdflatex
DVIPS = dvips
ACROREAD = acroread

## END CONFIGURATION SECTION
###########################################################################


DISTFILES = *.aux *.log *~ *.blg *.bbl *.dvi *.toc
CLEANFILES = $(DISTFILES) *.ps *.pdf *.zip

SNAPFILES = Makefile *.tex $(BASENAME).ps $(BASENAME).pdf $(BASENAME).dvi
ZIPFILES = $(SUPPORTS) $(BASENAME).tex $(BASENAME).bib $(BASENAME).ps \
	$(BASENAME).pdf

RCSFILES = $(BASENAME).tex $(SUPPORTS) Makefile

######################################################################

all: $(BASENAME).dvi $(BASENAME).ps $(BASENAME).pdf

$(BASENAME).aux: $(BASENAME).tex $(SUPPORTS) $(BIBFILE)
	$(LATEX) $(LATEXFLAGS) $(BASENAME).tex

$(BASENAME).bbl: $(BASENAME).tex $(BIBFILE) $(BASENAME).aux
	$(BIBTEX) $(BASENAME).aux

$(BASENAME).dvi: $(BASENAME).tex $(BASENAME).aux $(BBLFILE) $(BIBFILE)
	$(LATEX) $(LATEXFLAGS) $(BASENAME).tex
	$(LATEX) $(LATEXFLAGS) $(BASENAME).tex

$(BASENAME).ps: $(BASENAME).dvi
	$(DVIPS) $(BASENAME).dvi -o $@

$(BASENAME).pdf: $(BASENAME).tex #$(BASENAME).aux $(BIBFILE) $(BBLFILE)
	pdflatex -interaction=nonstopmode $(BASENAME).tex

clean:
	-rm -f $(CLEANFILES)

distclean:
	-rm -f $(DISTFILES)

snap: 
	-mkdir -p snapshots
	-mkdir `date +%Y%m%d`
	cp -R $(SNAPFILES) `date +%Y%m%d`
	tar zcvf snapshots/$(BASENAME).`date +%Y%m%d`.tar.gz `date +%Y%m%d`
	rm -rf `date +%Y%m%d`

zip:
	-rm -f $(BASENAME).zip
	zip $(BASENAME).zip $(ZIPFILES)

ci: $(RCSFILES)
	$(shell for i in $(RCSFILES) ; do ci -u $$i ; done)

co: $(RCSFILES)
	$(shell for i in $(RCSFILES) ; do co -l $$i ; done)

preview: $(BASENAME).pdf
	$(ACROREAD) $(BASENAME).pdf &
