RSCRIPT = Rscript --no-init-file


all: move rmd2md

move:
		cp inst/vign/ckanr.md vignettes/

rmd2md:
		cd vignettes;\
		mv ckanr.md ckanr.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"
		
