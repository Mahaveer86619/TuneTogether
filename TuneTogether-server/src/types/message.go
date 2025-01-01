package types

type Message struct {
	ID        string `json:"id"`
	SenderID  string `json:"sender_id"`
	GroupID   string `json:"group_id"`
	Content   string `json:"content"`
	Timestamp string `json:"timestamp"`
}
