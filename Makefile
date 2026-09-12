.PHONY: build test app install run clean

build:
	swift build

test:
	./scripts/test.sh

app:
	./scripts/build-app.sh

install:
	./scripts/install.sh

run:
	swift run OpenLogiSpotlight

clean:
	swift package clean
