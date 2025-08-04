TARGET=evilginx
PACKAGES=core database log parser

.PHONY: all build clean
all: build

build:
	@go build -o ./$(TARGET) -mod=vendor main.go

clean:
	@go clean
	@rm -f ./$(TARGET)
