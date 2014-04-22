SRC = $(shell find src -name "*.ls" -type f | sort)
LIB = $(SRC:src/%.ls=lib/%.js)
LSC = /usr/local/bin/lsc
BROWSERIFY = node_modules/.bin/browserify

browser:
	mkdir browser/

callback-browser.js: $(LIB) browser
	{ $(BROWSERIFY) -r ./lib/index.js:callbacks-ls -u ./node_modules/prelude-ls/lib/index.js ; } > browser/callback-browser.js


promises-browser.js: $(LIB) browser
	{ $(BROWSERIFY) -r ./lib/promises.js:promises-ls -u ./node_modules/prelude-ls/lib/index.js -u ./node_modules/promise/index.js ; } > browser/promises-browser.js


promises-browser-with-promise.js: $(LIB) browser
	{ $(BROWSERIFY) -r ./lib/promises.js:promises-ls -u ./node_modules/prelude-ls/lib/index.js ; } > browser/promises-browser.js


async-browser.js: $(LIB) browser
	{ $(BROWSERIFY) -r ./lib/index.js:async-ls -u ./node_modules/prelude-ls/lib/index.js -u ./node_modules/promise/index.js ; } > browser/async-browser.js


test-browser.js: $(LIB) browser
	{ $(BROWSERIFY) -r ./test/ptest.js:test-promises-ls -u ./node_modules/prelude-ls/lib/index.js ; } > junk/browser/test-browser.js


lib:
	mkdir lib/

lib/%.js: src/%.ls lib
	$(LSC) --output lib --bare --compile "$<"

build: $(LIB)


clean:
	rm -rf lib
	rm -rf browser