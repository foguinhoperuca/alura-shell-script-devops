PHONY: php-server

php-server:
	php -S localhost:8000

php_server:
	cd fast_cgi
	docker run --rm -it -p 9000:9000 -v $(pwd):/fast_cgi php:fpm
