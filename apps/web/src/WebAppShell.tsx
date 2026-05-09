'use client';

import React from 'react';
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from './lib/queryClient';
import { Providers } from './providers';
import { ErrorBoundary } from './errorBoundary';
import { SuspenseBoundary } from './suspenseBoundary';

interface WebAppShellProps {
  children: React.ReactNode;
}

export default function WebAppShell({ children }: WebAppShellProps): React.ReactElement {
  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <Providers>
          <SuspenseBoundary>{children}</SuspenseBoundary>
        </Providers>
      </QueryClientProvider>
    </ErrorBoundary>
  );
}
