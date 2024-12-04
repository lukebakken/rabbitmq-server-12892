#!/bin/sh

docker compose exec rabbit rabbitmqadmin --base-uri=http://localhost:15672 --username=admin --password=guest --vhost=/ declare exchange name=exchange.demo type=fanout durable=true 
docker compose exec upstream4WoPlugins rabbitmqadmin --base-uri=http://localhost:15672 --username=admin --password=guest --vhost=/ declare exchange name=exchange.demo type=fanout durable=true
docker compose exec upstream4WithPlugins rabbitmqadmin --base-uri=http://localhost:15672 --username=admin --password=guest --vhost=/ declare exchange name=exchange.demo type=fanout durable=true
docker compose exec upstream3WoPlugins rabbitmqadmin --base-uri=http://localhost:15672 --username=admin --password=guest --vhost=/ declare exchange name=exchange.demo type=fanout durable=true

docker compose exec rabbit rabbitmqctl set_parameter federation-upstream conn4-wo-plugins '{"uri":"amqp://admin:guest@upstream4WoPlugins:5672", "exchange": "exchange.demo"}'
docker compose exec rabbit rabbitmqctl set_policy federate4-wo-demo "^exchange.demo$" '{"federation-upstream-set":"all"}' --apply-to exchanges

docker compose exec rabbit rabbitmqctl set_parameter federation-upstream conn4-with-plugins '{"uri":"amqp://admin:guest@upstream4WithPlugins:5672", "exchange": "exchange.demo"}'
docker compose exec rabbit rabbitmqctl set_policy federate4-with-demo "^exchange.demo$" '{"federation-upstream-set":"all"}' --apply-to exchanges

docker compose exec rabbit rabbitmqctl set_parameter federation-upstream conn3-wo-plugins '{"uri":"amqp://admin:guest@upstream3WoPlugins:5672", "exchange": "exchange.demo"}'
docker compose exec rabbit rabbitmqctl set_policy federate3-wo-demo "^exchange.demo$" '{"federation-upstream-set":"all"}' --apply-to exchanges
