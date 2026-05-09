// SRS §23.2 Category 2 — Auth Flow: SignupScreen.tsx
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { authApi } from '../../api/authApi';

export const SignupScreen: React.FC = () => {
  const router = useRouter();
  const [form, setForm] = useState({
    username: '',
    email: '',
    password: '',
    displayName: '',
  });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) =>
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await authApi.register(form);
      router.push('/auth/consent');
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Registration failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: 400, margin: '80px auto', padding: 24 }}>
      <h1>Create your account</h1>
      <form onSubmit={handleSubmit}>
        {(['displayName', 'username', 'email', 'password'] as const).map((field) => (
          <div key={field} style={{ marginBottom: 16 }}>
            <label htmlFor={field}>{field.charAt(0).toUpperCase() + field.slice(1)}</label>
            <input
              id={field}
              name={field}
              type={field === 'password' ? 'password' : field === 'email' ? 'email' : 'text'}
              value={form[field]}
              onChange={handleChange}
              required
              style={{ display: 'block', width: '100%', marginTop: 4 }}
            />
          </div>
        ))}
        {error && <p role="alert" style={{ color: 'red' }}>{error}</p>}
        <button type="submit" disabled={loading} style={{ width: '100%' }}>
          {loading ? 'Creating account…' : 'Create account'}
        </button>
      </form>
    </div>
  );
};

export default SignupScreen;
