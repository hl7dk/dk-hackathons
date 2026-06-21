Profile: TelemedicineEpisodeOfCare
Parent: EpisodeOfCare
Id: TelemedicineEpisodeOfCare
Title: "TelemedicineEpisodeOfCare"
Description: "FUT like eHealth EpisodeOfCare"
* patient only Reference(TelemedicinePatient)
* period 1..

Instance: EpisodeOfCareExample
InstanceOf: TelemedicineEpisodeOfCare
Usage: #example
Title: "EpisodeOfCareExample"
Description: "Example of a telemedicin episode of care"
* status = #active
* patient = Reference(PatientExample)
* period
  * start = "2022-09-01T00:00:00+02:00"
