package types

// for authentication and registration
type AuthenticatingCredentials struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type RegisteringCredentials struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

// for forgot password
type ForgotPassword struct {
	ID    string `json:"id"`
	Email string `json:"email"`
	Code  string `json:"code"`
}

type SendPassResetCodeBody struct {
	Email string `json:"email"`
}

type CheckPassResetCodeBody struct {
	Email string `json:"email"`
	Code  string `json:"code"`
}

// for refreshing tokens
type RefreshTokenBody struct {
	RefreshTokenKey string `json:"refreshTokenKey"`
}

type RefreshTokenResp struct {
	TokenKey        string `json:"tokenKey"`
	RefreshTokenKey string `json:"refreshTokenKey"`
}

func GenAuthResponseToReturn(u User, token string, refreshToken string) *UserResponse {
	resp := &UserResponse{
		ID:           u.ID,
		Name:         u.Name,
		Email:        u.Email,
		ProfilePic:   u.ProfilePic,
	}

	resp.Token = token
	resp.RefreshToken = refreshToken

	return resp
}