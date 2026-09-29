**Track lead: Jacob Andersen**

### Overview

Imagine a health system where the citizen is at the centre — where data follows the person, and where every individual has real control over what is shared, with whom, and for how long.

That future is now encoded in law. The European Health Data Space (EHDS), in force since March 2025, grants every EU citizen the right to access, download, and share their personal electronic health data. It also creates a legal framework for citizens to contribute their data — including patient-generated data (PGHD) from wearables and apps — to research under transparent, revocable consent. The standards are converging. The regulation is in force. What does that actually look like, built in FHIR, running today?

This track invites participants to explore that question by building components of a **personal health dataspace**: an ecosystem where a citizen's health data — whether sourced from a hospital EHR, a fitness tracker, a blood glucose monitor, or an environmental sensor — can be stored, shared, and optionally donated to research, all under the citizen's own control.

There is no single prescribed task. Participants are free to build whatever component they find most interesting or meaningful. We do, however, encourage participants to communicate their intentions ahead of the hackathon so that components built on the day can potentially be demonstrated together.

---

### Goals

This track hopes to demonstrate — at least in prototype form — some of the following propositions:

- A citizen-controlled FHIR-based personal health record is technically feasible using existing open standards and open source tools
- Patient-generated health data (PGHD) from wearables and lifestyle apps can be ingested into a PHR as standard FHIR resources
- Data sourced in a PHR can be shared with a new care provider in a cross-border scenario using FHIR and open identity standards
- Citizen consent for both primary and secondary (research) use of health data can be represented and enforced using FHIR Consent resources and established profiles
- Components built independently by different participants can interoperate, at least at the level of exchanging valid FHIR resources against a shared server


### User Journey / Persona: Anne Sørensen

As a common scenario, we will be using the case of *Anne Sørensen* moving from Denmark to Germany:

Anne Sørensen is a 41-year-old woman (fictional test persona) who grew up and has lived her whole life in Denmark, but recently moved to Flensburg, Germany, while continuing
to work in Sønderborg. Her healthcare ties are therefore split — and shifting — between two countries: she holds a Danish pension scheme with private health insurance, keeps
her dentist and physiotherapist in Denmark near her workplace, but is in the process of switching her general practitioner from her long-standing Danish GP to a new German GP
in Flensburg. She is under active treatment for hypertension and type 2 diabetes, and self-reports a penicillin allergy that is not recorded in any of her electronic records.
  
- Age/ID: 41 years old, CPR 110985-9996
- Residence: Flensburg, Germany (recently relocated)
- Work: Sønderborg, Denmark (long-standing workplace, unchanged by the move)
- Insurance/pension: Danish pension scheme with private health insurance
- Dentist & physiotherapist: Denmark, near her workplace in Sønderborg
- General practitioner: currently transitioning — from her Danish GP to a new German GP in Flensburg (a transition period where both relationships may still be valid)
- Diagnoses: Hypertension (SKS DI109 / ICD-10 I10.9), type 2 diabetes (SKS DE119 / ICD-10 E11.9)
- Medication: Ramipril 5mg (ATC C09AA05), Metformin 1000mg (ATC A10BA02), Atorvastatin 40mg (ATC C10AA05)
- Self-reported, not on file anywhere: Penicillin allergy — known only to Anne herself, absent from every system


### The Shared Platform

To give participants something to build *towards* and *against*, the track will provide a number of pre-deployed shared FHIR (R4) servers running
[HAPI FHIR](https://github.com/hapifhir/hapi-fhir). Details about the configuration of each server and its intended use will be published on this
[platform overview page](https://hl7-your-health.projects.alexandrainst.dk/). This page is work in progress, so please monitor it for changes.

Participants are not required to use these servers. Anyone who prefers to run their own FHIR backend (Medplum, another HAPI FHIR instance, Aidbox, etc.)
are welcome to do so. The shared servers exist to lower the barrier of entry and to enable inter-component demos.

A common GitHub repository is set up [here](https://github.com/hl7dk/hackathon-2026-track-3). The intention is that all participants/teams can
clone this repo, create a folder named after their component, and add contents in a shared code space. Initially, this repository is public,
to allow all participants to started. As participants join the hackathon track, they will get write permissions to this repo, and we *may* choose
to close it down to private visibility when the hackathon starts and all relevant participants have been invited in.

The Anne Sørensen character has been added to MitID, NemLogin and FUT test environments, if anyone would like to play with any of these.

All participants are asked to join and monitor the conversation on the
[FHIR Zulip #denmark channel "hackathon 2026 track 3 coordination"](https://chat.fhir.org/#narrow/channel/179182-denmark/topic/hackathon.202026.20track.203.20coordination/with/627790515)
in order to coordinate as much as possible before the hackathon begins.


### Component Ideas

The following is an illustrative — not exhaustive — list of components participants could choose to build. They are organized into four groups. Participants are welcome to address problems in any group – or across. Bring-Your-Own-Idea!

#### Group 1 — Data Sources: Getting data into the PHR

- **EHR → PHR connector**: A SMART on FHIR client that reads resources from a clinical system exposing an [IPA-conformant](https://build.fhir.org/ig/HL7/fhir-ipa/) API and writes them into the shared PHR. A public IPA-conformant sandbox (e.g. [Firely Server sandbox](https://server.fire.ly/) or [HAPI public test server](https://hapi.fhir.org/)) can substitute for a real EHR.
- **MedCom → PHR adapter**: A component that consumes a [MedCom FHIR message](https://medcomdk.github.io/MedComLandingPage/) (e.g. a [ConditionList](https://medcomdk.github.io/dk-medcom-conditionlist/) or [CareCommunication](https://medcomdk.github.io/dk-medcom-carecommunication/)) and stores the relevant resources in the PHR.
- **Apple HealthKit → PHR**: An iOS component (Swift) using [HealthKitOnFHIR](https://github.com/StanfordBDHG/HealthkitOnFHIR) to map HealthKit samples to FHIR Observation resources and POST them to the shared server.
- **Google Health Connect → PHR**: An Android component using the [Health Connect SDK](https://developer.android.com/health-and-fitness/guides/health-connect) to map exercise, sleep, and vital-sign data to FHIR Observations.
- **Withings / Garmin / other wearable → PHR**: A backend service (any language) using a device vendor's REST API to pull measurements and convert them to FHIR Observations.
- **Environmental data → PHR**: A component that pulls open data from [DMI's Open Data API](https://www.dmi.dk/friedata/dokumentation-paa-engelsk) (weather, climate) or other indoor or outdoor climate and air quality sources matching the patient's location, and stores values as FHIR Observations in the PHR.

#### Group 2 — PHR Core: Structuring and validating the dataspace

- **IG conformance**: Profile and validate PHR resources against the [HL7 Personal Health Records IG](https://build.fhir.org/ig/HL7/personal-health-record-format-ig/) and/or other key implementation guides (see the list below). Identify gaps, conflicts and challenges.
- **IPS generator**: A component that queries the shared PHR and produces an [International Patient Summary](https://build.fhir.org/ig/HL7/fhir-ips/) document — the structured cross-border health overview mandated under EHDS priority data categories.
- **DK-Core profiling**: Extend or validate the PHR content against [DK-Core](https://build.fhir.org/ig/hl7dk/dk-core/) profiles, identifying extension points needed for Danish-specific identifiers (CPR, SKS codes, NPU lab codes).

#### Group 3 — Identity, Sharing & Consent: Controlling the dataspace

- **SMART Health Links issuer**: A component that packages selected PHR resources into a [SMART Health Link](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/) — a secure, time-limited, optionally PIN-protected shareable link or QR code. Demonstrates the cross-border USB-stick scenario: an EU citizen arrives at a Danish GP and presents a QR code containing their IPS.
- **FHIR Consent management**: A component that records, updates, and evaluates patient consent using the FHIR `Consent` resource, profiled according to [IHE Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/index.html). The consent should distinguish between clinical use (primary) and research use (secondary).
- **EU Digital Wallet integration**: An experimental component exploring how the [EUDI Wallet](https://github.com/eu-digital-identity-wallet) (EU Digital Identity Wallet reference implementation) can be used as the identity and authorization layer for a PHR SMART on FHIR flow.

#### Group 4 — Secondary Use: Donating data for research

- **Data donation flow**: A component that allows a citizen to select a subset of their PHR data (e.g. six months of Observations from a wearable) and donate it to a research cohort, with a FHIR `Consent` resource recording the donation decision. [Data For Good Foundation](https://dataforgoodfoundation.org/) is an example of a platform that could be a recipient.
- **Consent management service**: An integration with [gICS](https://github.com/mosaic-hgw/gICS) (generic Informed Consent Service, open source, FHIR-enabled), demonstrating how a research-grade consent management tool connects to a citizen-controlled PHR.
- **Research export**: A component that queries the PHR for consented patient data and produces a FHIR Bundle suitable for ingestion into a research platform, respecting the scope encoded in the `Consent` resource.


### Coordination

This track deliberately leaves participants free to choose their own focus. There are no required tasks, and there is no expectation that every participant's work will integrate with everyone else's.

That said, there is real value in knowing what others are building — both to avoid duplication and to enable a more interesting closing demo. Before the hackathon, participants are asked to briefly describe their intended component on the [FHIR Zulip #denmark channel "hackathon 2026 track 3 coordination"](https://chat.fhir.org/#narrow/channel/179182-denmark/topic/hackathon.202026.20track.203.20coordination/with/627790515). The track lead will compile a simple overview and share it at the preparatory webinar.

During the closing session, participants who wish to attempt a live integration demo are encouraged to identify potential "connection points" with other components — but this is entirely optional and should not drive scope decisions on the day.


### Prerequisites

Participants should arrive prepared. Before the hackathon:

- **Read the key IGs**: Familiarise yourself with IGs relevant to your chosen topic, such as [HL7 PHR IG](https://build.fhir.org/ig/HL7/personal-health-record-format-ig/), [IPA](https://build.fhir.org/ig/HL7/fhir-ipa/), and [SMART Health Cards & Links](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/). You do not need to read them in full — a 30-minute skim of the relevant sections may be sufficient.
- **Set up a local FHIR environment**: Have either [HAPI FHIR JPA Server](https://github.com/hapifhir/hapi-fhir-jpaserver-starter) or [Medplum](https://www.medplum.com/docs/self-hosting) running locally via Docker, or have access to a cloud-hosted sandbox.
- **Obtain API credentials for your data sources**: If you plan to work with wearable APIs (Withings, Garmin, Fitbit, etc.) or Google Health Connect, register a developer account and obtain OAuth credentials *before* the hackathon.
- **Prepare test data**: Collect (or fake) some data beforehand, so that you are ready to test and demo the component.
- **Have a FHIR validator ready**: Either the [online FHIR Validator](https://validator.fhir.org/) or a local installation of the [HL7 FHIR Validator CLI](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator).
- **Declare your intent**: Post a brief description of what you plan to build on the [FHIR Zulip #denmark channel "hackathon 2026 track 3 coordination"](https://chat.fhir.org/#narrow/channel/179182-denmark/topic/hackathon.202026.20track.203.20coordination/with/627790515) before the preparatory webinar.


### Expected Outcomes

Participants are not expected to deliver a production-ready system. A successful outcome for any participant is one or more of the following:

- A working or partially working prototype component, with source code in a public repository (GitHub or similar)
- A FHIR resource or Bundle that validates against the relevant IG and can be POSTed to the shared server
- A short write-up (README or a few slides) documenting the approach, the mapping decisions made, and any gaps or surprises encountered in the standards

The track lead will collect links to all repositories and write-ups after the hackathon and compile a summary for the [Results](results.html) page and for the HL7 Denmark pitch session at [eSundhedsobservatoriet](https://2026.e-sundhedsobservatoriet.dk/) on October 7.


### Resources

#### Key standards and implementation guides

| Resource | Description |
|---|---|
| [HL7 Personal Health Records IG](https://build.fhir.org/ig/HL7/personal-health-record-format-ig/) | Core IG for structuring a FHIR-based PHR. |
| [HL7 Personal Health Device IG](https://build.fhir.org/ig/HL7/phd/en/) | Core IG for collecting measurements from personal health devices. |
| [IPA — International Patient Access](https://build.fhir.org/ig/HL7/fhir-ipa/) | Minimum FHIR API a clinical system must expose for patient access. |
| [IPS — International Patient Summary](https://build.fhir.org/ig/HL7/fhir-ips/) | Cross-border patient summary; one of the six EHDS EEHRxF priority categories. |
| [SMART Health Cards & Links IG](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/) | Citizen-controlled, cryptographically verifiable data sharing via QR codes and links. |
| [IHE Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/) | FHIR Consent profiling with OAuth integration; the most complete consent-enforcement profile available. |
| [EU Health Data API IG (EURIDICE)](https://euridice.org/eu-health-data-api/) | Joint HL7 Europe / IHE specification for EHDS Article 15 EHR interoperability component. |
| [HL7 Europe Base/Core IG](https://build.fhir.org/ig/hl7-eu/base/) | Common EU FHIR foundation. |
| [DK-Core IG](https://build.fhir.org/ig/hl7dk/dk-core/) | Danish base profiles: Patient (CPR), Practitioner, Organisation, etc. |
| [DK SMART IG](https://hl7.dk/fhir/smart/index.html) | Danish SMART App Launch Specification. |
| [MedCom FHIR](https://medcomdk.github.io/MedComLandingPage/) | Danish healthcare messaging profiles. |
| [Nordic FHIR Terminology Server](https://tx-nordics.fhir.org/fhir) | Shared terminology server for the Nordic countries. |

#### Open source tools and platforms

| Tool | Language | Description |
|---|---|---|
| [Medplum](https://github.com/medplum/medplum) | TypeScript | Open source FHIR-native platform with SMART on FHIR built in. |
| [HAPI FHIR JPA Server](https://github.com/hapifhir/hapi-fhir-jpaserver-starter) | Java | The canonical open source FHIR server. Stable and well-documented. |
| [gICS — generic Informed Consent Service](https://github.com/mosaic-hgw/gICS) | Java | Open source (AGPL v3) consent management with FHIR gateway. Used in production in German research networks. Docker-ready. |
| [HealthKitOnFHIR](https://github.com/StanfordBDHG/HealthkitOnFHIR) | Swift | Stanford library for mapping Apple HealthKit samples to FHIR Observations. |
| [EUDI Wallet reference implementations](https://github.com/eu-digital-identity-wallet) | Various | EU Digital Identity Wallet — Android, iOS, and issuer libraries. All open source. |
| [SMART Health Links reference](https://github.com/smart-on-fhir/smart-health-links) | TypeScript | Reference implementation of the SMART Health Links specification. |
| [openFHIR](https://github.com/openFHIR/openfhir) | TypeScript | Bidirectional openEHR ↔ FHIR mapping engine. Useful if working with openEHR-based systems. |
| [eHealth Reference Clients](https://github.com/fut-infrastructure/ehealth-reference-clients) | Java | Reference client implementations for the DK eHealth infrastructure (FUT). |

#### Data sources

| Source | Description |
|---|---|
| [DMI's Open Data API](https://www.dmi.dk/friedata/dokumentation-paa-engelsk) | Danish Meteorological Institute: weather, pollen, climate. Free API key required. |
| [Google Health Connect](https://developer.android.com/health-and-fitness/health-connect) | Android aggregation layer for wearable and fitness data. |
| [Apple HealthKit](https://developer.apple.com/documentation/healthkit) | iOS health data platform. |
| [Withings Developer API](https://developer.withings.com/) | REST API for Withings scales, blood pressure monitors, etc. |
| [Garmin Health API](https://developer.garmin.com/gc-developer-program/overview/) | REST API for Garmin wearables. |

#### Context and background reading

| Resource | Description |
|---|---|
| [EHDS Regulation (EU) 2025/327](https://health.ec.europa.eu/ehealth-digital-health-and-care/european-health-data-space-regulation-ehds_en) | The regulation itself and the EU Commission's summary page. |
| [HL7 Data Access Policies IG](https://build.fhir.org/ig/HL7/data-access-policies/) | R6-direction for FHIR Permission resource as complement to Consent. |
| [Data For Good Foundation](https://dataforgoodfoundation.org/) | Danish-based consent-driven data sharing platform; a potential recipient for donated PGHD. |
| [Kanta PHR (Finland)](https://www.kanta.fi/en/system-developers/kanta-phr) | A national PHR for citizens in Finland; useful as a reference architecture. |
| [FHIR Validator](https://validator.fhir.org/) | Online FHIR resource validator. |
| [FHIR Shorthand (FSH)](https://hl7.org/fhir/uv/shorthand/) | If you want to define profiles as part of your work. |


### Results

See the [Results](results.html) page after the hackathon.
