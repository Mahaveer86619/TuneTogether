package types

type Group struct {
	ID             string `json:"id"`
	Name           string `json:"name"`
	Description    string `json:"description"`
	CreatorID      string `json:"creator_id"`
	DisplayPicture string `json:"display_picture"`
	Type           string `json:"type"`
	CreatedAt      string `json:"created_at"`
	UpdatedAt      string `json:"updated_at"`
}

type GroupRequest struct {
	Name           string `json:"name"`
	Description    string `json:"description"`
	CreatorID      string `json:"creator_id"`
	DisplayPicture string `json:"display_picture"`
	Type           string `json:"type"`
}

type GroupUpdateRequest struct {
	ID             string `json:"id"`
	Name           string `json:"name"`
	Description    string `json:"description"`
	CreatorID      string `json:"creator_id"`
	DisplayPicture string `json:"display_picture"`
	Type           string `json:"type"`
}

type GroupMembers struct {
	ID       string `json:"id"`
	GroupID  string `json:"group_id"`
	UserID   string `json:"user_id"`
	Role     string `json:"role"`
	JoinedAt string `json:"joined_at"`
}
