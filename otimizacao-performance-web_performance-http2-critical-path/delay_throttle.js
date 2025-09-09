(function(){

    // controle do throttle
    var jarodei = false;

    // pega todas as imagens num array e pre-calcula seu topo
    var imgs = document.querySelectorAll('img[data-src]:not([src])');
    var cache = [];
    for (var i = 0; i < imgs.length; i++) {
        cache.push({
            topo: imgs[i].getBoundingClientRect().top + pageYOffset,
            elemento: imgs[i]
        });
    }

    // cache da altura da janela
    var alturaJanela = window.innerHeight;

    window.addEventListener('scroll', function scrollListener() {

        // throttle
        if (jarodei) return;
        jarodei = true;
        setTimeout(function () { 
            jarodei = false; 
        }, 100);

        // meu while n?o toca no DOM, observa apenas vari?veis cacheadas e o pageYOffset.
        // s? manipulo o DOM quando preciso realmente mexer na imagem.
        while (cache.length && cache[0].topo < pageYOffset + alturaJanela + 200) {
            var img = cache.shift().elemento;
            img.src = img.getAttribute('data-src');
        }

        // removo o onscroll se n?o precisar mais dele
        if (cache.length == 0) {
            window.removeEventListener('scroll', scrollListener);
        }

    });

})();

// Another option: https://gist.github.com/sergiolopes/e326e62a44c8095021d443401dcf5320
(function(){

	// como vamos usar o throttle varias vezes (no scroll e no resize), 
	// encapsulei essa funcionalidade numa fun??o
	function throttle(fn) {
		fn.jarodei = false;
		
		return function(){
			if (fn.jarodei) return;
			fn.jarodei = true;
			setTimeout(function () { 
				fn.jarodei = false; 
			}, 200);

			fn();	
		};
	}

	// pega todas as imagens num array e pre-calcula seu topo
	var imgs = document.querySelectorAll('img[data-src]:not([src])');
	var cache, alturaJanela, scrollListener, resizeListener;

	function refazCache() {
		cache = [];

		// calcula os topos no cache
		for (var i = 0; i < imgs.length; i++) {
			cache.push({
				topo: imgs[i].getBoundingClientRect().top + pageYOffset,
				elemento: imgs[i]
			});
		}

		// ordena o cache pela imagem mais proxima do topo
		cache = cache.sort(function(a,b){
			return a.topo - b.topo;
		});

		// cache da altura da janela
		alturaJanela = window.innerHeight;
	}

	function carregaImagens() {
		// meu while n?o toca no DOM, observa apenas vari?veis cacheadas e o pageYOffset.
		// s? manipulo o DOM quando preciso realmente mexer na imagem.
		while (cache.length && cache[0].topo < pageYOffset + alturaJanela + 200) {
			var img = cache.shift().elemento;
			img.src = img.getAttribute('data-src');
		}

		// removo eventos se n?o precisar mais deles
		if (cache.length == 0) {
			window.removeEventListener('scroll', scrollListener);
			window.removeEventListener('resize', resizeListener);
		}
	}

	// roda primeira vez
	refazCache();
	carregaImagens();

	// onresize refazCache e carrega eventuais imagens
	window.addEventListener('resize', resizeListener = throttle(function() {
		refazCache();
		carregaImagens();
	}));

	// onscroll s? carrega imagens
	window.addEventListener('scroll', scrollListener = throttle(carregaImagens));

})();
