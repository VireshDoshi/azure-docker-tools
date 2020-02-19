# all our targets are phony (no files to check).
.PHONY: help build 


help:
	@echo 'Usage:'
	@echo '  make <target>'
	@echo 
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo


bump: 	## Build the dockertools image and push to dockerhub
	@docker run --rm -v $(PWD):/app treeder/bump patch

tag: 	## Tag the build
	@cat VERSION
	@docker tag vireshdoshi/azuretools:latest vireshdoshi/azuretools:`cat VERSION`

build:	## Build
	@docker build -t vireshdoshi/azuretools:latest .

push: tag	## push docker tools image to dockerhub
	@docker push vireshdoshi/azuretools:latest
	@docker push vireshdoshi/azuretools:`cat VERSION`

