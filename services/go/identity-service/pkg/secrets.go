package secrets

import (
	"context"
	"fmt"
)

// SecretManager abstracts secret storage backends (Vault, AWS Secrets Manager, etc).
// Prevents hardcoded secrets and enables rotation without code changes.
type SecretManager interface {
	// GetSecret retrieves a secret by name.
	GetSecret(ctx context.Context, name string) (string, error)

	// SetSecret stores a secret.
	SetSecret(ctx context.Context, name string, value string) error

	// DeleteSecret removes a secret.
	DeleteSecret(ctx context.Context, name string) error

	// RotateSecret triggers rotation (implementation-specific).
	RotateSecret(ctx context.Context, name string) error

	// GetSecretVersion retrieves a specific secret version.
	GetSecretVersion(ctx context.Context, name string, version int) (string, error)
}

// NoOpSecretManager is a development-only implementation (NOT FOR PRODUCTION).
// Used in local development when Vault/AWS is unavailable.
type NoOpSecretManager struct {
	secrets map[string]string
}

// NewNoOpSecretManager creates a development secret manager.
func NewNoOpSecretManager() *NoOpSecretManager {
	return &NoOpSecretManager{
		secrets: make(map[string]string),
	}
}

func (m *NoOpSecretManager) GetSecret(ctx context.Context, name string) (string, error) {
	if val, ok := m.secrets[name]; ok {
		return val, nil
	}
	return "", fmt.Errorf("secret not found: %s", name)
}

func (m *NoOpSecretManager) SetSecret(ctx context.Context, name string, value string) error {
	m.secrets[name] = value
	return nil
}

func (m *NoOpSecretManager) DeleteSecret(ctx context.Context, name string) error {
	delete(m.secrets, name)
	return nil
}

func (m *NoOpSecretManager) RotateSecret(ctx context.Context, name string) error {
	// No-op in development
	return nil
}

func (m *NoOpSecretManager) GetSecretVersion(ctx context.Context, name string, version int) (string, error) {
	// In development, just return current
	return m.GetSecret(ctx, name)
}

// VaultSecretManager implements SecretManager using HashiCorp Vault.
// Would be implemented in pkg/secrets/vault/vault.go
type VaultSecretManager struct {
	// Implementation details...
}

// AWSSecretsManager implements SecretManager using AWS Secrets Manager.
// Would be implemented in pkg/secrets/aws/aws.go
type AWSSecretsManager struct {
	// Implementation details...
}
