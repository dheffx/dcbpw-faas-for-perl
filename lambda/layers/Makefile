IMAGE_NAME 	:= perl-lambda
VERSION 		?= 0.0.1
DIST_DIR 		?= $(PWD)/dist

.PHONY: build export package publish

build:
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION)

clean:
	rm -rf $(DIST_DIR)

export: clean
	mkdir -p $(DIST_DIR)
	docker run --rm -v$(DIST_DIR):/zips $(IMAGE_NAME):$(VERSION)

package: build export

publish: publish-runtime publish-paws
# publish-%:
#   aws lambda publish-layer-version \
# 		--layer-name perl-${*}-$(VERSION) \
# 		--zip-file fileb:///$(DIST_DIR)/perl-${*}.zip

# publish-base:
# 	  aws lambda publish-layer-version \
# 			--layer-name perl-base \
# 			--zip-file fileb:///$(DIST_DIR)/perl-base.zip

publish-paws:
	  aws lambda publish-layer-version \
			--layer-name perl-paws \
			--zip-file fileb:///$(DIST_DIR)/perl-paws.zip

publish-runtime:
	  aws lambda publish-layer-version \
			--layer-name perl-runtime \
			--zip-file fileb:///$(DIST_DIR)/perl-runtime.zip