# Results

On October 6, 2026, HL7 Denmark hosted a FHIR Hackathon in Odense, bringing together **38 participants from 23 public and private organisations**.

Across three tracks, participants explored how FHIR can make health data more accessible, interoperable and useful across systems and national borders.

The day resulted in several working prototypes, live demonstrations and valuable discussions about interoperability, security, AI and the business value of health data exchange.

## Track 1: Agentic Patient Access

The track explored how existing healthcare systems and patient-facing services can be made accessible through standard FHIR APIs, supported by AI-assisted development.

**Key results:**
- A working prototype providing read-only FHIR access to medication data from the Danish Shared Medication Record (FMK), demonstrated using test data in the FMK TEST1 environment.
- Further development of *Dhroxy*, an initiative to expose data from the Danish national health portal, sundhed.dk, through FHIR.
- Demonstrations of how AI can accelerate the development of FHIR interfaces to existing healthcare systems.

These results demonstrated the potential of FHIR facades to make existing health data available for new applications without replacing the underlying systems.

## Track 2: Telemedicine

The telemedicine track introduced participants to FHIR through hands-on exercises based on real-world telemedicine scenarios.

Participants worked with FHIR resources representing telemedicine care pathways, clinical observations and questionnaire responses. They collaborated in three groups based on their experiences with FHIR and coding skills. 

The track provided practical experience with FHIR while encouraging discussions about how standardised health data can support connected telemedicine solutions.

## Track 3: Your Health, Your Data

This track explored how a citizen's health data could follow her across a national border, and how she could control access to it. Participants organised into groups of 1–2 people, each building
a single component against a shared cross-border persona and a common set of three FHIR test servers — standing in for a personal health record, a German GP practice system, and a German hospital
system, each using a different set of profiles. At the end of the day, the four components were combined into one live demo: starting from data fragments about the citizen spread across the three
servers, blood-pressure measurements recorded via the existing Telma app and collected in the Danish FUT telemedicine infrastructure (not built during the hackathon) were imported into the
personal health record; the consent/sharing component was then used to trigger bidirectional exchange between all three systems, with the translation component handling the profile mapping, so
that all data — both the original fragments and the new measurements — ended up available everywhere. A Swedish health app was finally used to visualise the Telma-derived measurements.

**Key results:**
- A successful live demonstration of health data exchange from the Danish FUT telemedicine infrastructure to external FHIR servers in Germany and display of values for a German GP and Hospital. 
- The citizen had to give consent before sharing the information with the German GP and Hospital. 
- Mapping of most of the relevant Danish terminology to corresponding German terminology.
- Successful import and visualisation of the same data in a Swedish application.

The demonstrations highlighted how FHIR can support cross-border interoperability and enable health data to be reused in different healthcare applications; and how four independently built,
single-purpose components — developed by separate groups with no shared codebase — were composed into one working cross-border demo on the day, a small-scale demonstration that standards-based
interoperability lets loosely-coupled components deliver working results fast.

## Key takeaways

One of the most interesting observations from the hackathon was the impact of AI-assisted development.

Across all three tracks, AI helped participants overcome technical challenges faster than expected. As a result, discussions increasingly shifted from implementation details towards more fundamental questions about interoperability, security, governance and business value.

The hackathon demonstrated that making existing health data available through FHIR can open new opportunities for innovation, both nationally and internationally. 

Further the hackathon showed us that a prototype of an application can be made very fast, so the value of the application can be addressed, before making a full implementation.

## Presentations and further information

The results were presented at [E-sundhedsobservatoriet 2026 (website)](https://2026.e-sundhedsobservatoriet.dk/) on October 7.

- [Presentation: From Talk to Code – Results from the Danish HL7 FHIR Hackathon (website)](https://2026.e-sundhedsobservatoriet.dk/wp-content/uploads/sites/41/2026/10/Slides_E1_Jens_Kristian_Villadsen.pdf)
- [Slides from the hackathon (pdf)](documents/HL7-DK-Hackathon-20261006.pdf)

**Thank you to all participants and track leads** for contributing to a successful day of collaboration, knowledge sharing and innovation!

## Pictures from the day 
<img src = "documents/IMG_1415.JPG" height = "400">
<img src = "documents/IMG_1419.JPG" height = "400">
<img src = "documents/IMG_1457.jpeg" width = "400">
<img src = "documents/FullSizeRender.jpeg" width = "400">
<img src = "documents/IMG_1463.jpeg" width = "400">
<img src = "documents/IMG_1466.jpeg" width = "400">
<img src = "documents/IMG_1468.jpeg" width = "400">

