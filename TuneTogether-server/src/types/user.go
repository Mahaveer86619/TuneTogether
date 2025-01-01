package types

type User struct {
	ID           string   `json:"id"`
	Name         string   `json:"name"`
	Email        string   `json:"email"`
	Password     string   `json:"password"`
	ProfilePic   string   `json:"profile_picture"`
	Status       string   `json:"status"`
	JoinedGroups []string `json:"joined_groups"`
	CreatedAt    string   `json:"created_at"`
	UpdatedAt    string   `json:"updated_at"`
}

type UserResponse struct {
	ID           string   `json:"id"`
	Name         string   `json:"name"`
	Email        string   `json:"email"`
	ProfilePic   string   `json:"profile_picture"`
	Status       string   `json:"status"`
	JoinedGroups []string `json:"joined_groups"`
	Token        string   `json:"token"`
	RefreshToken string   `json:"refresh_token"`
}

type UserSafeResponse struct {
	ID           string   `json:"id"`
	Name         string   `json:"name"`
	Email        string   `json:"email"`
	ProfilePic   string   `json:"profile_picture"`
	Status       string   `json:"status"`
	JoinedGroups []string `json:"joined_groups"`
}

func GenUserResponseFromUser(u User, token string, refreshToken string) *UserResponse {
	resp := &UserResponse{
		ID:           u.ID,
		Name:         u.Name,
		Email:        u.Email,
		ProfilePic:   u.ProfilePic,
		Status:       u.Status,
		JoinedGroups: u.JoinedGroups,
	}

	resp.Token = token
	resp.RefreshToken = refreshToken

	return resp
}

func GenUserSafeResponseFromUser(u User) *UserSafeResponse {
	resp := &UserSafeResponse{
		ID:           u.ID,
		Name:         u.Name,
		Email:        u.Email,
		ProfilePic:   u.ProfilePic,
		Status:       u.Status,
		JoinedGroups: u.JoinedGroups,
	}

	return resp
}

func GenUserFromUserSafeResponse(u UserSafeResponse, createdAt string, updatedAt string) *User {
	resp := &User{
		ID:           u.ID,
		Name:         u.Name,
		Email:        u.Email,
		ProfilePic:   u.ProfilePic,
		Status:       u.Status,
		JoinedGroups: u.JoinedGroups,
		CreatedAt:    createdAt,
		UpdatedAt:    updatedAt,
	}

	return resp
}
