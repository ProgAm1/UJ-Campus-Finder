// Integration tests for the Express app itself:
// static pages, the liveness check, the DB health check, and 404 behaviour.
// The database is fully mocked so no real MySQL connection is needed.

const request = require('supertest');

jest.mock('../../backend/db', () => ({ query: jest.fn() }));

const app = require('../../backend/app');
const db  = require('../../backend/db');

beforeEach(() => {
    jest.clearAllMocks();
});

// ── Static pages ──────────────────────────────────────────────────────────────
describe('Static pages', () => {
    test('GET / serves the home page', async () => {
        const res = await request(app).get('/');
        expect(res.status).toBe(200);
        expect(res.text).toMatch(/UJ Campus Finder/i);
    });

    test('GET /index.html serves the home page', async () => {
        const res = await request(app).get('/index.html');
        expect(res.status).toBe(200);
        expect(res.text).toMatch(/UJ Campus Finder/i);
    });

    test('GET /reports.html serves the reports page', async () => {
        const res = await request(app).get('/reports.html');
        expect(res.status).toBe(200);
        expect(res.text).toMatch(/<html/i);
    });

    test('GET /css/style.css serves the stylesheet', async () => {
        const res = await request(app).get('/css/style.css');
        expect(res.status).toBe(200);
    });

    test('GET /js/validation.js serves the validation script', async () => {
        const res = await request(app).get('/js/validation.js');
        expect(res.status).toBe(200);
    });
});

// ── /api/test (liveness) ──────────────────────────────────────────────────────
describe('GET /api/test', () => {
    test('returns 200 and success', async () => {
        const res = await request(app).get('/api/test');
        expect(res.status).toBe(200);
        expect(res.body.success).toBe(true);
    });
});

// ── /api/health (DB check) ────────────────────────────────────────────────────
describe('GET /api/health', () => {
    test('returns 200 when the database answers', async () => {
        db.query.mockResolvedValueOnce([[{ 1: 1 }]]);
        const res = await request(app).get('/api/health');
        expect(res.status).toBe(200);
        expect(res.body).toEqual({ success: true, server: 'up', database: 'up' });
    });

    test('returns 503 when the database is down (does not crash)', async () => {
        db.query.mockRejectedValueOnce(new Error('connection refused'));
        const res = await request(app).get('/api/health');
        expect(res.status).toBe(503);
        expect(res.body).toEqual({ success: false, server: 'up', database: 'down' });
    });
});

// ── 404 behaviour ─────────────────────────────────────────────────────────────
describe('Unknown routes', () => {
    test('unknown /api/* route returns JSON 404', async () => {
        const res = await request(app).get('/api/does-not-exist');
        expect(res.status).toBe(404);
        expect(res.body.success).toBe(false);
    });

    test('unknown page returns a 404 message (never "Cannot GET")', async () => {
        const res = await request(app).get('/no-such-page');
        expect(res.status).toBe(404);
        expect(res.text).not.toMatch(/Cannot GET/i);
    });
});
