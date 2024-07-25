
DOCKER_STACK_CONFIG := docker stack config
DOCKER_STACK_CONFIG_ARGS := --skip-interpolation

.EXPORT_ALL_VARIABLES:
include .dockerenv

make:
	@echo "Usage: make [deploy|remove|clean]"
	@echo "  deploy: Deploy the stack"
	@echo "  remove: Remove the stack"
	@echo "  clean: Clean up temporary files"

define docker-stack-config
$(1)/docker-stack.yml:
	$(DOCKER_STACK_CONFIG) -c $1/docker-stack.tmpl.yml > $1/docker-stack-config.yml
	@sed "s|$(PWD)/$1/|./|g" $1/docker-stack-config.yml > $1/docker-stack.yml
endef

$(eval $(call docker-stack-config,grafana-loki))
$(eval $(call docker-stack-config,promtail))

docker-stack.yml:
	$(DOCKER_STACK_CONFIG) $(DOCKER_STACK_CONFIG_ARGS) \
		-c grafana-loki/docker-stack-config.yml \
		-c promtail/docker-stack-config.yml \
	> docker-stack.yml.tmp
	@sed "s|$(PWD)/|./|g" docker-stack.yml.tmp > docker-stack.yml
	@rm docker-stack.yml.tmp
	@rm **/docker-stack-config.yml

compile: \
	grafana-loki/docker-stack.yml \
	promtail/docker-stack.yml \
	docker-stack.yml

print:
	$(DOCKER_STACK_CONFIG) -c docker-stack.yml

clean:
	@rm -rf docker-stack.yml || true
	@rm -rf docker-stack.yml.tmp || true
	@rm -rf **/docker-stack.yml || true
	@rm -rf **/docker-stack-config.yml || true

deploy: compile stack-networks stack-deploy
remove: stack-remove

stack-networks:
	docker network create --scope=swarm --driver=overlay --attachable logstack_gwnetwork || true
	docker network create --scope=swarm --driver=overlay --attachable prometheus_gwnetwork || true
stack-deploy:
	docker stack deploy --detach --prune -c docker-stack.yml logstack
stack-remove:
	docker stack rm logstack
