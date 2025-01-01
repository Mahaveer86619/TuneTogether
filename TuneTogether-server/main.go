package main

import (
	"fmt"
	"log"
	"net/http"

	postgres "github.com/Mahaveer86619/TuneTogether_server/src/database"
	handlers "github.com/Mahaveer86619/TuneTogether_server/src/handlers"
	middleware "github.com/Mahaveer86619/TuneTogether_server/src/middlewares"
	"github.com/joho/godotenv"
)

func main() {
	mux := http.NewServeMux()

	// Load environment variables
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error: ", err)
	}

	// Connect to database
	db, err := postgres.ConnectDB()
	if err != nil {
		fmt.Println("Error connecting to database:", err)
	}

	defer postgres.CloseDBConnection(db)

	// Create tables if they don't exist
	err = postgres.CreateTables(db)
	if err != nil {
		log.Fatal(err)
	}

	postgres.SetDBConnection(db)

	handleFunctions(mux)

	// Start server
	if err := http.ListenAndServe(":5060", mux); err != nil {
		fmt.Println("Error running server:", err)
	}
}

func handleFunctions(mux *http.ServeMux) {
	mux.HandleFunc("GET /test", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/favicon.ico" {
			return
		}
		fmt.Fprint(w, "TuneTogether")
	})

	//* Auth routes
	mux.HandleFunc("POST /api/v1/auth/register", middleware.LoggingMiddleware(handlers.RegisterUserController))
	mux.HandleFunc("POST /api/v1/auth/authenticate", middleware.LoggingMiddleware(handlers.AuthenticateUserController))
	mux.HandleFunc("POST /api/v1/auth/refresh", middleware.LoggingMiddleware(handlers.RefreshTokenController))

	//* User routes 
	mux.Handle("GET /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetUserByIDController)))
	mux.Handle("PATCH /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateUserController)))
	mux.Handle("DELETE /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteUserController)))

	//* Groups routes
	mux.Handle("GET /api/v1/groups", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetGroupByIDController)))
	mux.Handle("GET /api/v1/groups/public", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetAllPublicGroupController)))
	mux.Handle("POST /api/v1/groups", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateGroupController)))
	mux.Handle("PATCH /api/v1/groups", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateGroupController)))
	mux.Handle("DELETE /api/v1/groups", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteGroupController)))
	mux.Handle("GET /api/v1/members", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetAllGroupMembersController)))
	mux.Handle("POST /api/v1/members", middleware.AuthMiddleware(http.HandlerFunc(handlers.AddMemberToGroupController)))
	mux.Handle("PATCH /api/v1/members", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateGroupMemberController)))
	mux.Handle("DELETE /api/v1/members", middleware.AuthMiddleware(http.HandlerFunc(handlers.RemoveMemberFromGroupController)))

	//* Admin routes
	mux.Handle("GET /api/v1/users/all", middleware.LoggingMiddleware(http.HandlerFunc(handlers.GetAllUsersController)))
	mux.Handle("GET /api/v1/groups/all", middleware.LoggingMiddleware(http.HandlerFunc(handlers.GetAllGroupsController)))
	mux.Handle("GET /api/v1/members/all", middleware.LoggingMiddleware(http.HandlerFunc(handlers.GetAllGroupMembersController)))
}
