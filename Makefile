.PHONY: run-pigeon
run-pigeon:
	sh scripts/run-pigeon.sh

.PHONY: format
format:
	flutter format lib example/lib example/integration_test;
	swiftlint --fix ios;
	cd example/android; ./gradlew ktlintFormat

###
### Codegen targets
###
.PHONY: generate-config-templates
generate-config-templates:
	cd codegen && \
	npm install && \
	node map-serialization-generator/generate-configurations-code.js

.PHONY: generate-annotation-templates
generate-annotation-templates:
	cd codegen && \
	npm install && \
	node annotation-generator/generate-annotation-code.js

.PHONY: generate-style-code
generate-style-code:
	cd codegen && \
	npm install && \
	node style-generator/generate-style-code.js

.PHONY: generate-api-docs
generate-api-docs:
	dart doc .