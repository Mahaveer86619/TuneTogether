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

	// Create group
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

	// add row to group_members and add group to joined groups of creator
	status_code, err := AddGroupMember(&types.GroupMemberJoinRequest{
		GroupID: newGroup.ID,
		UserID:  newGroup.CreatorID,
		Role:    "admin",
	})

	if err != nil {
		return nil, status_code, err
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

func GetAllPublicGroups() ([]*types.Group, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM groups
	  WHERE type = 'public'
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

	del_query := "DELETE FROM groups WHERE id = $1"

	// Execute the DELETE query
	result, err := conn.Exec(del_query, group_id)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error checking affected rows: %w", err)
	}

	if rowsAffected == 0 {
		return http.StatusNotFound, fmt.Errorf("group not found")
	}

	return http.StatusOK, nil
}

func GetGroupMembers(group_id string) ([]*types.GroupMembers, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM group_members
	  WHERE group_id = $1
	`

	rows, err := conn.Query(query, group_id)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error querying group members: %w", err)
	}
	defer rows.Close()

	var groupMembers []*types.GroupMembers
	for rows.Next() {
		var groupMember types.GroupMembers

		if err := rows.Scan(
			&groupMember.ID,
			&groupMember.GroupID,
			&groupMember.UserID,
			&groupMember.Role,
			&groupMember.JoinedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		groupMembers = append(groupMembers, &groupMember)
	}

	// Return empty array if no group members found
	if len(groupMembers) == 0 {
		return []*types.GroupMembers{}, http.StatusOK, nil
	}

	return groupMembers, http.StatusOK, nil
}

func AddGroupMember(request *types.GroupMemberJoinRequest) (int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT *
	  FROM group_members
	  WHERE group_id = $1 AND user_id = $2
	`

	insert_query := `
	  INSERT INTO group_members (id, group_id, user_id, role, joined_at)
	  VALUES ($1, $2, $3, $4, $5)
	`

	// Check if the group member already exists
	var groupMemberRow types.GroupMembers
	err := conn.QueryRow(
		search_query,
		request.GroupID,
		request.UserID,
	).Scan(
		&groupMemberRow.ID,
		&groupMemberRow.GroupID,
		&groupMemberRow.UserID,
		&groupMemberRow.Role,
		&groupMemberRow.JoinedAt,
	)

	if err == nil {
		// Member already exists
		return http.StatusConflict, fmt.Errorf("group member already exists")
	} else if err != sql.ErrNoRows {
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	// Add group member
	_, err = conn.Exec(
		insert_query,
		uuid.New().String(),
		request.GroupID,
		request.UserID,
		request.Role,
		helpers.GetCurrentDateTimeAsString(),
	)

	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error adding group member: %w", err)
	}

	// add group to joined groups of user
	status_code, err := AddGroupToJoinedList(request.UserID, request.GroupID)

	if err != nil {
		return status_code, err
	}

	return http.StatusCreated, nil
}

func UpdateGroupMember(request *types.GroupMemberUpdateRequest) (int, error) {
	conn := db.GetDBConnection()

	search_query := `
	  SELECT *
	  FROM group_members
	  WHERE group_id = $1 AND user_id = $2
	`

	update_query := `UPDATE group_members SET role = $1 WHERE group_id = $2 AND user_id = $3`

	// Check if the group member already exists
	_, err := conn.Exec(search_query, request.GroupID, request.UserID)

	if err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("group member not found")
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		// Update the group member
		_, err = conn.Exec(update_query, request.Role, request.GroupID, request.UserID)

		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error updating group member: %w", err)
		}

		return http.StatusOK, nil
	}
}

func DeleteGroupMember(groupID string, groupMemberID string) (int, error) {
	conn := db.GetDBConnection()

	del_query := `DELETE FROM group_members WHERE group_id = $1 AND user_id = $2`

	// Execute the DELETE query
	result, err := conn.Exec(del_query, groupID, groupMemberID)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error checking affected rows: %w", err)
	}

	if rowsAffected == 0 {
		return http.StatusNotFound, fmt.Errorf("group member not found")
	}

	// remove group from joined groups of user
	status_code, err := RemoveGroupFromJoinedList(groupMemberID, groupID)

	if err != nil {
		return status_code, err
	}

	return http.StatusOK, nil
}
