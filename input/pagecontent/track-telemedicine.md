**Track lead: Kirstine Rosenbeck**

### HL7-DK-Hackathon-2026
Velkommen til FHIR Hackathon 2026. Herunder finder du en foreslået sekvens for dagens arbejde, inklusiv de detaljer der skal til for kople op til den opsatte server og den case vi tager udgangspunkt i.

### Sekvens for Hackathon 2026 overblik
* Opsæt dit udviklingsmiljø (info også modtaget pr mail)
* Opret et projekt, find FHIR-pakkerne, test
* Sæt dig ind i dagens case og få et overblik over denne implementation guide 
* Opret et telemedicinsk forløb til en patient
* Upload observationer for fysisik aktivitet og timers søvn på dit forløb på tre på hinanden følgende dage
* På den sidste dag lægges også et spørgeskema-svar på serveren
* Søg efter al data på det telemedicinske forløb for din patient
* Søg efter alle fysisk aktivitets observationer for din patient
* Hvor mange observationer af timers søvn ligger der på serveren? Hvor mange timers søvn får patienterne i gennemsnit?
* Find det spørgeskema-svar du har lagt på serveren. Få herefter Serveren til at retunere selve spørgeskemaet til dig.
* Ekstra efter eget valg fx FHIR-profilering, sikkerhedsmodeller i SMART-ON-FHIR eller intro til danske FHIR projekter.

### Opsæt dit udviklingsmiljø
Til Hackathon er det vigtigt at du medbringer en computer med et kørende udviklingsmiljø. Vi foreslår, at du bruger Java eller .NET (C#). Der er også FHIR referenceimplementeringer i andre sprog, men for at bruge dem, skal du være rimeligt selvkørende.

* Vælger du Java kommer du til at bruge HAPI FHIR referenceimplementeringen. Det kræver ifølge dokumentationen mindst at JDK11 er installeret. Vores erfaring er, at man sagtens kan tage en nyere version fx JDK17. Husk også en IDE fx Intellij.

* Vælger du .NET(C#) kommer du til at bruge Firely .NET SDK. Det kræver .NET 6. Husk en IDE fx Visual Studio eller VS Code

Dokumentation af Firely .NET SDK kan findes her: <https://docs.fire.ly/projects/Firely-NET-SDK/>

### Opret et projekt, find FHIR-pakkerne, test
Nedenstående er eksempler på versioner, nyere versioner anbefales.

#### HAPI FHIR
Make sure that “Gradle support” or "Maven" is working.

Start new single gradle project, go to the build.gradle and add the following Gradle dependencies:

```
// https://mvnrepository.com/artifact/ca.uhn.hapi.fhir/hapi-fhir-base
    implementation group: 'ca.uhn.hapi.fhir', name: 'hapi-fhir-base', version: '6.1.0'

  // https://mvnrepository.com/artifact/ca.uhn.hapi.fhir/hapi-fhir-structures-r4
    implementation group: 'ca.uhn.hapi.fhir', name: 'hapi-fhir-structures-r4', version: '6.1.0'

    // https://mvnrepository.com/artifact/ca.uhn.hapi.fhir/hapi-fhir-client
    implementation group: 'ca.uhn.hapi.fhir', name: 'hapi-fhir-client', version: '6.1.0'

    // https://mvnrepository.com/artifact/org.slf4j/slf4j-simple
    implementation group: 'org.slf4j', name: 'slf4j-simple', version: '1.7.33'
```

-for Maven the dependencies are the same but expressed differently.


Test your setup by making your first HAPI FHIR application. Make a new Java-class and run the following main class. It makes a search for patients with the familiy name 'duck'.

```
// We're connecting to a R4 compliant server in this example
FhirContext ctx = FhirContext.forR4();
String serverBase = "https://hapi.fhir.org/baseR4";

IGenericClient client = ctx.newRestfulGenericClient(serverBase);

// Perform a search
Bundle results = client
   .search()
   .forResource(Patient.class)
   .where(Patient.FAMILY.matches().value("duck"))
   .returnBundle(Bundle.class)
   .execute();

System.out.println("Found " + results.getEntry().size() + " patients named 'duck'");

```

Follow the documentation at https://hapifhir.io/hapi-fhir/docs/client/get_started.html for more guidance on the HAPI FHIR SDK.

### Case: Telemonitorering af psykisk helbred blandt unge mennesker
Der er en stigning i depression/angst blandt unge, og et presset psykiatrisk system. En psykiatrisk afdeling vil gerne, efter endt intensiv behandling af unges depression/angst undgå at følge samme opfølgningsforløb for alle patienter. De vil gerne kunne fange dem tidligt, der får det værre, og undgå at indkalde dem, der har det godt. Praktiserende læger vil gerne bruge samme løsning til at monitorere patienter, hvor der er mistanke om dårligt psykisk helbred, med henblik på at vurdere behov for behandling.
Det besluttes, at lave en løsning der både ser på målinger og overvåger psykiske symptomer. De målinger der indsamles dagligt er: Fysisk aktivitet, i form af type aktivitet og antal minutter. Antal timers søvn.
Desuden administreres følgende spørgeskema en gang hver anden ugen:

**Fællesskab**
* Venskaber
  * Jeg føler mig tæt på mine venner
  * Jeg har venner, men de er ikke tætte mere
  * Jeg har ingen venner
* Lyst til at være sammen med andre
  * Jeg vil gerne være sammen med andre
  * Nogle få gange ugentligt har jeg lyst til at være sammen med andre
  * Jeg har aldrig lyst til at være sammen med andre
* Kærlighed
  * Jeg føler mig elsket
  * Jeg følger mig nogen gange elsket
  * Jeg føler mig ikke elsket

**Daglige opgaver**
* Arbejde/skole forventning
  * Jeg gør det der forventes
  * Jeg gør det der forventes det meste af tiden
  * Jeg gør ikke det der forventes
* Pres
  * Jeg klarer mine daglige opgaver uden at føle mig presset
  * Jeg presser mig selv hele tiden, for at klare mine daglige opgaver
  * Jeg klarer ikke mine daglige opgaver

**Følelser**
* Oplagthed
  * Jeg føler mig klar og frisk de fleste dage
  * Jeg har følt mig uoplagt et par gange om ugen
  * Jeg er hele tiden træt
* Humør
  * Jeg er glad
  * Jeg er er trist det meste af tiden
  * Jeg er trist hele tiden og har trang til at græde hver dag

Casen er sammensat på baggrund af: 
<https://www.researchprotocols.org/2020/6/e16964>
<https://link.springer.com/article/10.1007/s40688-020-00341-6>
<https://en.wikipedia.org/wiki/Children%27s_Depression_Inventory#cite_note-CDI-1>

### Om denne IG
Denne IG overholder i det store hele FUT implementation guiden, men der er ikke lavet en egentlig afhængighed, fordi der var brug for nye koder, da det er en ny klinisk case. Tag et kig derover i løbet af dagen: <https://docs.ehealth.sundhed.dk/latest-released/ig/index.html>
Til gengæld har vi lavet en formel afhængighed mellem denne implementation guide og dk-core <https://hl7.dk/fhir/core/1.1.0/index.html>

Sæt dig ind i de krav der er til data, ved at trykke på artifact summary. Her får du adgang til spørgeskema, profiler, CodeSystems og ValueSets

Profilerne i denne IG ligger også på FHIR serveren, og styrer om I får lov til at aflevere jeres data vha. FHIR valideringsmekanismen. Det kan også testes lokalt, inden man sender en instans afsted vha FHIR-validator find dokumentation her: <https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator>

### Øvrige punkter
Pointen med dagen er, at gøre jer fortrolige med FHIR og den tilhørende dokumnetation. Derfor ikke så mange detaljer her, bare lidt til at sætte jer i gang:

Et telemedicinsk forløb er i denne implementering en episode-of-care, men det kan ikke oprettes uden at kende fx patienten. Enten skal man bundle en episode-of-care med de andre resourses, som den er afhængig af. Ellers kan man sørge for at henvise til de rette instanser, der allerede ligger på serveren.

Der sættes en FHIR server op på dagen, som I kan lægge data på. Alternativt kan der bruges en åben test-server.
