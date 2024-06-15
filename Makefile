# Makefile
start: # start server
	docker-compose up --build

stop: # stop server
	docker-compose down

ps: # show containers
	docker ps