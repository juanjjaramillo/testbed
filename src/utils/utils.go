// Package utils implements miscellaneous utility functions
package utils

import "fmt"

var (
	commit  = "N/A"
	date    = "N/A"
	version = "N/A"
)

// BuildTimeMetadata records metadata available during compile time
func BuildTimeMetadata() string {
	return fmt.Sprintf("Version: %v Commit: %v Date: %v", version, commit, date)
}
