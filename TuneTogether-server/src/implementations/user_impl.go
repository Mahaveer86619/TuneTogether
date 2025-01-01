package implementations

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	db "github.com/Mahaveer86619/TuneTogether_server/src/database"
	helpers "github.com/Mahaveer86619/TuneTogether_server/src/helpers"
	types "github.com/Mahaveer86619/TuneTogether_server/src/types"
)

func GetAllUsers() ([]*types.UserSafeResponse, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM users
	`

	rows, err := conn.Query(query)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error querying users: %w", err)
	}
	defer rows.Close()

	var users []*types.UserSafeResponse
	for rows.Next() {
		var user types.User
		var joinedGroupsJSON string

		if err := rows.Scan(
			&user.ID,
			&user.Name,
			&user.Email,
			&user.Password,
			&user.ProfilePic,
			&user.Status,
			&joinedGroupsJSON,
			&user.CreatedAt,
			&user.UpdatedAt,
		); err != nil {
			if err == sql.ErrNoRows {
				return []*types.UserSafeResponse{}, http.StatusOK, nil
			}
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		// Unmarshal joined groups
		if err := json.Unmarshal([]byte(joinedGroupsJSON), &user.JoinedGroups); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
		}

		// Generate user safe response
		userSafeResponse := types.GenUserSafeResponseFromUser(user)
		users = append(users, userSafeResponse)
	}

	// Return empty array if no users found
	if len(users) == 0 {
		return []*types.UserSafeResponse{}, http.StatusOK, nil
	}

	return users, http.StatusOK, nil
}

func GetUserByID(userID string) (*types.UserSafeResponse, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM users
	  WHERE id = $1
	`

	var user types.User
	var joinedGroupsJSON string

	err := conn.QueryRow(
		query,
		userID,
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
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with id: %s", userID)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Unmarshal joined groups
	if err := json.Unmarshal([]byte(joinedGroupsJSON), &user.JoinedGroups); err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
	}

	// Generate user safe response
	userSafeResponse := types.GenUserSafeResponseFromUser(user)
	return userSafeResponse, http.StatusOK, nil
}

func UpdateUser(user *types.UserSafeResponse) (*types.UserSafeResponse, int, error) {
	conn := db.GetDBConnection()

	search_query := `SELECT * FROM users WHERE id = $1`

	update_query := `UPDATE users 
	SET name = $1, email = $2, profile_picture = $3, status = $4, joined_groups = $5, updated_at = $6
	WHERE id = $7
	RETURNING *`

	// Check if the user exists
	_, err := conn.Exec(search_query, user.ID)

	if err != nil {
		// Some error occurred
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with id: %s", user.ID)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		// Update the user
		var userResp types.User
		var joinedGroupsStr string

		// Serialize joined_groups to JSON
		joinedGroupsJSON, err := json.Marshal(user.JoinedGroups)
		if err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error serializing joined_groups: %w", err)
		}

		err = conn.QueryRow(
			update_query,
			user.Name,
			user.Email,
			user.ProfilePic,
			user.Status,
			string(joinedGroupsJSON),
			helpers.GetCurrentDateTimeAsString(),
			user.ID,
		).Scan(
			&userResp.ID,
			&userResp.Name,
			&userResp.Email,
			&userResp.Password,
			&userResp.ProfilePic,
			&userResp.Status,
			&joinedGroupsStr,
			&userResp.CreatedAt,
			&userResp.UpdatedAt,
		)

		if err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error updating user profile: %w", err)
		}

		// Unmarshal the updated joined_groups
		if err := json.Unmarshal([]byte(joinedGroupsStr), &userResp.JoinedGroups); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
		}

		// Generate user safe response
		userSafeResponse := types.GenUserSafeResponseFromUser(userResp)
		return userSafeResponse, http.StatusOK, nil
	}
}

func DeleteUser(userId string) (int, error) {
	conn := db.GetDBConnection()

	search_query := `SELECT * FROM users WHERE id = $1`
	del_query := "DELETE FROM users WHERE id = $1"

	// Check if the user exists
	_, err := conn.Exec(search_query, userId)

	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("user not found with id: %s", userId)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, userId)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusOK, nil
}

func AddGroupToJoinedList(userId string, groupId string) (int, error) {
	conn := db.GetDBConnection()

	search_query := `SELECT joined_groups FROM users WHERE id = $1`
	update_query := `UPDATE users SET joined_groups = $1 WHERE id = $2`

	// Get the user's joined_groups
	var joinedGroupsJSON string
	err := conn.QueryRow(search_query, userId).Scan(&joinedGroupsJSON)
	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("user not found with id: %s", userId)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Unmarshal joined_groups
	var joinedGroups []string
	if len(joinedGroupsJSON) > 0 {
		if err := json.Unmarshal([]byte(joinedGroupsJSON), &joinedGroups); err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
		}
	}

	// Add the group to the joined_groups
	joinedGroups = append(joinedGroups, groupId)

	// Serialize joined_groups to JSON
	updatedGroupsJSON, err := json.Marshal(joinedGroups)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error serializing joined_groups: %w", err)
	}

	// Update the user's joined_groups
	_, err = conn.Exec(update_query, string(updatedGroupsJSON), userId)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error updating joined_groups: %w", err)
	}

	return http.StatusOK, nil
}

func RemoveGroupFromJoinedList(userId string, groupId string) (int, error) {
	conn := db.GetDBConnection()

	search_query := `SELECT joined_groups FROM users WHERE id = $1`
	update_query := `UPDATE users SET joined_groups = $1 WHERE id = $2`

	// Get the user's joined_groups
	var joinedGroupsJSON string
	err := conn.QueryRow(search_query, userId).Scan(&joinedGroupsJSON)
	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("user not found with id: %s", userId)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Unmarshal joined_groups
	var joinedGroups []string
	if len(joinedGroupsJSON) > 0 {
		if err := json.Unmarshal([]byte(joinedGroupsJSON), &joinedGroups); err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error unmarshalling joined_groups: %w", err)
		}
	}

	// Remove the group id from the joined_groups
	result := []string{}
	for _, str := range joinedGroups {
		if str != groupId {
			result = append(result, str)
		}
	}

	// Serialize joined_groups to JSON
	updatedGroupsJSON, err := json.Marshal(result)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error serializing joined_groups: %w", err)
	}

	// Update the user's joined_groups
	_, err = conn.Exec(update_query, string(updatedGroupsJSON), userId)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error updating joined_groups: %w", err)
	}

	return http.StatusOK, nil
}
