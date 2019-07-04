RSCRIPT = Rscript --no-init-file


all: move rmd2md

move:
		cp inst/vign/ckanr_vignette.md vignettes/

rmd2md:
		cd vignettes;\
		mv ckanr_vignette.md ckanr_vignette.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"
		
