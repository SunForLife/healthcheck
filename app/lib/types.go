package lib

const (
	StatusAvailable    = "AVAILABLE"
	StatusNotAvailable = "NOT AVAILABLE"
)

// ServiceStatus struct description.
type ServiceStatus struct {
	IP     string `json:"ip"`
	Status string `json:"status"`
	Time   string `json:"time"`
}
