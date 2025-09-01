'use client';

import * as React from 'react';
import { onAuthStateChanged } from 'firebase/auth';
import { auth } from '@/firebase';

import type { User } from '@/types/user';
import { authClient } from '@/lib/auth/client';
import { logger } from '@/lib/default-logger';

export interface UserContextValue {
  user: User | null;
  error: string | null;
  isLoading: boolean;
  checkSession?: () => Promise<void>;
}

export const UserContext = React.createContext<UserContextValue | undefined>(undefined);

export interface UserProviderProps {
  children: React.ReactNode;
}

export function UserProvider({ children }: UserProviderProps): React.JSX.Element {
  const [state, setState] = React.useState<{ user: User | null; error: string | null; isLoading: boolean }>({
    user: null,
    error: null,
    isLoading: true,
  });

  React.useEffect(() => {
    // Listen for Firebase auth state changes
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      if (firebaseUser) {
        setState({
          user: {
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            firstName: '',
            lastName: '',
            avatar: firebaseUser.photoURL ?? '/assets/avatar.png',
          },
          error: null,
          isLoading: false,
        });
      } else {
        setState({ user: null, error: null, isLoading: false });
      }
    });
    return () => unsubscribe();
  }, []);

  const checkSession = React.useCallback(async (): Promise<void> => {
    // No-op: handled by onAuthStateChanged
  }, []);

  return <UserContext.Provider value={{ ...state, checkSession }}>{children}</UserContext.Provider>;
}

export const UserConsumer = UserContext.Consumer;
