package main

import (
	"flag"
	h "github.com/juanjjaramillo/testbed/src/hello"
	u "github.com/juanjjaramillo/testbed/src/utils"
	"go.uber.org/zap"
)

type flagSet struct {
	debug bool
}

func main() {
	f := parseFlags()
	log := setupLog(f.debug)
	sugar := log.Sugar()
	sugar.Info(u.BuildTimeMetadata())
	sugar.Info(h.Hello())
}

// ParseFlags is a proof of concept for parsing flags.
func parseFlags() *flagSet {
	var fs flagSet
	flag.BoolVar(&fs.debug, "debug", false, "sets log level to debug")
	flag.Parse()
	return &fs
}

// SetupLog shows a basic example on how to setup
// package zap to do structured, leveled logging in Go.
func setupLog(debug bool) (logger *zap.Logger) {
	if debug {
		logger, _ = zap.NewDevelopment()
	} else {
		logger, _ = zap.NewProduction()
	}
	defer logger.Sync() //nolint:errcheck

	return logger
}
