package main

import (
	"os"
	"path/filepath"
	"runtime"
	"sync"

	"github.com/ebuckley/crsqlite-go/crsql"
)

var schema = `
create table if not exists note (id primary key not null, title, body);
select crsql_as_crr('note');
`
var setup = sync.OnceFunc(func() {
	ex, err := os.Executable()
	if err != nil {
		panic(err)
	}
	exPath := filepath.Dir(ex)

	// Match structure of the .bin path.

	crsql.Register(filepath.Join(exPath, "crsqlite_"+runtime.GOOS+"_"+runtime.GOARCH, "crsqlite"))
})

func newSyncService() (*crsql.SyncService, error) {
	setup()
	db, err := crsql.New(":memory:", schema)
	if err != nil {
		return nil, err
	}
	return &crsql.SyncService{DB: db, Schema: schema}, nil
}
