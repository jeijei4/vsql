module vsql

// import database.sql
import dialect.pg

pub type CreateTableFn = fn (table Table)

// create database
pub fn (db &DB) create_database(name string) {
	create_stmt := CreateDatabase{
		db_name: name
	}
	db.stmt = create_stmt
	db.end()
}

// create table
// status: wip
pub fn (db &DB) create_table(table_name string, create_table_fn CreateTableFn) ?[]pg.Row {
	mut table := Table{
		name: table_name
	}
	create_table_fn(table)
	s := table.gen()
	println(s)
	res := db.exec(s)
	return res
}

// create table if not exists
// status: wip
pub fn (db &DB) create_table_if_not_exist(table_name string, create_table_fn CreateTableFn) ?[]pg.Row {
	if db.has_table(table_name) {
		println('table $table_name is already exists')
	} else {
		return db.create_table(table_name, create_table_fn)
	}
}

// alter table
// status: wip
pub fn (db &DB) alter_table() &DB {
	return db
}

// rename table
// status:done
pub fn (db &DB) rename_table(old_name, new_name string) []pg.Row {
	rename_stmt := RenameTable{
		old_name: old_name
		new_name: new_name
	}
	db.stmt = rename_stmt
	return db.end()
}

// drop table
// status:done
pub fn (db &DB) drop_table(name string) []pg.Row {
	drop_stmt := DropTable{
		table_name: name
	}
	db.stmt = drop_stmt
	return db.end()
}

// drop table
// status:done
pub fn (db &DB) drop_table_if_exist(name string) []pg.Row {
	if db.has_table(name) {
		return db.drop_table(name)
	}
}

// has
// staut:wip
// only pg is ok
pub fn (db &DB) has_table(name string) bool {
	mut s := ''
	match db.config.client {
		'pg' {
			s = "select count(*) from information_schema.tables where table_schema=\'public\' and  table_name =\'$name\'"
		}
		'mysql' {
			// todo
		}
		'sqlite' {
			// todo
		}
		else {
			panic('unknown database client')
		}
	}
	res := db.exec(s)
	if res[0].vals[0] == '1' {
		return true
	} else {
		return false
	}
}

// staut:wip
// ERROR:  syntax error at or near "and column_name"
pub fn (db &DB) has_column(table_name, column_name string) bool {
	mut s := ''
	match db.config.client {
		'pg' {
			s = "select count(*) from information_schema.columns where table_schema=\'public\' and table_name =\'$table_name\' and column_name=\'$column_name\'"
		}
		'mysql' {
			// todo
		}
		'sqlite' {
			// todo
		}
		else {
			panic('unknown database client')
		}
	}
	res := db.exec(s)
	println(res)
	if res[0].vals[0] == '1' {
		return true
	} else {
		return false
	}
}

// truncate table
// status:done
pub fn (db &DB) truncate(name string) []pg.Row {
	truncate_stmt := Truncate{
		table_name: name
	}
	db.stmt = truncate_stmt
	return db.end()
}
