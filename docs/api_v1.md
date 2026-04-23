# Time Bank API — v1

Base URL: `/api/v1`

All protected endpoints require the header:
```
Authorization: Bearer <token>
```

Tokens expire after **24 hours**.

---

## Authentication

### Register
`POST /api/v1/auth/register`

**Body**
```json
{ "user": { "name": "Alice", "email": "alice@example.com", "password": "password123" } }
```

**Response 201**
```json
{ "token": "<jwt>", "user": { "id": 1, "name": "Alice", "email": "alice@example.com", "balance": 10, "role": "user" } }
```

**Response 422** `{ "errors": ["Email has already been taken"] }`

---

### Login
`POST /api/v1/auth/login`

**Body** `{ "email": "alice@example.com", "password": "password123" }`

**Response 200** `{ "token": "<jwt>", "user": { ... } }`

**Response 401** `{ "error": "Invalid email or password." }`

---

## Profile (protected)

### Get profile
`GET /api/v1/profile`

**Response 200** `{ "id": 1, "name": "Alice", "email": "...", "balance": 10, "role": "user", "created_at": "..." }`

### Update profile
`PATCH /api/v1/profile`

**Body** `{ "user": { "name": "Alice Smith", "email": "...", "password": "newpass123" } }`  
Omit `password` to keep current.

---

## Services (protected)

### List / Search
`GET /api/v1/services?q=gardening`

**Response 200**
```json
[{ "id": 1, "title": "Gardening", "description": "...", "duration": 1, "provider": { "id": 2, "name": "Alice" }, "created_at": "..." }]
```

### Get service
`GET /api/v1/services/:id`

### Create service
`POST /api/v1/services`

**Body** `{ "service": { "title": "Gardening", "description": "...", "duration": 1 } }`

**Response 201** — service object

### Update service
`PATCH /api/v1/services/:id`  
Owner only. **Response 403** if not owner.

### Delete service
`DELETE /api/v1/services/:id`  
Owner only. **Response 204**

---

## Service Requests (protected)

### List
`GET /api/v1/service_requests`

**Response 200**
```json
{
  "incoming": [{ "id": 1, "status": "pending", "service": {...}, "requester": {...}, "provider": {...}, "created_at": "..." }],
  "outgoing": [...]
}
```

### Get request
`GET /api/v1/service_requests/:id`

### Create request
`POST /api/v1/service_requests`

**Body** `{ "service_id": 3 }`

**Response 201** — service_request object

**Response 422** if own service or insufficient balance.

### Accept
`PATCH /api/v1/service_requests/:id/accept`  
Provider only. Must be `pending`.

### Reject
`PATCH /api/v1/service_requests/:id/reject`  
Provider only. Must be `pending`.

### Cancel
`PATCH /api/v1/service_requests/:id/cancel`  
Provider or requester. Must be `pending` or `accepted`.

### Complete
`PATCH /api/v1/service_requests/:id/complete`  
Provider only. Must be `accepted`. Transfers credits on success.

**Response 422** `{ "error": "Credit transfer failed — requester has insufficient balance." }`

---

## Transactions (protected)

### List transaction history
`GET /api/v1/transactions`

**Response 200**
```json
[{ "id": 1, "amount": -1, "transaction_type": "debit", "description": "Payment for: Gardening", "service_request_id": 3, "created_at": "..." }]
```

Positive `amount` = credit received. Negative = debit paid.

---

## Status codes reference

| Code | Meaning |
|------|---------|
| 200 | OK |
| 201 | Created |
| 204 | No content (DELETE) |
| 401 | Unauthorized (missing/invalid/expired token) |
| 403 | Forbidden (authenticated but not allowed) |
| 422 | Validation failed |
