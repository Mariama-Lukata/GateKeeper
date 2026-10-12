package gaterkeeper.authz

import rego.v1

default allow := false

# --- Policy data ---
# Belongs in its own data.json in production, loaded via:
#   opa run policy.rego data.json
# and referenced as data.user_roles / data.role_grants.
# Kept inline here for a single-file example.

user_roles := {
	"alice": ["auditor"],
	"bob": ["devops", "network_admin"],
	"charlie": ["auditor", "devops"],
}

role_grants := {
	"auditor": [
		{"action": "view", "resource_type": "logs"},
	],
	"devops": [
		{"action": "view", "resource_type": "logs"},
		{"action": "deploy", "resource_type": "application"},
	],
	"admin": [
		{"action": "view", "resource_type": "logs"},
		{"action": "deploy", "resource_type": "application"},
		{"action": "configure", "resource_type": "network_interface"},
	],
}

# --- Expected input from the gateway ---
# {
#   "user": "bob",
#   "action": "deploy",
#   "resource_type": "application",
#   "headers": {"authorization": "Bearer ..."},
#   "source_ip": "192.168.1.42"
# }

allow if {
	is_authenticated
	is_from_whitelisted_ip
	has_required_grant
}

is_authenticated if {
	input.headers.authorization
}

is_from_whitelisted_ip if {
	net.cidr_contains("192.168.1.0/24", input.source_ip)
}

has_required_grant if {
	some role in user_roles[input.user]
	some grant in role_grants[role]
	grant.action == input.action
	grant.resource_type == input.resource_type
}