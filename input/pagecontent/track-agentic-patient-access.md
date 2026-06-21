**Track lead: Jens Villadsen**

### Overview

This track explores whether AI agents can give patients programmatic, FHIR-based access to Danish health data portals that do **not** natively expose a FHIR API. The approach is inspired by the [Dhroxy](https://github.com/c3po-initiative/Dhroxy) project, developed as part of the [c3po initiative](https://github.com/orgs/c3po-initiative/repositories), which already uses AI agents to map the data models and REST APIs of [sundhed.dk](https://www.sundhed.dk/) onto a FHIR REST interface.

In a Danish setting, sundhed.dk is only the beginning. Patients meet their data through a fragmented landscape of GP apps, regional booking portals and national registers — most of which have no FHIR endpoint at all. The challenge for this track is to pick one of these portals and stand up a FHIR facade in front of it, reusing and extending the c3po patterns rather than starting from scratch.

To make this concrete, the track leans on two c3po assets:

- **[Dhroxy](https://github.com/c3po-initiative/Dhroxy)** — a working Kotlin reference proxy for sundhed.dk you can extend or learn from.
- **[c3po add-ons](https://github.com/c3po-initiative/add-ons)** — a Claude Code plugin whose `fhir-facade-plan` skill walks you from a captured HAR/OpenAPI all the way to an implementation plan (see [Using the c3po add-ons plugin](#using-the-c3po-add-ons-plugin) below).

### Goals

- Reverse-engineer the HTTP/API traffic of a patient-facing Danish health portal that does not expose a FHIR API
- Build an AI-assisted proxy (or FHIR facade) that translates the portal's internal data into FHIR R4 resources
- Profile the output against the Danish national profiles — [dk-core](https://hl7.dk/fhir/core/) and the [eHealth Infrastructure IG](https://ehealth.sundhed.dk/fhir/) (`dk.ehealth.sundhed.fhir.ig.core`) — not just vanilla R4
- Document the approach so others can replicate it for other portals and contribute it back to the c3po initiative

### Candidate Danish Systems

The table below lists ten Danish patient-facing portals and central systems that are not (yet) reachable as FHIR. Any of these are valid targets. Participants are also welcome to bring their own favourite portal.

Two things are common to almost all of them: citizens authenticate with **[MitID](https://www.mitid.dk/)** (typically brokered through **NemLog-in** as OIDC/SAML), and the patient is identified by **CPR-nummer** — the Danish equivalents of the Swedish BankID and personnummer. National backend services on the **NSP** ([Den Nationale Serviceplatform](https://www.nspop.dk/)) add their own layer: professional access uses a **SOSI ID-kort** SAML assertion over **DGWS** (Den Gode Webservice, SOAP), while delegated citizen access uses **OIO-IDWS**, all carried over **Sundhedsdatanettet (SDN)**.

| # | System | Operator | Patient access | Authentication | FHIR target resources |
|---|--------|----------|----------------|----------------|-----------------------|
| 1 | [sundhed.dk](https://www.sundhed.dk/) / MinSundhed app | Sundhedsdatastyrelsen, Danske Regioner & KL | **Direct** — MitID login | MitID via NemLog-in (OIDC) → session cookie; CPR identifies the citizen | `Patient`, `Condition`, `Observation`, `MedicationStatement`, `Immunization`, `AllergyIntolerance`, `DocumentReference` — *already partly covered by [Dhroxy](https://github.com/c3po-initiative/Dhroxy); the natural starting point is to extend it* |
| 2 | [Min Læge](https://minlaegeapp.dk/) (minlaegeapp.dk) | PLO / Sundhedsministeriet; clinical data brokered via PLSP | **Direct** — MitID | MitID → app session token; GP-record data is exposed only after the citizen grants consent, then served from the Primary Sector's service platform (PLSP) | `Appointment`, `Communication` (e-konsultation), `MedicationRequest` (receptfornyelse), `Observation`/`DiagnosticReport` (prøvesvar), `Immunization` |
| 3 | [MineAftaler Region Midtjylland](https://booking.rm.dk/MineAftaler/) (booking.rm.dk) | Region Midtjylland (BookPlan) | **Direct** — MitID, or anonymous via booking number (bon-nummer) | MitID → session cookie; a bon-nummer from the appointment letter grants scoped anonymous access to a single appointment | `Appointment`, `Schedule`, `Slot` |
| 4 | [MineAftaler Region Nordjylland](https://booking.rn.dk/) (booking.rn.dk) | Region Nordjylland (BookPlan) | **Direct** — MitID | Same BookPlan pattern as Region Midtjylland | `Appointment`, `Schedule`, `Slot` |
| 5 | [Mit Sygehus / MineAftaler Syddanmark](https://mit.rsyd.dk/) (mitsygehus.dk) | Region Syddanmark (Medware) | **Direct** — MitID | MitID → session; consent required on first login. *Note: Mit Sygehus closed 28 May 2026 and was replaced by MineAftaler Syddanmark — target the current app* | `Appointment`, `Communication`, `CarePlan`, `DocumentReference` |
| 6 | [Min Sundhedsplatform](https://minsp.dk/) (minsp.dk) | Region Hovedstaden & Region Sjælland (Epic MyChart) | **Direct** — MitID | MitID → MyChart session. Epic speaks FHIR internally (see [fhir.epic.com](https://fhir.epic.com/)), but the regions publish **no** patient-facing FHIR endpoint — the MyChart web/JSON API has to be mapped | `Patient`, `Observation`, `DiagnosticReport`, `Appointment`, `MedicationRequest`, `DocumentReference` |
| 7 | [Fælles Medicinkort (FMK)](https://www.fmk.dk/) | Sundhedsdatastyrelsen (NSP) | **Indirect** — citizens see FMK via sundhed.dk / Min Læge; a direct B2B interface exists | Citizen access: MitID → **OIO-IDWS** SAML token; professional access: **SOSI ID-kort** + **DGWS** SOAP over SDN. No public REST/FHIR | `MedicationStatement`, `MedicationRequest`, `MedicationDispense` |
| 8 | [Det Danske Vaccinationsregister (DDV)](https://www.sundhedsdatastyrelsen.dk/) | Sundhedsdatastyrelsen (NSP) | **Indirect** — viewed via sundhed.dk & Min Læge (MitID) | Same NSP pattern as FMK: MitID/OIO-IDWS (citizen) or SOSI/DGWS (professional) | `Immunization` |
| 9 | [WebReq / WebPatient](https://www.webreq.dk/) | DXC Technology / regional laboratories | **Direct (WebPatient)** — MitID; results mostly surfaced via sundhed.dk | MitID → session; WebPatient serves patient-entered questionnaires, while lab orders/results flow over MedCom EDIFACT/XML behind the scenes | `ServiceRequest`, `DiagnosticReport`, `Observation`, `QuestionnaireResponse` |
| 10 | [Min Graviditet / Graviditetsmappen](https://sundhedsdatastyrelsen.dk/digitale-loesninger/digitalt-graviditetsforloeb/app) | Sundhedsdatastyrelsen (NSP) | **Direct** — MitID | MitID → app session; measurements, scan results and consultation notes are drawn from the national Graviditetsmappe on the NSP | `Observation` (målinger/scanninger), `CarePlan` (forløb), `Appointment`, `DocumentReference` (noter) |

> **Note:** Some Danish systems are deliberately *not* on this list because they already speak FHIR — you should map *to* these, not reverse-engineer them:
> - The national **"Et samlet patientoverblik"** services — *Aftaleoversigt*, *Fælles Stamkort*, *Planer og indsatser* — are FHIR R4 services on the NSP.
> - The **eHealth Infrastructure / FUT** platform ([ehealth.sundhed.dk/fhir](https://ehealth.sundhed.dk/fhir/), package `dk.ehealth.sundhed.fhir.ig.core`) is a national FHIR R4 backbone for telemedicine and shared care — and the conformance target for the resources you produce in this track.
> - **[Dhroxy](https://github.com/c3po-initiative/Dhroxy)** already proxies much of **sundhed.dk** to FHIR — extend it rather than starting over.

Most of these systems also have Android apps on Google Play (e.g. *Min Læge*, *MinSundhed*, *MineAftaler*, *Mit Sygehus*, Epic *MyChart*). These apps are valid targets for decompilation and static analysis (e.g. using [jadx](https://github.com/skylot/jadx) or [apktool](https://apktool.org/)) and can reveal API endpoints, request formats, and authentication flows that are not documented anywhere publicly.

> **A note on fair game:** Treat every portal here as a black box and work only from what you can observe yourself — your own test/personal login, traffic you capture, and a publicly available APK. Don't rely on internal or vendor-confidential knowledge of how any of these systems are built.

### Prerequisites

Attendees need to bring three things:

1. **A target system** — either pick one from the table above or bring your own favourite Danish health portal that is not already on FHIR
2. **An AI tool** to which you have a license (Claude Code, Cursor, Copilot, or similar)
3. **The [c3po add-ons](https://github.com/c3po-initiative/add-ons) plugin** installed (if you use Claude Code) — see below

Everything else should be possible to do at the hackathon.

### Tasks

1. **Explore** — Log into your target portal with a test or personal account and capture the HTTP traffic using one of the methods below. Identify the key API calls that return health data.
   - **Browser DevTools — Copy as cURL** — The quickest way to capture a single request. Open the Network tab, right-click any request, and choose **Copy → Copy as cURL** (see [full tutorial](https://www.scrapingbee.com/tutorials/how-to-extract-curl-requests-from-chrome/)). The result is a self-contained shell command you can paste directly into a terminal or hand to an AI tool:
     ```bash
     curl 'https://booking.rm.dk/MineAftaler/api/appointments' \
       -H 'Accept: application/json' \
       -H 'X-Requested-With: XMLHttpRequest' \
       -H 'Cookie: SESSION=abc123; XSRF-TOKEN=xyz'
     ```
   - **Browser DevTools — Export HAR** — Right-click anywhere in the Network tab request list and choose **Save all as HAR with content**, or use the download icon. A HAR file captures the full session (all requests, all responses, all headers) in one JSON file — better than individual cURL commands when you want an AI to reason across many requests at once.
   - **Proxy** — Route traffic through [mitmproxy](https://mitmproxy.org/) or Charles Proxy for richer inspection and scripting.
   - **Android app decompilation** — If the portal has an Android app, download the APK and decompile it with [jadx](https://github.com/skylot/jadx) or [apktool](https://apktool.org/) to extract hardcoded endpoints and request schemas without needing to intercept live traffic.

   > **Tip:** Before feeding a HAR file to an AI tool, scrub or replace real patient values (names, CPR-numre, dates of birth) with synthetic equivalents — the structure and field names are what matter for mapping, not the actual data. [har-sanitizer](https://github.com/cloudflare/har-sanitizer) (Cloudflare) can help automate this step. Alternatively, [chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) lets an AI agent connect directly to Chrome DevTools and observe network traffic in real time, skipping the manual export step entirely.
2. **Map** — For each data type returned (appointments, lab results, medications, …) identify the closest FHIR R4 resource and draft a simple mapping table. Where a Danish profile exists, map to it: prefer [dk-core](https://hl7.dk/fhir/core/) profiles and the [eHealth Infrastructure IG](https://ehealth.sundhed.dk/fhir/) (`dk.ehealth.sundhed.fhir.ig.core`) over plain R4, and use Danish/Nordic code systems (CPR, SOR, the [Nordic terminology server](https://tx-nordics.fhir.org/fhir)) where they apply.
3. **Build** — Use an AI coding agent to scaffold a lightweight proxy server (any language/framework) that authenticates against the target portal and re-exposes the data as FHIR R4. If you are working in Claude Code, drive the planning with the **`fhir-facade-plan`** skill from the c3po add-ons plugin (see below). If your target is sundhed.dk, start from [Dhroxy](https://github.com/c3po-initiative/Dhroxy) instead of an empty repo.
4. **Validate** — Run the FHIR responses through the [FHIR validator](https://validator.fhir.org) or a local validator, with the Danish packages loaded so you check conformance against the real national profiles:
   ```bash
   java -jar validator_cli.jar myresource.json \
     -version 4.0.1 \
     -ig dk.ehealth.sundhed.fhir.ig.core#9.0.1 \
     -ig hl7.fhir.dk.core
   ```
5. **Document** — Write a short README that explains the authentication flow (MitID/NemLog-in, and any NSP/OIO-IDWS hops), the endpoint mapping, and any known limitations.
6. **API Documentation** — Consider using [api-mapper](https://github.com/mikkelkrogsholm/api-mapper) to turn your captured traffic into an OpenAPI spec.

### Using the c3po add-ons plugin

The [c3po add-ons](https://github.com/c3po-initiative/add-ons) repository is a Claude Code plugin that packages the `fhir-facade-plan` skill. The skill *is* the planning workflow this track is built around: you hand it your captured HAR (and optionally an OpenAPI spec), and it walks Phases 1–5 below — HAR/OpenAPI analysis → FHIR resource mapping → tech-stack recommendation → architecture → implementation roadmap — entirely in plan mode, surfacing decisions for your approval before any code is written.

**Install it** (Claude Code):

```sh
git clone https://github.com/c3po-initiative/add-ons.git
# then, inside Claude Code:
/plugin install /absolute/path/to/add-ons
```

**Invoke it** — once installed, just point it at your sanitized capture:

> "Plan a FHIR facade for `./minelaftaler.har` and `./openapi.yaml`, targeting the Danish dk-core and dk.ehealth.sundhed.fhir.ig.core profiles."

If you are *not* using Claude Code, the skill's full prompt is reproduced below — paste it into your AI tool of choice and provide the same inputs.

#### The fhir-facade-plan prompt (manual fallback)

```
# FHIR Facade Implementation — Plan Mode

You are a senior healthcare integration engineer. Your task is to **analyze provided artifacts and produce a detailed implementation plan** for a FHIR R4 facade layer before writing any code.

## Inputs provided
- One or more **HAR files** (browser network captures) showing real HTTP traffic from the underlying proprietary API
- An **OpenAPI specification** describing the underlying API's endpoints, schemas, and authentication
- The **target FHIR profiles**: Danish dk-core (hl7.fhir.dk.core) and the eHealth Infrastructure IG (dk.ehealth.sundhed.fhir.ig.core). Conform to these, not just base R4, where applicable.

---

## Phase 1 — Analysis (complete before any planning)

### HAR file analysis
For each HAR file:
1. Identify all unique API endpoints called (method + path)
2. Extract request headers and authentication patterns (tokens, cookies, API keys)
   - **Note:** If the HAR contains login/auth flows (e.g. MitID/NemLog-in redirects, `/oauth/token`, `/auth`), you may **skip detailed analysis of those flows** unless they reveal something structurally important about how session tokens are used downstream. Just note that auth exists and what credential type is passed on subsequent requests.
3. Document request/response payload shapes with representative field names and value types
4. Note pagination patterns, error response formats, and any behaviors not reflected in the OpenAPI spec
5. Flag discrepancies between actual HAR traffic and the OpenAPI spec

### OpenAPI spec analysis
1. List all available endpoints and operations
2. Identify data models and their fields
3. Note authentication/authorization schemes (summary only — implementation detail deferred)
4. Flag endpoints that appear unused or absent in the HAR captures

---

## Phase 2 — FHIR Resource Identification & Mapping

**Infer the appropriate FHIR R4 resources from the HAR and OpenAPI data.** Do not assume a fixed resource set — let the underlying data model drive what FHIR resources make sense to expose. Prefer the Danish profiles (dk-core, dk.ehealth.sundhed.fhir.ig.core) and Danish/Nordic code systems (CPR, SOR) over plain R4 where they fit.

For each identified mapping:

| Underlying resource (HAR/OpenAPI) | FHIR R4 Resource / Danish profile | Confidence | Mapping notes / gaps |
|-----------------------------------|-----------------------------------|------------|----------------------|
| ...                               | ...                               | High/Med/Low | ...                |

For each FHIR resource:
- Which underlying API calls are needed to populate it?
- What field-level transformations are required (renaming, type coercion, unit conversion, code system mapping)?
- Which mandatory FHIR fields cannot be populated from available data? (mark for `extension`, stub value, or omission with justification)
- Which FHIR search parameters (`_id`, `subject`, `date`, etc.) can be realistically supported?

---

## Phase 3 — Tech Stack Recommendation

Based on the complexity, payload shapes, and patterns observed in the HAR/OpenAPI data, recommend the most appropriate tech stack for this facade. Consider:

- **Ecosystem maturity** for FHIR (existing libraries, validators, terminology servers)
- **Transformation complexity** — if mappings are heavy, prefer a language with strong data manipulation ergonomics
- **Operational simplicity** — prefer something deployable as a single service without heavy infrastructure
- **Reuse** — if the target is sundhed.dk, the Kotlin Dhroxy proxy is the obvious base; factor that in
- **Team familiarity signals** — if the OpenAPI spec or HAR reveals tech clues (e.g. JSON conventions, versioning style), factor that in

Provide a brief justification for your recommendation and name any key libraries (e.g. `fhir.js`, `fhirpy`, `HAPI FHIR`, `medplum`, Firely .NET SDK).

---

## Phase 4 — Architecture Plan

Outline the facade's internal structure:

1. **Layer breakdown**
   - FHIR REST layer — handles incoming FHIR requests, routing, and basic validation
   - Mapping/translation layer — bidirectional transforms between FHIR and proprietary models
   - Upstream client layer — calls the underlying API; handles auth token injection, retries, and error normalization
2. **Authentication strategy**
   - How the facade authenticates *to* the upstream API (based on HAR evidence — MitID/NemLog-in session, NSP OIO-IDWS token, header name, refresh pattern)
   - How the facade authenticates *its own callers* (recommend a sensible default; note this can be swapped out)
   - Flag whether credential handling can be simplified or stubbed for an initial implementation
3. **Caching strategy** — where caching adds value given observed traffic patterns
4. **Error handling** — how upstream errors map to FHIR `OperationOutcome` responses
5. **Capability statement** — what the `/metadata` endpoint will advertise

---

## Phase 5 — Implementation Roadmap

Break work into ordered milestones. For each, list the modules/files to be created:

- **Milestone 1:** Project scaffold + upstream API client (raw calls working, auth token injected)
- **Milestone 2:** First FHIR resource end-to-end — pick the simplest/most complete mapping from Phase 2
- **Milestone 3:** Remaining FHIR resources in priority order
- **Milestone 4:** Search parameter support
- **Milestone 5:** Validation against the Danish profiles, error normalization, `/metadata` conformance statement
- **Milestone 6:** Tests — unit for mappers, integration against a FHIR validator, contract tests

---

## Flags & Decisions Required

Before finishing the plan, surface:
- **Ambiguities** in the HAR/OpenAPI that need a human decision before implementation can proceed
- **Mandatory FHIR fields** that are unavailable from the source system and require a policy decision
- **Security observations** from the HAR (tokens in query strings, missing headers, overly broad scopes)
- **Scope recommendations** — if the HAR reveals the system is large, suggest a phased scope rather than boiling the ocean

---

**Do not write implementation code yet.**
Deliver the full analysis and plan, then pause and wait for review and approval before proceeding.
```

### Expected Outcomes

- A GitHub repository (or a branch in an existing repo) containing a working or partially working FHIR proxy/facade for at least one non-FHIR Danish health system
- A mapping document (could be a simple markdown table) showing how the target system's data model maps to FHIR R4 — ideally to the Danish dk-core / eHealth Infrastructure profiles
- A short demo or write-up suitable for contributing back to the [c3po initiative](https://github.com/orgs/c3po-initiative/repositories)

### Resources

- [c3po initiative repositories](https://github.com/orgs/c3po-initiative/repositories) — reference implementations including Dhroxy (Denmark) and inroxy (Sweden)
- [Dhroxy](https://github.com/c3po-initiative/Dhroxy) — a working FHIR proxy that maps sundhed.dk to a FHIR REST interface; the natural starting point for a sundhed.dk target
- [c3po add-ons](https://github.com/c3po-initiative/add-ons) — Claude Code plugin providing the `fhir-facade-plan` skill used in this track
- [eHealth Infrastructure FHIR IG](https://ehealth.sundhed.dk/fhir/) — Danish national FHIR R4 profiles (`dk.ehealth.sundhed.fhir.ig.core`); the conformance target for your output
- [dk-core](https://hl7.dk/fhir/core/) — HL7 Denmark's base FHIR profiles (Patient, Organization, etc.)
- [NSP / nspop](https://www.nspop.dk/) — documentation for Den Nationale Serviceplatform and its security services (DGWS, OIO-IDWS, SOSI)
- [MedCom](https://www.medcom.dk/) — Danish standards body for healthcare data exchange
- [FHIR Validator](https://validator.fhir.org) — validate FHIR resources online
- [chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) — MCP server that gives an AI agent direct access to Chrome DevTools (network tab, console, DOM) — useful for live traffic inspection without a manual HAR export
- [api-mapper](https://github.com/mikkelkrogsholm/api-mapper) — turn captured traffic into an OpenAPI spec

### Results

See the [Results](results.html#agentic-patient-access) page.
