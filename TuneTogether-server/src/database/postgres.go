package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/lib/pq"
)

var db *sql.DB

func ConnectDB() (*sql.DB, error) {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		return nil, fmt.Errorf("DATABASE_URL not set in environment variables")
	}

	conn, err := sql.Open("postgres", dsn)
	if err != nil {
		fmt.Printf("Unable to connect to database: %v", err)
	}

	// Verify connection
	if err := conn.Ping(); err != nil {
		return nil, fmt.Errorf("ping failed: %w", err)
	}

	log.Println("Database connected successfully")
	db = conn

	return db, nil
}

// SetDBConnection sets the database connection
func SetDBConnection(conn *sql.DB) {
	db = conn
}

// GetDBConnection returns the database connection
func GetDBConnection() *sql.DB {
	return db
}

func CloseDBConnection(conn *sql.DB) {
	if err := conn.Close(); err != nil {
		log.Printf("Error closing database connection: %v", err)
	} else {
		log.Println("Database connection closed")
	}
}

func CreateTables(conn *sql.DB) error {
	queries := []string{
		`CREATE TABLE IF NOT EXISTS users (
  			id UUID PRIMARY KEY,
			name TEXT NOT NULL,
			email TEXT UNIQUE NOT NULL,
			password TEXT NOT NULL,
			profile_picture TEXT,
			created_at TIMESTAMP DEFAULT NOW(),
			updated_at TIMESTAMP DEFAULT NOW()
		);`,
		`CREATE TABLE IF NOT EXISTS forgot_password (
  			id UUID PRIMARY KEY,
  			email TEXT UNIQUE NOT NULL,
  			code TEXT UNIQUE NOT NULL
		);`,
		`CREATE TABLE IF NOT EXISTS groups (
  			id UUID PRIMARY KEY,
			name TEXT UNIQUE NOT NULL,
			owner_id UUID NOT NULL REFERENCES users(id),
			display_pic_url TEXT,
			created_at TIMESTAMP DEFAULT NOW(),
			updated_at TIMESTAMP DEFAULT NOW()
		);`,
		`CREATE TABLE IF NOT EXISTS groups_members (
  			group_id UUID NOT NULL REFERENCES groups(id),
			user_id UUID NOT NULL REFERENCES users(id),
			role TEXT DEFAULT 'member',
			joined_at TIMESTAMP DEFAULT NOW(),
			PRIMARY KEY (group_id, user_id)
		);`,
		`CREATE TABLE IF NOT EXISTS rooms (
			id UUID PRIMARY KEY,
			group_id UUID NOT NULL REFERENCES groups(id),
			created_by UUID NOT NULL REFERENCES users(id),
			video_url TEXT NOT NULL,
			crop_start TIMESTAMP,
			crop_end TIMESTAMP,
			created_at TIMESTAMP DEFAULT NOW()
		);`,
		`CREATE TABLE IF NOT EXISTS messages (
			id UUID PRIMARY KEY,
			room_id UUID NOT NULL REFERENCES rooms(id),
			user_id UUID NOT NULL REFERENCES users(id),
			content TEXT NOT NULL,
			created_at TIMESTAMP DEFAULT NOW()
		);`,
	}

	for _, query := range queries {
		if _, err := conn.Exec(query); err != nil {
			return fmt.Errorf("error creating table: %w", err)
		}
	}
	log.Printf("Tables created/verified")
	
	return nil
}
