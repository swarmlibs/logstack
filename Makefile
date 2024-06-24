docker-stack-name = test_prometheus

it:
	@echo "make [deploy|remove|clean|reset] docker-stack-name=$(docker-stack-name)"

networks:
	@docker network create --scope=swarm --driver=overlay --attachable dockerswarm_ingress > /dev/null 2>&1 || true
	@docker network create --scope=swarm --driver=overlay --attachable logstack_gwnetwork > /dev/null 2>&1 || true

deploy: networks
	$(MAKE) -C promtail deploy
	$(MAKE) -C grafana-loki deploy

remove:
	$(MAKE) -C promtail remove
	$(MAKE) -C grafana-loki remove

clean:
	$(MAKE) -C promtail clean
	$(MAKE) -C grafana-loki clean

reset: remove wait clean deploy

wait:
	@echo "Waiting for previous recipe to finish..."
	@sleep 20
