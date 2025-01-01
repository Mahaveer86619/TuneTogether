package implementations

import (
	"database/sql"
	"fmt"
	"net/http"

	db "github.com/Mahaveer86619/TuneTogether_server/src/database"
	helpers "github.com/Mahaveer86619/TuneTogether_server/src/helpers"
	types "github.com/Mahaveer86619/TuneTogether_server/src/types"
	"github.com/google/uuid"
)

func CreateGroup(group *types.GroupRequest) (*types.Group, int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT id
	  FROM groups
	  WHERE name = $1
	`
	insert_query_users := `
		INSERT INTO groups (id, name, description, creator_id, display_picture, type, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *
	`

	// Check if the group name already exists
	var existingName string
	err := conn.QueryRow(search_query, group.Name).Scan(&existingName)

	if err == nil {
		// if the group name already exists err = null
		return nil, http.StatusConflict, fmt.Errorf("group name %s is taken", group.Name)
	} else if err != sql.ErrNoRows {
		return nil, http.StatusInternalServerError, fmt.Errorf("error checking existing user: %w", err)
	}

	// Create user
	var newGroup types.Group
	group_id := uuid.New().String()

	err = conn.QueryRow(
		insert_query_users,
		group_id,
		group.Name,
		group.Description,
		group.CreatorID,
		group.DisplayPicture,
		group.Type,
		helpers.GetCurrentDateTimeAsString(), // created_at
		helpers.GetCurrentDateTimeAsString(), // updated_at
	).Scan(
		&newGroup.ID,
		&newGroup.Name,
		&newGroup.Description,
		&newGroup.CreatorID,
		&newGroup.DisplayPicture,
		&newGroup.Type,
		&newGroup.CreatedAt,
		&newGroup.UpdatedAt,
	)

	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating group: %w", err)
	}

	return &newGroup, http.StatusCreated, nil
}

func GetAllGroups() ([]*types.Group, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM groups
	`

	rows, err := conn.Query(query)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error querying groups: %w", err)
	}
	defer rows.Close()

	var groups []*types.Group
	for rows.Next() {
		var group types.Group

		if err := rows.Scan(
			&group.ID,
			&group.Name,
			&group.Description,
			&group.CreatorID,
			&group.DisplayPicture,
			&group.Type,
			&group.CreatedAt,
			&group.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		groups = append(groups, &group)
	}

	// Return empty array if no groups found
	if len(groups) == 0 {
		return []*types.Group{}, http.StatusOK, nil
	}

	return groups, http.StatusOK, nil
}

func GetGroupByID(group_id string) (*types.Group, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM groups
	  WHERE id = $1
	`

	var group types.Group

	err := conn.QueryRow(
		query,
		group_id,
	).Scan(
		&group.ID,
		&group.Name,
		&group.Description,
		&group.CreatorID,
		&group.DisplayPicture,
		&group.Type,
		&group.CreatedAt,
		&group.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("group not found with id: %s", group_id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return &group, http.StatusOK, nil
}

func UpdateGroup(group *types.GroupUpdateRequest) (*types.Group, int, error) {
	conn := db.GetDBConnection()

	search_query := `SELECT * FROM groups WHERE id = $1`

	update_query := `UPDATE groups 
	SET name = $1, description = $2, display_picture = $3, type = $4, updated_at = $5
	WHERE id = $6
	RETURNING *`

	// Check if the group exists
	_, err := conn.Exec(search_query, group.ID)

	if err != nil {
		// Some error occurred
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("group not found with id: %s", group.ID)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		// Update the group
		var groupResp types.Group

		err = conn.QueryRow(
			update_query,
			group.Name,
			group.Description,
			group.DisplayPicture,
			group.Type,
			helpers.GetCurrentDateTimeAsString(),
			group.ID,
		).Scan(
			&groupResp.ID,
			&groupResp.Name,
			&groupResp.Description,
			&groupResp.CreatorID,
			&groupResp.DisplayPicture,
			&groupResp.Type,
			&groupResp.CreatedAt,
			&groupResp.UpdatedAt,
		)

		if err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error updating group: %w", err)
		}

		return &groupResp, http.StatusOK, nil
	}
}

func DeleteGroup(group_id string) (int, error) {
	conn := db.GetDBConnection()

	search_query := `SELECT * FROM groups WHERE id = $1`
	del_query := "DELETE FROM groups WHERE id = $1"

	// Check if the group exists
	_, err := conn.Exec(search_query, group_id)

	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("group not found with id: %s", group_id)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, group_id)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusOK, nil
}
