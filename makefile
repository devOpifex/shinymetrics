check: document
	Rscript -e "devtools::check()"

document: site
	Rscript -e "devtools::document()"

site: cp
	Rscript -e "pkgdown::build_site()"

install: check 
	Rscript -e "devtools::install()"

run: install
	Rscript inst/test/app.R

test: install
	Rscript inst/test/app.R

test-nav: install
	Rscript inst/test/nav.R

test-bs4: install
	Rscript inst/test/bs4Dash.R

cp:
	cp -f ~/Golang/src/github.com/devOpifex/shinymetrics.js/dist/shinymetrics.min.js ~/Golang/src/github.com/devOpifex/shinymetrics/inst/assets/
	cp -f ~/Golang/src/github.com/devOpifex/shinymetrics.js/dist/shinymetrics.min.css ~/Golang/src/github.com/devOpifex/shinymetrics/inst/assets/
