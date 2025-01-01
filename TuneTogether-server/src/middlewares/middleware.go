package middleware

import (
	"context"
	"log"
	"net/http"
	"strings"

	"github.com/Mahaveer86619/TuneTogether_server/src/types"
	"github.com/golang-jwt/jwt/v5"
)

type contextKey string

const userContextKey = contextKey("user")

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			failureResponse := types.Failure{}
			failureResponse.SetStatusCode(http.StatusUnauthorized)
			failureResponse.SetMessage("Authorization header is required")
			failureResponse.JSON(w)
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		claims := &Claims{}
		token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
			return JwtKey, nil
		})

		if err != nil || !token.Valid {
			failureResponse := types.Failure{}
			failureResponse.SetStatusCode(http.StatusUnauthorized)
			failureResponse.SetMessage("Invalid token")
			failureResponse.JSON(w)
			return
		}

		// Token is valid, proceed to set the context
		ctx := context.WithValue(r.Context(), userContextKey, claims.Email)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func UserFromContext(ctx context.Context) (string, bool) {
	email, ok := ctx.Value(userContextKey).(string)
	return email, ok
}

func LoggingMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Get the remote address
		remoteAddr := r.RemoteAddr

		// Extract the IP address from remoteAddr (host:port format)
		ipAddress := remoteAddr[:strings.LastIndex(remoteAddr, ":")]

		// Log the request with IP address
		logString := `
		Request received from IP address: %s
		Method: %s & Path: %s
		User-Agent: %s
		`
		log.Printf(logString, ipAddress, r.Method, r.URL.Path, r.UserAgent())

		// Call the next handler in the chain
		next(w, r)
	}
}
