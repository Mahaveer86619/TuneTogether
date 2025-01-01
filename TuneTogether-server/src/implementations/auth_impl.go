package implementations

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	db "github.com/Mahaveer86619/TuneTogether_server/src/database"
	helpers "github.com/Mahaveer86619/TuneTogether_server/src/helpers"
	middleware "github.com/Mahaveer86619/TuneTogether_server/src/middlewares"
	services "github.com/Mahaveer86619/TuneTogether_server/src/services"
	types "github.com/Mahaveer86619/TuneTogether_server/src/types"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

func AuthenticateUser(credentials *types.AuthenticatingCredentials) (*types.UserResponse, int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT *
	  FROM users
	  WHERE email = $1
	`

	var authUser types.User
	var joinedGroupsJSON string

	// Search for user in database 
	err := conn.QueryRow(
		search_query,
		credentials.Email,
	).Scan(
		&authUser.ID,
		&authUser.Name,
		&authUser.Email,
		&authUser.Password,
		&authUser.ProfilePic,
		&authUser.Status,
		&joinedGroupsJSON,
		&authUser.CreatedAt,
		&authUser.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with email: %s", credentials.Email)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Unmarshal joined groups
	if err := json.Unmarshal([]byte(joinedGroupsJSON), &authUser.JoinedGroups); err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
	}

	// Password validation
	if credentials.Password != authUser.Password {
		return nil, http.StatusUnauthorized, fmt.Errorf("wrong password")
	}

	// Generate tokens
	token, err := middleware.GenerateToken(authUser.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating token: %w", err)
	}

	refreshToken, err := middleware.GenerateRefreshToken(authUser.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating refresh token: %w", err)
	}

	// Return response
	credsToReturn := types.GenUserResponseFromUser(authUser, token, refreshToken)	
	return credsToReturn, http.StatusOK, nil
}

func RegisterUser(credentials *types.RegisteringCredentials) (*types.UserResponse, int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT id
	  FROM users
	  WHERE email = $1
	`
	insert_query_users := `
		INSERT INTO users (id, name, email, password, profile_picture, status, joined_groups, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *
	`

	// Check if the user already exists
	var existingId string
	err := conn.QueryRow(search_query, credentials.Email).Scan(&existingId)

	if err == nil {
		return nil, http.StatusConflict, fmt.Errorf("user is already registered with email: %s", credentials.Email)
	} else if err != sql.ErrNoRows {
		return nil, http.StatusInternalServerError, fmt.Errorf("error checking existing user: %w", err)
	}

	// Create user
	var user types.User
	user.ID = uuid.New().String()
	var joinedGroupsJSON string

	err = conn.QueryRow(
		insert_query_users,
		user.ID,
		credentials.Name,
		credentials.Email,
		credentials.Password,
		"",                                   // profile_picture
		"active",                             // status
		"[]",                                 // joined_groups
		helpers.GetCurrentDateTimeAsString(), // created_at
		helpers.GetCurrentDateTimeAsString(), // updated_at
	).Scan(
		&user.ID,
		&user.Name,
		&user.Email,
		&user.Password,
		&user.ProfilePic,
		&user.Status,
		&joinedGroupsJSON,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating user: %w", err)
	}

	// Unmarshal joined groups
	if err := json.Unmarshal([]byte(joinedGroupsJSON), &user.JoinedGroups); err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
	}

	// Generate tokens
	token, err := middleware.GenerateToken(user.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating token: %w", err)
	}

	refreshToken, err := middleware.GenerateRefreshToken(user.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating refresh token: %w", err)
	}

	// Return credentials for successful registration
	credsToReturn := types.GenUserResponseFromUser(user, token, refreshToken)
	return credsToReturn, http.StatusCreated, nil
}

func SendPassResetCode(email string) (int, error) {
	conn := db.GetDBConnection()

	insert_query := `
		INSERT INTO forgot_password (id, email, code)
		VALUES ($1, $2, $3) RETURNING *
	`
	select_user_query := `
	  SELECT *
	  FROM users
	  WHERE email = $1
	`

	var authUser types.User

	// Search for user in database
	err := conn.QueryRow(
		select_user_query,
		email,
	).Scan(
		&authUser.ID,
		&authUser.Name,
		&authUser.Email,
		&authUser.Password,
		&authUser.ProfilePic,
		&authUser.CreatedAt,
		&authUser.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("provided email is not registered: %s", email)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	var forgotPassword types.ForgotPassword
	forgotPassword.ID = uuid.New().String()
	forgotPassword.Email = email
	forgotPassword.Code = helpers.Gen6DigitCode()

	err = conn.QueryRow(
		insert_query,
		forgotPassword.ID,
		forgotPassword.Email,
		forgotPassword.Code,
	).Scan(
		&forgotPassword.ID,
		&forgotPassword.Email,
		&forgotPassword.Code,
	)

	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error generating forgot password code: %w", err)
	}

	// Send email with forgot password code
	err = services.SendBasicHTMLEmail(
		[]string{email},
		"Reset your password",
		services.GeneratePasswordResetHTML(forgotPassword.Code, email),
	)

	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error sending email: %w", err)
	}

	return http.StatusOK, nil
}

func CheckResetPassCode(code string, email string) (string, int, error) {
	conn := db.GetDBConnection()

	select_query := `
	  SELECT *
	  FROM forgot_password
	  WHERE email = $1
	`
	del_query := "DELETE FROM forgot_password WHERE id = $1"

	var forgotPassword types.ForgotPassword

	// Search for forgot password in database
	if err := conn.QueryRow(
		select_query,
		email,
	).Scan(
		&forgotPassword.ID,
		&forgotPassword.Email,
		&forgotPassword.Code,
	); err != nil {
		if err == sql.ErrNoRows {
			return "", http.StatusNotFound, fmt.Errorf("forgot password row not found with email: %s", email)
		}
		return "", http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Delete forgot password row if code is correct
	if forgotPassword.Code != code {
		return "", http.StatusBadRequest, fmt.Errorf("invalid code")
	}

	_, err := conn.Exec(del_query, forgotPassword.ID)
	if err != nil {
		return "", http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	return forgotPassword.Code, http.StatusOK, nil
}

func RefreshToken(refreshingToken *types.RefreshTokenBody) (*types.RefreshTokenResp, int, error) {
	claims := &middleware.Claims{}
	token, err := jwt.ParseWithClaims(refreshingToken.RefreshTokenKey, claims, func(token *jwt.Token) (interface{}, error) {
		return middleware.JwtKey, nil
	})

	if err != nil || !token.Valid {
		return nil, http.StatusUnauthorized, fmt.Errorf("invalid refresh token")
	}

	newToken, err := middleware.GenerateToken(claims.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error generating new token: %w", err)
	}

	newRefreshToken, err := middleware.GenerateRefreshToken(claims.Email)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error generating new token: %w", err)
	}

	return &types.RefreshTokenResp{
		TokenKey:        newToken,
		RefreshTokenKey: newRefreshToken,
	}, http.StatusOK, nil
}
