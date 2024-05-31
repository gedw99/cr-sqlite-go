# https://github.com/ebuckley/cr-sqlite-go

BASE_OS_NAME := $(shell go env GOOS)
BASE_OS_ARCH := $(shell go env GOARCH)

BIN_ROOT=$(PWD)/.bin
export PATH:=$(PATH):$(BIN_ROOT)

NAME=cr-sqlite-go
ifeq ($(BASE_OS_NAME),windows)
	NAME=cr-sqlite-go.exe
endif

print:
	@echo ""
	@echo "BASE_OS_NAME:   $(BASE_OS_NAME)"
	@echo "BASE_OS_ARCH:   $(BASE_OS_ARCH)"
	@echo ""

all: dep bin

dep:
	go install github.com/hashicorp/go-getter/cmd/go-getter@latest
	mv $(GOPATH)/bin/go-getter $(BIN_ROOT)

	# The version...
	# https://github.com/vlcn-io/cr-sqlite/releases/tag/v0.16.3

	## All the Mobiles.
	# ios arm64
	@echo "--- dep: ios ---"
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-ios-dylib.xcframework.tar.gz $(BIN_ROOT)/crsqlite_ios_arm64

	# android amr64
	@echo "--- dep: android ---"
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-aarch64-linux-android.zip $(BIN_ROOT)/crsqlite_android_arm64

	## All the Desktoops / Servers.

#ifeq ($(BASE_OS_NAME),darwin)
	@echo "--- dep: darwin ---"
	# darwin amd64
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-darwin-x86_64.zip $(BIN_ROOT)/crsqlite_darwin_amd64

	# darwin arm64
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-darwin-aarch64.zip $(BIN_ROOT)/crsqlite_darwin_arm64

#endif
#ifeq ($(BASE_OS_NAME),linux)
	@echo "--- dep: linux ---"

	# linux arm64
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-linux-aarch64.zip  $(BIN_ROOT)/crsqlite_windows_arm64
	
	# linux amd64
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-linux-x86_64.zip $(BIN_ROOT)/crsqlite_windows_amd64
#endif
#ifeq ($(BASE_OS_NAME),windows)
	@echo "--- dep: windows ---"

	# windows arm64
	# I raised a discussion to have one: https://github.com/vlcn-io/cr-sqlite/discussions/438
	#go-getter ?? THEX DONT HAVE OONE ??  $(BIN_ROOT)/crsqlite_windows_arm64
	
	# windows amd64
	go-getter https://github.com/vlcn-io/cr-sqlite/releases/download/v0.16.3/crsqlite-win-x86_64.zip $(BIN_ROOT)/crsqlite_windows_amd64
#endif


bin:
	cd cmd/server && go build -o $(BIN_ROOT)/$(NAME) .

run:
	$(NAME)
	# https://localhost:50051

