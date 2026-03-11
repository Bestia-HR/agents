# Complete Website Security Safeguards Report
## 67 Essential Protections with TypeScript Implementation

---

## CATEGORY 2 (continued): Authentication & Session Management Exploits

### 13. Session Fixation Attack & Prevention

**The Exploit:**
```typescript
// ATTACKER sets a known session ID before login
// 1. Attacker visits site, gets session ID: abc123
// 2. Attacker sends link to victim: https://site.com/login?JSESSIONID=abc123
// 3. Victim logs in, server keeps session abc123 but now authenticated
// 4. Attacker uses abc123 and is now logged in as victim!

// VULNERABLE CODE:
app.post('/login', (req, res) => {
  const user = authenticate(req.body);
  if (user) {
    // Session ID remains the same after login!
    req.session.userId = user.id; // Same session ID
    res.redirect('/dashboard');
  }
});
```

**The Fix:**
```typescript
import { Request, Response } from 'express';

app.post('/login', async (req: Request, res: Response) => {
  const user = await authenticate(req.body);
  if (user) {
    // Regenerate session ID on authentication
    req.session.regenerate((err) => {
      if (err) {
        return res.status(500).send('Session error');
      }
      
      // Store user data in new session
      req.session.userId = user.id;
      req.session.authTime = Date.now();
      req.session.ipAddress = req.ip;
      
      // Set additional security headers
      res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate');
      res.redirect('/dashboard');
    });
  }
});

// Session validation middleware
function validateSession(req: Request, res: Response, next: Function) {
  if (req.session.userId) {
    // Verify IP hasn't changed (optional - can be strict)
    if (req.session.ipAddress !== req.ip) {
      req.session.destroy(() => {
        res.status(401).send('Session invalidated');
      });
      return;
    }
    
    // Check session age
    const maxAge = 30 * 60 * 1000; // 30 minutes
    if (Date.now() - req.session.authTime > maxAge) {
      req.session.destroy(() => {
        res.redirect('/login?expired=true');
      });
      return;
    }
  }
  next();
}
```

---

### 14. Brute Force Attack & Rate Limiting

**The Exploit:**
```typescript
// ATTACKER uses automated tools to try thousands of passwords:
// POST /login { username: "admin", password: "password123" }
// POST /login { username: "admin", password: "password124" }
// ... continues until success

// VULNERABLE: No rate limiting
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username });
  if (user && await compare(password, user.passwordHash)) {
    req.session.userId = user.id;
    res.json({ success: true });
  }
});
```

**The Fix:**
```typescript
import rateLimit from 'express-rate-limit';
import Redis from 'ioredis';

const redis = new Redis();

// Method 1: Global rate limiting
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per window
  message: 'Too many login attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
  // Store in Redis for distributed systems
  store: {
    async incr(key: string) {
      const multi = redis.multi();
      multi.incr(key);
      multi.pexpire(key, 15 * 60 * 1000);
      const results = await multi.exec();
      return { totalHits: results?.[0]?.[1] as number };
    },
    async decrement(key: string) {
      await redis.decr(key);
    },
    async resetKey(key: string) {
      await redis.del(key);
    }
  }
});

// Method 2: Account-specific lockout
async function checkAccountLockout(username: string, ip: string): Promise<{ locked: boolean; remainingTime?: number }> {
  const key = `login_attempts:${username}:${ip}`;
  const attempts = await redis.get(key);
  
  if (attempts && parseInt(attempts) >= 5) {
    const ttl = await redis.ttl(key);
    return { locked: true, remainingTime: ttl };
  }
  
  return { locked: false };
}

async function recordFailedAttempt(username: string, ip: string): Promise<void> {
  const key = `login_attempts:${username}:${ip}`;
  const multi = redis.multi();
  multi.incr(key);
  multi.expire(key, 15 * 60); // Lock for 15 minutes
  await multi.exec();
}

// Secure login endpoint
app.post('/login', loginLimiter, async (req: Request, res: Response) => {
  const { username, password } = req.body;
  const ip = req.ip || 'unknown';
  
  // Check if account is locked
  const lockout = await checkAccountLockout(username, ip);
  if (lockout.locked) {
    return res.status(429).json({
      error: 'Account temporarily locked',
      retryAfter: lockout.remainingTime
    });
  }
  
  const user = await User.findOne({ username });
  if (!user || !(await compare(password, user.passwordHash))) {
    await recordFailedAttempt(username, ip);
    
    // Generic error message (don't reveal if username exists)
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  // Clear failed attempts on success
  await redis.del(`login_attempts:${username}:${ip}`);
  
  // Log successful login
  await AuditLog.create({
    userId: user.id,
    action: 'LOGIN_SUCCESS',
    ipAddress: ip,
    userAgent: req.headers['user-agent'],
    timestamp: new Date()
  });
  
  req.session.userId = user.id;
  res.json({ success: true });
});
```

---

### 15. Credential Stuffing Protection

**The Exploit:**
```typescript
// ATTACKER uses breached credentials from other sites:
// List of (email, password) pairs from previous data breaches
// Automated login attempts using these credentials
// Many users reuse passwords across sites!
```

**The Fix:**
```typescript
import * as crypto from 'crypto';

// Detect credential stuffing by monitoring for:
// 1. Multiple failed logins with different usernames from same IP
// 2. Successful logins after many failures (indicates hit in credential list)

class CredentialStuffingDetector {
  private redis: Redis;
  
  constructor(redis: Redis) {
    this.redis = redis;
  }
  
  async recordAttempt(ip: string, username: string, success: boolean): Promise<{ suspicious: boolean; action: string }> {
    const ipKey = `auth_attempts:${ip}`;
    const userKey = `user_attempts:${username}`;
    
    if (success) {
      // Check if this IP had many failed attempts before success
      const failedAttempts = await this.redis.get(`${ipKey}:failed`);
      if (failedAttempts && parseInt(failedAttempts) > 10) {
        // Likely credential stuffing - many tries, finally succeeded
        await this.flagSuspicious(ip, username, 'CREDENTIAL_STUFFING');
        return { suspicious: true, action: 'REQUIRE_MFA' };
      }
      
      // Clear counters on success
      await this.redis.del(`${ipKey}:failed`);
      await this.redis.del(userKey);
    } else {
      // Increment failure counters
      await this.redis.incr(`${ipKey}:failed`);
      await this.redis.expire(`${ipKey}:failed`, 3600);
      
      // Track unique usernames attempted from this IP
      await this.redis.sadd(`${ipKey}:usernames`, username);
      await this.redis.expire(`${ipKey}:usernames`, 3600);
      
      const uniqueUsers = await this.redis.scard(`${ipKey}:usernames`);
      if (uniqueUsers > 5) {
        // IP trying many different usernames - credential stuffing
        await this.flagSuspicious(ip, username, 'MULTI_USER_ATTACK');
        return { suspicious: true, action: 'BLOCK_IP' };
      }
    }
    
    return { suspicious: false, action: 'NONE' };
  }
  
  private async flagSuspicious(ip: string, username: string, reason: string): Promise<void> {
    await this.redis.setex(`suspicious:${ip}`, 86400, JSON.stringify({
      username,
      reason,
      timestamp: Date.now()
    }));