# Performance Web #

Not a course per ser but usefull infra (frontend) courses:

- [Performance Web I: otimizando o front-end](https://cursos.alura.com.br/course/otimizacao-performance-web "otimizacao-performance-web_performance-http2-critical-path")
- [Performance Web II: Critical Path, HTTP/2 e Resource Hints](https://cursos.alura.com.br/course/performance-http2-critical-path "otimizacao-performance-web_performance-http2-critical-path")

- [Alura's reference repository](https://github.com/alura-cursos/performance-web/tree/79fd747 "initial checkout to start")

## Minify ##

- [Broken link refresh-sf](https://refresh-sf.com/)

## Brotli ##

- [Introducing Brotli: a new compression algorithm for the internet](https://opensource.googleblog.com/2015/09/introducing-brotli-new-compression.html)
- [The current state of Brotli compression](https://samsaffron.com/archive/2016/06/15/the-current-state-of-brotli-compression)
- [Broken link](https://blogs.akamai.com/2016/02/understanding-brotlis-potential.html)

## Image Optimization ##

- [kraken.io](https://kraken.io)
- [tinypng.com](https://tinupng.com)
- [ImageOptim](https://imageoptim,com)
- [Riot](https://luci.criosweb.ro/riot)
- [jpegtran](jpegclub.org/jpegtran)
- [svgomg](https://jakearchibald.github.io/svgomg/)
- [jpegmini](http://www.jpegmini.com/)
- [mozpeg](https://github.com/mozilla/mozjpeg "https://imageoptim.com/mozjpeg")
- [pngnq](https://sourceforge.net/projects/pngnqs9/)
- [pngquant](https://pngquant.org/)
- [ZorroSVG](http://quasimondo.com/ZorroSVG/)
- [pngthermal](https://encode.su/threads/1725-pngthermal-pseudo-thermal-view-of-PNG-compression-efficiency)
- [PNG Compression: 5 simple improvements](http://mainroach.blogspot.com.br/2013/09/png-compression-5-simple-improvements.html)

### Google Colt McAnlis ###

- [How PNG Works](https://medium.com/@duhroach/how-png-works-f1174e3cc7b7#.2yg9ubs65)
- [Reducing PNG File Size](https://medium.com/@duhroach/reducing-png-file-size-8473480d0476#.mppiv8hlt)
- [How JPEG Works](https://medium.freecodecamp.com/how-jpg-works-a4dbd2316f35#.ub10z8v81)
- [Reducing JPEG File Size](https://medium.com/@duhroach/reducing-jpg-file-size-e5b27df3257c#.c21b9p1vi)

## Web Page Test ##

- [Web Page Test](http://www.webpagetest.org/)
- [Page Speed Insights](https://developers.google.com/speed/pagespeed/insights/?hl=pt-BR)

## Image Sprites ##

- [Image Magick](https://imagemagick.org)
- [Sprite Smith](https://github.com/spritesmith)
- [sprity](https://npmjs.com/package/sprity)
- [SVG Sprite](https://github.com/jkphl/svg-sprite)
- [SVG for Everybody - sprites do not work in old browsers](https://jonneal.dev/svg4everybody/)

## Inline Resources ##

Hint: use until 14KB (10 TCP's window) each request.

gulp useref should have inline property into script/img tag.
<script inline src="assets/js/home.js"></script>
<img inline src="assets/img/logo-alura.svg" alt="Alura">
Also can be used Data URI to include binary of images (png/jpg) inline.

## Paralell Requests ##

Add a new site to host some resource that can be downloaded in paralell. Maybe use a cdn to delivery some assets.

## Cache HTTP ##

Cache-control can be [public|private] 

- [WPO Stats](https://wpostats.com)
