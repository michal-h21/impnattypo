CTANUPLOAD=ctanupload

CONTRIBUTION  = impnattypo
VERSION       = v1.0
SUMMARY       = Recommendations typographiques de l'Imprimerie Nationale Française
NAME          = Raphaël Pinson
EMAIL         = raphink@gmail.com
DIRECTORY     = /macros/latex/contrib/$(CONTRIBUTION)
DONOTANNOUNCE = 0
LICENSE       = free
FREEVERSION   = lppl
FILE          = $(CONTRIBUTION).tar.gz

SOURCEFILES   = $(CONTRIBUTION).dtx $(CONTRIBUTION).ins
PKGFILES      = $(CONTRIBUTION).sty
DOCFILES      = $(CONTRIBUTION).pdf

TEXINSTALLDIR = /usr/local/texlive/texmf-local

export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE

# default rule
ctanify: $(FILE)

$(FILE): README $(SOURCEFILES) $(DOCFILES) $(PKGFILES)
	ctanify --pkgname $(CONTRIBUTION) $^

%.sty: %.dtx %.ins
	latex $*.ins

%.pdf: %.tex
	lualatex -interaction=batchmode $<
	lualatex -interaction=batchmode $<

$(CONTRIBUTION).pdf: $(CONTRIBUTION).sty
	lualatex -interaction=batchmode $(CONTRIBUTION).dtx
	makeindex -s gind.ist $(CONTRIBUTION).idx
	makeindex -s gglo.ist -o $(CONTRIBUTION).gls $(CONTRIBUTION).glo
	lualatex -interaction=batchmode $(CONTRIBUTION).dtx

upload: ctanify
	$(CTANUPLOAD) -p

%.tds.zip: %.tar.gz
	tar xzf $< $@

install: $(CONTRIBUTION).tds.zip
	unzip $< -d $(TEXINSTALLDIR)
	mktexlsr

test: $(CONTRIBUTION)-test.pdf

clean:
	rm -f *.aux *.glo *.idx *.log
	rm -f $(DOCFILES) $(PKGFILES)
	rm -f $(FILE)

