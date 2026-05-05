package user

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Service struct {
	db *pgxpool.Pool
}

func NewService(db *pgxpool.Pool) *Service {
	return &Service{db: db}
}

// GetProfile fetches a user's public profile by ID.
func (s *Service) GetProfile(ctx context.Context, userID uuid.UUID) (*Profile, error) {
	var p Profile
	err := s.db.QueryRow(ctx, `
		SELECT
			u.id, u.username, u.display_name, COALESCE(u.bio, ''),
			COALESCE(u.profile_picture_url, ''), u.is_verified, u.created_at,
			(SELECT COUNT(*) FROM kinnections k
			 WHERE (k.user_a_id = u.id OR k.user_b_id = u.id)
			 AND k.status = 'confirmed') AS kinnection_count
		FROM users u
		WHERE u.id = $1 AND u.is_active = TRUE`,
		userID,
	).Scan(&p.ID, &p.Username, &p.DisplayName, &p.Bio,
		&p.ProfilePictureURL, &p.IsVerified, &p.CreatedAt, &p.KinnectionCount)
	if err != nil {
		return nil, fmt.Errorf("get profile: %w", err)
	}
	return &p, nil
}

// UpdateProfile updates mutable profile fields for the authenticated user.
func (s *Service) UpdateProfile(ctx context.Context, userID uuid.UUID, req UpdateProfileRequest) (*Profile, error) {
	_, err := s.db.Exec(ctx, `
		UPDATE users SET
			display_name        = COALESCE(NULLIF($2, ''), display_name),
			bio                 = COALESCE(NULLIF($3, ''), bio),
			profile_picture_url = COALESCE(NULLIF($4, ''), profile_picture_url),
			updated_at          = NOW()
		WHERE id = $1`,
		userID, req.DisplayName, req.Bio, req.ProfilePictureURL,
	)
	if err != nil {
		return nil, fmt.Errorf("update profile: %w", err)
	}
	return s.GetProfile(ctx, userID)
}

// SurnameMap returns users on the platform sharing the given surname — the onboarding hook.
func (s *Service) SurnameMap(ctx context.Context, surname string) (*SurnameMapResult, error) {
	rows, err := s.db.Query(ctx, `
		SELECT u.id, u.username, u.display_name, COALESCE(u.profile_picture_url, ''), u.is_verified, u.created_at
		FROM users u
		JOIN identity_profiles ip ON ip.user_id = u.id
		WHERE $1 = ANY(ip.name_variants) OR u.username ILIKE '%' || $1 || '%'
		LIMIT 50`,
		surname,
	)
	if err != nil {
		return nil, fmt.Errorf("surname map: %w", err)
	}
	defer rows.Close()

	var profiles []Profile
	for rows.Next() {
		var p Profile
		if err := rows.Scan(&p.ID, &p.Username, &p.DisplayName, &p.ProfilePictureURL, &p.IsVerified, &p.CreatedAt); err != nil {
			return nil, err
		}
		profiles = append(profiles, p)
	}

	return &SurnameMapResult{
		Surname:       surname,
		MatchingUsers: profiles,
		UserCount:     len(profiles),
	}, nil
}
