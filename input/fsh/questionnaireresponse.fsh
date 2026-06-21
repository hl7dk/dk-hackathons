Profile: TelemedicineQuestionnaireResponse
Parent: QuestionnaireResponse
Id: TelemedicineQuestionnaireResponse
Title: "TelemedicineQuestionnaireResponse"
Description: "FUT like eHealth QuestionnaireResponse"
* extension contains http://hl7.org/fhir/StructureDefinition/workflow-episodeOfCare named workflow-episodeOfCare 1..1
* questionnaire 1..
* subject 1..
* authored 1..
* source 1..
* source only Reference(TelemedicinePatient or Practitioner or RelatedPerson)

Instance: TelemedicineQuestionnaireResponseExample
InstanceOf: TelemedicineQuestionnaireResponse
Usage: #example
Title: "TelemedicineQuestionnaireResponseExample"
Description: "Example of a mental health questionnaire response"
* extension[workflow-episodeOfCare].valueReference = Reference(EpisodeOfCareExample)
* questionnaire = "http://hl7.org/fhir/Questionnaire/MentalHealthQuestionnaire"
* status = #completed
* subject = Reference(Patient/PatientExample)
* authored = "2022-09-06T08:00:00+02:00"
* source = Reference(Patient/PatientExample)
* item[0].linkId = "1"
* item[=].item[0].linkId = "1.1"
* item[=].item[=].text = "Venskaber"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#60e95414-b97d-4197-af85-d5efc5628e86 "Jeg føler mig tæt på mine venner"
* item[=].item[+].linkId = "1.2"
* item[=].item[=].text = "Lyst til at være sammen med andre"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#48405c96-5f94-4ccf-b9ef-44579da052a8 "Nogle få gange ugentligt har jeg lyst til at være sammen med andre"
* item[=].item[+].linkId = "1.3"
* item[=].item[=].text = "Kærlighed"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#1a705260-cf44-4dd8-83fb-994baf656a6a "Jeg føler mig ikke elsket"
* item[+].linkId = "2"
* item[=].item[0].linkId = "2.1"
* item[=].item[=].text = "Arbejde/skole forventning"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#6eb62a15-8b69-4940-9276-704a0a1c0a60 "Jeg gør det, der forventes"
* item[=].item[+].linkId = "2.2"
* item[=].item[=].text = "Pres"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#14293f45-25fc-48a1-b8be-918d44009e91 "Jeg klarer ikke mine daglige opgaver"
* item[+].linkId = "3"
* item[=].item[0].linkId = "3.1"
* item[=].item[=].text = "Oplagthed"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#a5341a86-677d-4d53-84a1-498dc1a4ed42 "Jeg føler mig klar og frisk de fleste dage"
* item[=].item[+].linkId = "3.2"
* item[=].item[=].text = "Humør"
* item[=].item[=].answer.valueCoding = http://hl7.dk/fhir/Hackathon-Sep-2022/CodeSystem/MentalHealthCodes#b9453f69-31a2-4a67-a453-569d7cd9691a "Jeg er glad"