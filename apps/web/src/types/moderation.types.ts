// SRS §23.2 Category 17 — Frontend Types: Moderation
export interface AbuseReport {
  reportId: string;
  reporterId: string;
  subjectId: string;
  contentId?: string;
  abuseType: 'harassment' | 'spam' | 'hate_speech' | 'csam' | 'impersonation';
  description: string;
  status: 'pending' | 'actioned' | 'dismissed';
  createdAt: string;
}

export interface ModerationQueueItem {
  itemId: string;
  contentId: string;
  contentType: string;
  toxicityScore: number;
  priority: 'low' | 'normal' | 'high' | 'urgent';
  status: 'pending' | 'under_review' | 'resolved' | 'escalated';
  queuedAt: string;
}

export interface ContentFlag {
  flagId: string;
  contentId: string;
  flagType: string;
  confidence: number;
  flaggedAt: string;
}
