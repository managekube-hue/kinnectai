package postgres

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
)

// Repository implements user.Repository against PostgreSQL
type Repository struct {
	db *sql.DB
}

// New creates postgres repository
func New(db *sql.DB) *Repository {
	return &Repository{db: db}
}

// Create persists a new user
func (r *Repository) Create(ctx context.Context, u *user.User) error {
	query := `
		INSERT INTO users (id, email, password_hash, status, mfa_enabled, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
	`

	_, err := r.db.ExecContext(ctx, query,
		u.ID, u.Email, u.PasswordHash, u.Status, u.MFAEnabled, u.CreatedAt, u.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("failed to create user: %w", err)
	}

	return nil
}

// GetByID retrieves user by ID
func (r *Repository) GetByID(ctx context.Context, id string) (*user.User, error) {
	query := `
		SELECT id, email, password_hash, mfa_secret, mfa_enabled, status, created_at, updated_at, last_login_at
		FROM users
		WHERE id = $1
	`

	u := &user.User{}
	err := r.db.QueryRowContext(ctx, query, id).Scan(
		&u.ID, &u.Email, &u.PasswordHash, &u.MFASecret, &u.MFAEnabled, &u.Status,
		&u.CreatedAt, &u.UpdatedAt, &u.LastLoginAt,
	)

	if err == sql.ErrNoRows {
		return nil, user.ErrUserNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %w", err)
	}

	return u, nil
}

// GetByEmail retrieves user by email
func (r *Repository) GetByEmail(ctx context.Context, email string) (*user.User, error) {
	query := `
		SELECT id, email, password_hash, mfa_secret, mfa_enabled, status, created_at, updated_at, last_login_at
		FROM users
		WHERE email = $1
	`

	u := &user.User{}
	err := r.db.QueryRowContext(ctx, query, email).Scan(
		&u.ID, &u.Email, &u.PasswordHash, &u.MFASecret, &u.MFAEnabled, &u.Status,
		&u.CreatedAt, &u.UpdatedAt, &u.LastLoginAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user by email: %w", err)
	}

	return u, nil
}

// Update persists user changes
func (r *Repository) Update(ctx context.Context, u *user.User) error {
	query := `
		UPDATE users
		SET email = $1, password_hash = $2, mfa_secret = $3, mfa_enabled = $4,
		    status = $5, updated_at = $6, last_login_at = $7
		WHERE id = $8
	`

	result, err := r.db.ExecContext(ctx, query,
		u.Email, u.PasswordHash, u.MFASecret, u.MFAEnabled, u.Status, u.UpdatedAt, u.LastLoginAt, u.ID,
	)
	if err != nil {
		return fmt.Errorf("failed to update user: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rows == 0 {
		return user.ErrUserNotFound
	}

	return nil
}

// Delete removes user
func (r *Repository) Delete(ctx context.Context, id string) error {
	query := `DELETE FROM users WHERE id = $1`

	result, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete user: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rows == 0 {
		return user.ErrUserNotFound
	}

	return nil
}

// List retrieves users with filters
func (r *Repository) List(ctx context.Context, filters map[string]interface{}) ([]*user.User, error) {
	query := `SELECT id, email, password_hash, mfa_secret, mfa_enabled, status, created_at, updated_at, last_login_at FROM users`

	// TODO: build dynamic WHERE clause from filters

	rows, err := r.db.QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("failed to list users: %w", err)
	}
	defer rows.Close()

	var users []*user.User
	for rows.Next() {
		u := &user.User{}
		err := rows.Scan(
			&u.ID, &u.Email, &u.PasswordHash, &u.MFASecret, &u.MFAEnabled, &u.Status,
			&u.CreatedAt, &u.UpdatedAt, &u.LastLoginAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan user: %w", err)
		}
		users = append(users, u)
	}

	return users, nil
}
