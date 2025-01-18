# infra

🐳 Repo contains Docker Compose file for faster deployment microservices-infrastructure

👨‍💻 Use __*make help*__ for discover DEVOPS approaches

### ⚙️ Public API methods as service. With Auth: X-AUTH-TOKEN

| METHOD | ENDPOINT                  |
|--------|---------------------------|
| POST   | {API_URL}/v1/data/inspect |

___

### ⚙️ [DEPRECATED] Public API methods as service. Proxy Adapter that uses the checkmail-service. With Auth: Bearer Token

| METHOD | ENDPOINT               |
|--------|------------------------|
| GET    | {API_URL}/domain/check |

___

### 📱 Public REST API methods as backend Billing APP. Without Auth, but with reCAPTCHA

| METHOD | ENDPOINT                                 |
|--------|------------------------------------------|
| POST   | {GATEWAY_URL}/auth/v1/sign-up            |
| POST   | {GATEWAY_URL}/auth/v1/confirm            |
| POST   | {GATEWAY_URL}/auth/v1/sign-in            |
| POST   | {GATEWAY_URL}/auth/v1/reset-password     |
| POST   | {GATEWAY_URL}/checkmail/v1/domains/count |
| POST   | {GATEWAY_URL}/checkmail/v1/data/inspect  |
| POST   | {GATEWAY_URL}/checkmail/v1/filters       |
| POST   | {GATEWAY_URL}/mail/v1/feedback           |

___

### 📲 Public REST API methods as backend Billing APP. With Auth: Bearer Token - [Customer Role]

| METHOD | ENDPOINT                                      |
|--------|-----------------------------------------------|
| POST   | {GATEWAY_URL}/auth/v1/sign-out                |
| POST   | {GATEWAY_URL}/auth/v1/token/refresh           |
| GET    | {GATEWAY_URL}/customer/v1/customers           |
| GET    | {GATEWAY_URL}/project/v1/projects             |
| GET    | {GATEWAY_URL}/project/v1/projects/{projectId} |
| POST   | {GATEWAY_URL}/project/v1/projects             |
| PATCH  | {GATEWAY_URL}/project/v1/projects/{projectId} |
| DEL    | {GATEWAY_URL}/project/v1/projects/{projectId} |

___

### 🛠 Public REST API methods as backend Support Panel APP : Bearer Token - [Staff Role]

| METHOD | ENDPOINT                                        |
|--------|-------------------------------------------------|
| POST   | {GATEWAY_URL}/auth/v1/sign-out                  |
| POST   | {GATEWAY_URL}/auth/v1/token/refresh             |
| GET    | {GATEWAY_URL}/checkmail/v1/domains/{domainName} |
| POST   | {GATEWAY_URL}/checkmail/v1/domains              |
| PATCH  | {GATEWAY_URL}/checkmail/v1/domains/{domainName} |
| DEL    | {GATEWAY_URL}/checkmail/v1/domains/{domainName} |
| GET    | {GATEWAY_URL}/lookup/v1/mxrecords               |
| GET    | {GATEWAY_URL}/lookup/v1/mxrecords/{data}        |
| POST	  | {GATEWAY_URL}/lookup/v1/mxrecords               |
| PATCH  | {GATEWAY_URL}/lookup/v1/mxrecords/{data}        |
| DEL    | {GATEWAY_URL}/lookup/v1/mxrecords/{data}        |
| GET    | {GATEWAY_URL}/project/v1/projects               |
| GET    | {GATEWAY_URL}/project/v1/projects/{projectId}   |
| POST	  | {GATEWAY_URL}/project/v1/projects               |
| PATCH  | {GATEWAY_URL}/project/v1/projects/{projectId}   |
| DEL    | {GATEWAY_URL}/project/v1/projects/{projectId}   |