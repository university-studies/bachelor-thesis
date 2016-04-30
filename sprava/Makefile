# makefile pro preklad LaTeX verze Bc. prace
# (c) 2008 Michal Bidlo
# E-mail: bidlom AT fit vutbr cz
#===========================================
# asi budete chtit prejmenovat:
#
# vlna -v KkSsVvZzOoUuAIai obsah.tex -o obsah.tex 
# pdftk sprava.pdf cat 2 41 44-47 49-50 output color.pdf
# pdftk sprava.pdf cat  3-40 42-43 48 50-end output black_white.pdf
CO=sprava

all: $(CO).pdf

pdf: $(CO).pdf

$(CO).ps: $(CO).dvi
	dvips $(CO)

$(CO).pdf: clean
	pdflatex $(CO)
	bibtex $(CO)
	pdflatex $(CO)
	pdflatex $(CO)

	

$(CO).dvi: $(CO).tex $(CO).bib
	latex $(CO)
	bibtex $(CO)
	latex $(CO)
	latex $(CO)

desky:
#	latex desky
#	dvips desky
#	dvipdf desky
	pdflatex desky

clean:
	rm -f *.dvi *.log $(CO).blg $(CO).bbl $(CO).toc *.aux $(CO).out $(CO).lof
	rm -f $(CO).pdf
	rm -f *~
	rm -f color.pdf black_white.pdf

pack:
	tar czvf bp-xjmeno.tar.gz *.tex *.bib *.bst ./fig/* ./cls/* Makefile Changelog

print:
	pdftk $(CO).pdf cat 2 41 44-47 49-50 output color.pdf
	pdftk $(CO).pdf cat  3-40 42-43 48 51-end output black_white.pdf

