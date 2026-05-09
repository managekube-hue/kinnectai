import { NextRequest, NextResponse } from 'next/server';

export const runtime = 'nodejs';

export async function GET(_request: NextRequest): Promise<NextResponse> {
  return NextResponse.json(
    {
      service: 'kinnectai-web',
      route: '/api',
      version: '1',
      endpoints: ['/api/health'],
      timestamp: new Date().toISOString(),
    },
    { status: 200 },
  );
}
