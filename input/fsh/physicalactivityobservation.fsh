Profile: PhysicalActivityObservation
Parent: Observation
Id: PhysicalActivityObservation
Title: "PhysicalActivityObservation"
Description: "FUT like eHealth Observation for daily physical activity"
* code from ActivityCodes (extensible)
* subject 1..
* subject only Reference(TelemedicinePatient)
* extension contains http://hl7.org/fhir/StructureDefinition/workflow-episodeOfCare named workflow-episodeOfCare 1..1
* effective[x] 1..
* effective[x] only Period
* performer 1..1
* performer only Reference(TelemedicinePatient) 
* value[x] only Quantity
  * ^short = "Minutes of activity"
  * ^definition =  "Time (in minutes) doing the activity during the given period reported"
  * unit = "Minutes"
* component ..0

Alias: $SCT = http://snomed.info/sct

Instance: PhysicalActivityObservationExample
InstanceOf: PhysicalActivityObservation
Usage: #example
Title: "PhysicalActivityObservationExample"
Description: "Example of a physical activity observation"
* extension[workflow-episodeOfCare].valueReference = Reference(EpisodeOfCareExample)
* status = #final
* code = $SCT#129006008 "Walking"
* subject = Reference(PatientExample)
* effectivePeriod
  * start = "2022-09-05T00:00:00+02:00"
  * end = "2022-09-06T00:00:00+02:00"
* performer = Reference(PatientExample)
