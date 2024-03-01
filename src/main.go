package main

import (
	"flag"
	"time"

	h "github.com/juanjjaramillo/testbed/src/hello"
	u "github.com/juanjjaramillo/testbed/src/utils"
	"go.uber.org/zap"
)

type flagSet struct {
	debug      bool
	iterations int
	sleepSec   int
}

func main() {
	fs := parseFlags()
	log := setupLog(fs.debug)
	sugar := log.Sugar()
	sugar.Info(u.BuildTimeMetadata())
	logMessages(fs, sugar)
}

// ParseFlags is a proof of concept for parsing flags.
func parseFlags() *flagSet {
	var fs flagSet

	flag.BoolVar(&fs.debug, "debug", false,
		"sets log level to debug")
	flag.IntVar(&fs.iterations, "iterations", 1,
		"defines how many times to print log message, negative value means 'forever'")
	flag.IntVar(&fs.sleepSec, "sleepSec", 1,
		"defines how many seconds to sleep before printing next log message")

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

func logMessages(fs *flagSet, sugar *zap.SugaredLogger) {
	if fs.iterations < 0 {
		for {
			sugar.Info(h.Hello())
			time.Sleep(time.Duration(fs.sleepSec) * time.Second)
		}
	} else {
		for it := fs.iterations; it > 0; it-- {
			sugar.Info(h.Hello())
			time.Sleep(time.Duration(fs.sleepSec) * time.Second)
		}
	}
}
