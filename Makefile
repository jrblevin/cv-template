# $Id: Makefile,v 1.6 2005/01/08 21:28:01 jrblevin Exp $
###############################################################################
# LaTeX Makefile for curriculum vitae template cv-us.tex
# Copyright (C) 2003-2004 Jason Blevins <jrblevin@sdf.lonestar.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###############################################################################
# Note:
#   The GNU GPL license only applies to this Makefile.  The content of
#   the curriculum vitae cv-us.tex remains copyright the author.
#   You may not reuse the content in part or whole, however you may use
#   the source code as a template for your own CV.
#
###############################################################################
# Configuration Section
# This should be the only section you need to modify

# Project base filename where your main tex file is $(BASENAME).tex
BASENAME = cv-us

# Any supporting files needed to compile $(BASENAME).tex such as
# included tex files or figures
SUPPORTS = 

# Other files that will be included in an archive
OTHER_FILES = cv-us.html cv-us.txt

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
DVIPSFLAGS = -t letter

ACROREAD = acroread
XDVI = xdvi
GGV = ggv

###############################################################################
# File lists

DISTFILES = *.aux *.log *~ *.blg *.bbl *.dvi *.toc
CLEANFILES = $(DISTFILES) *.ps *.pdf *.zip *.tar.gz

TEMPLATE_FILES = Makefile $(BASENAME).tex COPYING

# Website

WEBSITE_FILES = $(BASENAME).ps $(BASENAME).pdf cv-template.tar.gz \
	$(OTHER_FILES) Makefile $(BASENAME).tex

WEBSITE_PATH = /home/jrblevin/data/web/duke/content/cv/

###############################################################################
# Build rules

all: $(BASENAME).dvi $(BASENAME).ps $(BASENAME).pdf

preview: $(BASENAME).dvi
	$(XDVI) $(BASENAME).dvi &

$(BASENAME).aux: $(BASENAME).tex $(SUPPORTS) $(BIBFILE)
	$(LATEX) $(LATEXFLAGS) $(BASENAME).tex

$(BASENAME).bbl: $(BASENAME).tex $(BIBFILE) $(BASENAME).aux
	$(BIBTEX) $(BASENAME).aux

$(BASENAME).dvi: $(BASENAME).tex $(BASENAME).aux $(BBLFILE) $(BIBFILE)
	$(LATEX) $(LATEXFLAGS) $(BASENAME).tex
	$(LATEX) $(LATEXFLAGS) $(BASENAME).tex

$(BASENAME).ps: $(BASENAME).dvi
	$(DVIPS) $(BASENAME).dvi -o $@ $(DVIPSFLAGS)

$(BASENAME).pdf: $(BASENAME).tex #$(BASENAME).aux $(BIBFILE) $(BBLFILE)
	pdflatex -interaction=nonstopmode $(BASENAME).tex

###############################################################################
# Archive rules

archive: cv-template.tar.gz

cv-template.tar.gz: $(TEMPLATE_FILES)
	-mkdir cv-template
	cp $(TEMPLATE_FILES) cv-template
	tar zcvf cv-template.tar.gz cv-template
	-rm -rf cv-template

###############################################################################
# Website Rules

website: $(WEBSITE_FILES)
	cp -avf $(WEBSITE_FILES) $(WEBSITE_PATH)

###############################################################################
# Clean-up rules

clean:
	-rm -f $(CLEANFILES)

distclean:
	-rm -f $(DISTFILES)


###############################################################################
# No longer used

# For RCS check-in and -out (Now under CVS control in a larger module)
RCSFILES = $(BASENAME).tex $(SUPPORTS) Makefile $(OTHER_FILES) \
	$(BASENAME).pdf $(BASENAME).ps cv-template.tar.gz

ci: $(RCSFILES)
	$(shell for i in $(RCSFILES) ; do ci -u $$i ; done)

co: $(RCSFILES)
	$(shell for i in $(RCSFILES) ; do co -l $$i ; done)

# For archiving snapshots of the code (Moved to RCS, then CVS)
SNAPFILES = Makefile *.tex $(BASENAME).ps $(BASENAME).pdf $(BASENAME).dvi

snap: 
	-mkdir -p snapshots
	-mkdir `date +%Y%m%d`
	cp -R $(SNAPFILES) `date +%Y%m%d`
	tar zcvf snapshots/$(BASENAME).`date +%Y%m%d`.tar.gz `date +%Y%m%d`
	rm -rf `date +%Y%m%d`

# Used to make a distributable zip file
ZIPFILES = $(SUPPORTS) $(BASENAME).tex $(BIBFILE) $(BASENAME).ps \
	$(BASENAME).pdf $(OTHER_FILES)

zip: $(ZIPFILES)
	-rm -f $(BASENAME).zip
	zip $(BASENAME).zip $(ZIPFILES)

###############################################################################
