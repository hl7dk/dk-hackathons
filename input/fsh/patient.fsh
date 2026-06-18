Profile: TelemedicinePatient
Parent: DkCorePatient
Description: "An example profile of the Patient resource."
* name 1..* MS

Instance: PatientExample
InstanceOf: TelemedicinePatient
Usage: #example
* identifier.use = #official
* identifier.system = "urn:oid:1.2.208.176.1.2"
* identifier.value = "2512489996"
* name.use = #official
* name.family = "Berggren"
* name.given[0] = "Nancy"
* name.given[+] = "Ann"
* telecom[0].system = #other
* telecom[=].value = "NemSMS"
* telecom[+].system = #other
* telecom[=].value = "eBoks"
* gender = #unknown
* address.extension[0].url = "http://hl7.dk/fhir/core/StructureDefinition/dk-core-municipalityCodes"
* address.extension[=].valueCodeableConcept = http://hl7.dk/fhir/core/CodeSystem/dk-core-municipality-codes#0330
* address.extension[+].url = "http://hl7.dk/fhir/core/StructureDefinition/dk-core-RegionalSubDivisionCodes"
* address.extension[=].valueCodeableConcept = http://hl7.dk/fhir/core/CodeSystem/dk-core-regional-subdivision-codes#DK-85
* address.use = #home
* address.line[0] = "Tårnhøjvej 47"
* address.line[+] = "Landet"
* address.city = "Aalborg Øst"
* address.postalCode = "9220"
* address.country = "Danmark"