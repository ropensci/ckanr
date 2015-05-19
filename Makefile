all: move rmd2md

move:
		cp inst/vign/ckanr_vignette.md vignettes/

rmd2md:
		cd vignettes;\
		mv ckanr_vignette.md ckanr_vignette.Rmd
