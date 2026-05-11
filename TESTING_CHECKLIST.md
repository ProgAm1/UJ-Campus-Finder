# Manual Testing Checklist — UJ Campus Finder

Use this checklist after any change. Automated coverage: `npm test` (129 tests, DB mocked).

## 1. Pages load (static routing)
- [ ] `GET /` → home page (index.html)
- [ ] `GET /index.html` → home page
- [ ] `GET /html/reports.html` (or `/reports.html`) → Reports page
- [ ] `GET /html/claim.html` → Claim page
- [ ] `GET /html/contact-us.html` → Contact page
- [ ] `GET /html/about-us.html` → About page
- [ ] CSS/JS/media load (no 404 in Network tab): `/css/style.css`, `/css/responsive.css`, `/js/main.js`, `/js/validation.js`, `/media/*`
- [ ] Unknown page (e.g. `/nope`) → "404 — Page not found" (never "Cannot GET")
- [ ] Unknown API route (e.g. `/api/nope`) → JSON `{ success:false, message:"Not found" }`

## 2. Server & database health
- [ ] `GET /api/test` → `{ success:true, message:"API is working" }`
- [ ] `GET /api/health` with DB up → `200 { success:true, server:"up", database:"up" }`
- [ ] `GET /api/health` with DB stopped → `503 { success:false, ..., database:"down" }` and the server stays alive
- [ ] Start the server with MySQL stopped → console logs a clear error, app does not crash; Reports page shows the "Backend unavailable — sample data" banner

## 3. Report a Lost/Found item (Reports page modal)
- [ ] Open modal via "I Lost Something" / "I Found Something" — title and hidden type update
- [ ] Submit with empty required fields → inline errors shown, no request sent
- [ ] Fields enforce `maxlength` (title 120, name 60, contact 100, description 1000)
- [ ] Upload a non-image file → backend rejects with 400 "Only image files…"
- [ ] Upload an image > 5 MB → backend rejects with 400
- [ ] Valid submission (with and without photo) → toast "Report submitted successfully!", grid refreshes, new card appears, photo shows in View Details
- [ ] Whitespace-only inputs are rejected by the backend (400)

## 4. View Details modal (Reports page)
- [ ] "View Details" opens modal with the correct item data
- [ ] Item with a photo shows the image; broken image path hides the image block
- [ ] User-supplied text is HTML-escaped (try a title like `<b>x</b>` — shows literally, no bold/script)
- [ ] Close via X, Cancel, overlay click, and Escape key

## 5. Filters / search / sort (Reports page)
- [ ] Type radio (All / Lost / Found) filters correctly
- [ ] Location checkboxes filter correctly (multi-select)
- [ ] Status checkboxes filter correctly
- [ ] Search box filters by title/description/location/reporter
- [ ] Sort: Newest / Oldest / A–Z / Z–A
- [ ] "Clear filters" / "Reset filters" restores defaults
- [ ] Empty result shows the empty-state panel and "No reports found" count

## 6. Claim form (claim.html)
- [ ] Submit button is disabled until all fields are valid
- [ ] Report ID: only digits accepted; non-positive / empty → error
- [ ] Visiting `claim.html?id=5` pre-fills and locks the Report ID field
- [ ] Full name: letters only, 2–60 chars; invalid → error
- [ ] Student/Staff ID: exactly 7 digits; otherwise error
- [ ] University email: must end `@uj.edu.sa`; otherwise error
- [ ] Phone: `05` + 8 digits; otherwise error
- [ ] Proof of ownership: min 20 chars; otherwise error
- [ ] Backend: non-existent Report ID → 404 "Report not found — please check the Report ID"
- [ ] Backend: malformed email → 400
- [ ] Valid submission → success panel shown, form hidden
- [ ] Network failure → error toast, button restored

## 7. Contact form (contact-us.html)
- [ ] Submit button disabled until valid
- [ ] First/last name: letters only, 2–60 chars
- [ ] Gender select: required, value must be `male` / `female` / `prefer_not_to_say`
- [ ] Mobile: 7–15 chars, digits/`+`/space/`-` only
- [ ] Date of birth: required
- [ ] Preferred language: required, value must be `arabic` / `english` / `french`
- [ ] Email: valid format
- [ ] Subject: min 3 chars; Message: min 10 chars
- [ ] Backend rejects missing required fields, bad email, bad gender/language whitelist value (400)
- [ ] Valid submission → row saved to `contact_messages`; if `RESEND_API_KEY` + `CONTACT_TO_EMAIL` set, notification email sent
- [ ] If email send fails, message is still saved and response notes `emailError:true`
- [ ] Valid submission → success toast, form reset, button disabled again

## 8. API routes (quick curl/Postman)
- [ ] `GET /api/reports` → `{ success:true, data:[...] }`
- [ ] `GET /api/reports/:id` (missing) → 404
- [ ] `POST /api/reports` (multipart) → 201
- [ ] `PUT /api/reports/:id/status` with `{status:"resolved"}` → 200; bad status → 400; missing id → 404
- [ ] `DELETE /api/reports/:id` → 200; missing → 404
- [ ] `GET /api/claims` → `{ success:true, data:[...] }`
- [ ] `POST /api/claims` → 201 / 400 / 404 as per rules above
- [ ] `PUT /api/claims/:id/status` with `{status:"approved"}` → 200; bad status → 400
- [ ] `GET /api/contact` → `{ success:true, data:[...] }`
- [ ] `POST /api/contact` → 201 / 400 as per rules above
- [ ] DB errors return safe JSON (`500 { success:false, message:"Failed to …" }`), never a stack trace

## 9. Browser & responsive
- [ ] No errors in the browser console on any page
- [ ] Mobile nav toggle works (hamburger ↔ X)
- [ ] Reports sidebar filter collapses/expands on small screens
- [ ] Layout holds at ~375 px, ~768 px, ~1024 px, and desktop

## 10. Known issues / notes
- Mock report cards (IDs like `RPT-2026-001`) appear only when the API is unreachable; their "Claim" button is intentionally hidden because those IDs are not in the database.
- Email notifications require `RESEND_API_KEY` and `CONTACT_TO_EMAIL` in `.env`; without them the contact form still saves to the DB and returns success.
- Direct database testing in CI is mocked; to test against real MySQL, import `database/schema.sql` into a throwaway database first.
