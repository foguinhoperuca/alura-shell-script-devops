.PHONY: minify

class_01:
	nvm install 11
	nvm use 11
	npm install -g gulp gulp-cli
	cd original_repos
	npm install
	gulp copy minifyjs

class_02:
	npm install -g svgo
	mogrify -resize 50x50 original_repos/site/assets/img/aluno-*
	gulp imagemin

# Manually convert
	jpegtran -progressive -optimize original_repos/site/assets/img/aluno-adriano.jpeg > dist/assets/img/aluno-adriano.jpeg
	pngcrush original_repos/site/assets/img/icon-diferencial-1.png dist/assets/img/icon-diferencial-1.png
	svgo original_repos/site/assets/img/categoria-business.svg dist/assets/img/categoria-business.svg

class 05:
	convert site/assets/img/*.png --append site/assets/img/diferencials.png
	npm install -g sprity-cli
	sprity create /tmp site/assets/img/icon-*.png -s sprite.css
# Rebuild project after changes
	gulp imagemin
	gulp minify
	gulp useref

class 08:
	gulp revreplace
