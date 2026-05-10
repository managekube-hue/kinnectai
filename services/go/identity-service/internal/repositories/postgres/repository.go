package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"identityservice/internal/domain/user"
)

// Repository implements user.Repository using PostgreSQL.
type Repository struct {
	db *sql.DB
}

// New creates a new PostgreSQL user repository.
func New(db *sql.DB) *Repository {
	return &Repository{db: db}
}

// Save persists a new user to PostgreSQL.
func (r *Repository) Save(ctx context.Context, u *user.User) error {
	query := `
		INSERT INTO users (id, email, phone_number, password_hash, status, mfa_enabled, mfa_type, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
	`

	_, err := r.db.ExecContext(ctx, query,
		u.ID, u.Email, u.PhoneNumber, u.PasswordHash, u.Status, u.MFAEnabled, u.MFAType, u.CreatedAt, u.UpdatedAt,
	)

	if err != nil {
		// Check for unique constraint violation on email
		if err.Error() == "pq: duplicate key value violates unique constraint \"users_email_key\"" {
			return user.ErrUserAlreadyExists
		}
		return fmt.Errorf("failed to insert user: %w", err)
	}

	return nil
}

// FindByID retrieves a user by ID.
func (r *Repository) FindByID(ctx context.Context, id string) (*user.User, error) {
	query := `
		SELECT id, email, phone_number, password_hash, status, mfa_enabled, mfa_type, created_at, updated_at, last_login_at
		FROM users WHERE id = $1 AND deleted_at IS NULL
	`

	u := &user.User{}
	err := r.db.QueryRowContext(ctx, query, id).Scan(
		&u.ID, &u.Email, &u.PhoneNumber, &u.PasswordHash, &u.Status, &u.MFAEnabled, &u.MFAType, &u.CreatedAt, &u.UpdatedAt, &u.LastLoginAt,
	)

	if err == sql.ErrNoRows {
		return nil, user.ErrUserNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("failed to query user: %w", err)
	}

	return u, nil
}

// FindByEmail retrieves a user by email address.
func (r *Repository) FindByEmail(ctx context.Context, email string) (*user.User, error) {
	query := `
		SELECT id, email, phone_number, password_hash, status, mfa_enabled, mfa_type, created_at, updated_at, last_login_at
		FROM users WHERE email = $1 AND deleted_at IS NULL
	`

	u := &user.User{}
	err := r.db.QueryRowContext(ctx, query, email).Scan(
		&u.ID, &u.Email, &u.PhoneNumber, &u.PasswordHash, &u.Status, &u.MFAEnabled, &u.MFAType, &u.CreatedAt, &u.UpdatedAt, &u.LastLoginAt,
	)

	if err == sql.ErrNoRows {
		return nil, user.ErrUserNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("failed to query user by email: %w", err)
	}

	return u, nil
}

// Exists checks if a user exists by email.
func (r *Repository) Exists(ctx context.Context, email string) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM users WHERE email = $1 AND deleted_at IS NULL)`

	var exists bool
	err := r.db.QueryRowContext(ctx, query, email).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("failed to check user existence: %w", err)
	}

	return exists, nil
}

// Update persists changes to an existing user.
func (r *Repository) Update(ctx context.Context, u *user.User) error {
	query := `
		UPDATE users
		SET email = $1, phone_number = $2, password_hash = $3, status = $4, 
		    mfa_enabled = $5, mfa_type = $6, updated_at = $7, last_login_at = $8
		WHERE id = $9
	`

	result, err := r.db.ExecContext(ctx, query,
		u.Email, u.PhoneNumber, u.PasswordHash, u.Status,
		u.MFAEnabled, u.MFAType, u.UpdatedAt, u.LastLoginAt,
		u.ID,
	)

	if err != nil {
		return fmt.Errorf("failed to update user: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rows == 0 {
		return user.ErrUserNotFound
	}

	return nil
}

// Delete soft-deletes a user (marks deleted_at).
func (r *Repository) Delete(ctx context.Context, id string) error {
	query := `UPDATE users SET deleted_at = NOW() WHERE id = $1`

	result, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete user: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rows == 0 {
		return user.ErrUserNotFound
	}

	return nil
}

// FindByStatus retrieves all users with a specific status.
func (r *Repository) FindByStatus(ctx context.Context, status user.Status) ([]*user.User, error) {
	query := `
		SELECT id, email, phone_number, password_hash, status, mfa_enabled, mfa_type, created_at, updated_at, last_login_at
		FROM users WHERE status = $1 AND deleted_at IS NULL
		ORDER BY created_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, status)
	if err != nil {
		return nil, fmt.Errorf("failed to query users by status: %w", err)
	}
	defer rows.Close()

	var users []*user.User
	for rows.Next() {
		u := &user.User{}
		if err := rows.Scan(&u.ID, &u.Email, &u.PhoneNumber, &u.PasswordHash, &u.Status, &u.MFAEnabled, &u.MFAType, &u.CreatedAt, &u.UpdatedAt, &u.LastLoginAt); err != nil {
			return nil, fmt.Errorf("failed to scan user: %w", err)
		}
		users = append(users, u)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("failed to iterate users: %w", err)
	}

	return users, nil
}
