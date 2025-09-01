'use client';

import { auth } from '@/firebase';
import type { User as FirebaseUser } from 'firebase/auth';
import { signInWithEmailAndPassword, signOut as firebaseSignOut } from 'firebase/auth';
import type { User } from '@/types/user';

function generateToken(): string {
  const arr = new Uint8Array(12);
  globalThis.crypto.getRandomValues(arr);
  return Array.from(arr, (v) => v.toString(16).padStart(2, '0')).join('');
}

export interface SignUpParams {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

export interface SignInWithOAuthParams {
  provider: 'google' | 'discord';
}

export interface SignInWithPasswordParams {
  email: string;
  password: string;
}

export interface ResetPasswordParams {
  email: string;
}

const backendUrl = process.env.NEXT_PUBLIC_API_BASE_URL;

class AuthClient {
  async signUp(params: SignUpParams): Promise<{ error?: string }> {
    console.log("params", params);
    try {
      const res = await fetch(`${backendUrl}/admins/signup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(params),
      });

      const data = await res.json();

      if (!res.ok) {
        return { error: data.error || 'Signup failed' };
      }

      return {};
    } catch (error: unknown) {
      if (error instanceof Error) {
        return { error: error.message };
      }
      return { error: 'An unknown error occurred' };
    }
  }

  async signInWithOAuth(_: SignInWithOAuthParams): Promise<{ error?: string }> {
    return { error: 'Social authentication not implemented' };
  }

  async signInWithPassword(params: SignInWithPasswordParams): Promise<{ error?: string }> {
    const { email, password } = params;

    try {
      await signInWithEmailAndPassword(auth, email, password);
      const token = generateToken();
      localStorage.setItem('custom-auth-token', token);
      return {};
    } catch (error: unknown) {
      return error instanceof Error ? { error: error.message } : { error: 'Unknown error occurred' };
    }
  }

  async resetPassword(_: ResetPasswordParams): Promise<{ error?: string }> {
    return { error: 'Password reset not implemented' };
  }

  async updatePassword(_: ResetPasswordParams): Promise<{ error?: string }> {
    return { error: 'Update password not implemented' };
  }

  async getUser(): Promise<{ data?: User | null; error?: string }> {
    const currentUser: FirebaseUser | null = auth.currentUser;

    if (!currentUser) return { data: null };

    const data: User = {
      id: currentUser.uid,
      email: currentUser.email ?? '',
      firstName: '',
      lastName: '',
      avatar: currentUser.photoURL ?? '/assets/avatar.png',
    };

    return { data };
  }

  async signOut(): Promise<{ error?: string }> {
    try {
      await firebaseSignOut(auth);
      localStorage.removeItem('custom-auth-token');
      return {};
    } catch (error: unknown) {
      if (error instanceof Error) {
        return { error: error.message };
      }
      return { error: 'Sign out failed' };
    }
  }
}

export const authClient = new AuthClient();
