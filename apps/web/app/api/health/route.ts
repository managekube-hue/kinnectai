import { NextRequest, NextResponse } from 'next/server';

export const runtime = 'nodejs';

export async function GET(_request: NextRequest): Promise<NextResponse> {
  return NextResponse.json(
    {
      status: 'ok',
      service: 'kinnectai-web',
      checks: {
        app: 'up',
      },
      timestamp: new Date().toISOString(),
    },
    { status: 200 },
  );
}
