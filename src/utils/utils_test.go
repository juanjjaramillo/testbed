package utils

import "testing"

func TestBuildTimeMetadata(t *testing.T) {
	expected := "Version: N/A Commit: N/A Date: N/A"
	if got := BuildTimeMetadata(); got != expected {
		t.Errorf("BuildTimeMetadata(): got %q, expected %q", got, expected)
	}
}
