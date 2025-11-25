/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class StudentScrenningModel {
  int? schoolId;
  bool? anganwadi;
  bool? miniAnganwadi;
  bool? firstClass;
  bool? secondClass;
  bool? thirdClass;
  bool? fourthClass;
  bool? fifthClass;
  bool? sixthClass;
  bool? seventhClass;
  bool? eighthClass;
  bool? ninthClass;
  bool? tenthClass;
  bool? eleventhClass;
  bool? twelthClass;
  String? childName;
  String? age;
  String? gender;
  String? aadhaarNo;
  String? fathersName;
  String? fathersContactNo;
  int? weightInKg;
  int? heightInCm;
  bool? weightHeightNormal;
  bool? weightHeightSAM;
  bool? weightHeightMAM;
  bool? weightHeightSUW;
  bool? weightHeightMUW;
  bool? weightHeightStunted;
  bool? bloodPressure;
  bool? bpNormal;
  bool? bpPrehypertension;
  bool? bpStage1HTN;
  bool? bpStage2HTN;
  int? acuityOfVision;
  int? acuityOfLeftEye;
  int? acuityOfRightEye;
  bool? defectsAtBirth;
  bool? neuralTubeDefects;
  bool? neuralTreated;
  bool? neuralRefer;
  bool? neuralReferSkNagpur;
  bool? neuralReferRH;
  bool? neuralReferSDH;
  bool? neuralReferDH;
  bool? neuralReferGMC;
  bool? neuralReferIGMC;
  bool? neuralReferMJMJYAndMOUY;
  bool? neuralReferDEIC;
  String? neuralTubeDefectsNote;
  bool? downsSyndrome;
  bool? downsTreated;
  bool? downsRefer;
  bool? downsReferSKNagpur;
  bool? downsReferRH;
  bool? downsReferDH;
  bool? downsReferSDH;
  bool? downsReferGMC;
  bool? downsReferIGMC;
  bool? downsReferMJMJYAndMOUY;
  bool? downsReferDEIC;
  String? downsSyndromeNote;
  bool? cleftLipAndPalate;
  bool? cleftTreated;
  bool? cleftRefer;
  bool? cleftReferSKNagpur;
  bool? cleftReferRH;
  bool? cleftReferSDH;
  bool? cleftReferDH;
  bool? cleftReferGMC;
  bool? cleftReferIGMC;
  bool? cleftReferMJMJYAndMOUY;
  bool? cleftReferDEIC;
  String? cleftLipAndPalateNote;
  bool? talipesClubFoot;
  bool? talipesTreated;
  bool? talipseRefer;
  bool? talipseReferSKNagpur;
  bool? talipseReferRH;
  bool? talipseReferSDH;
  bool? talipseReferDH;
  bool? talipseReferGMC;
  bool? talipseReferIGMC;
  bool? talipseReferMJMJYAndMOUY;
  bool? talipseReferDEIC;
  String? talipesClubFootNote;
  bool? dvelopmentalDysplasiaOfHip;
  bool? hipTreated;
  bool? hipRefer;
  bool? hipReferSKNagpur;
  bool? hipReferRH;
  bool? hipReferSDH;
  bool? hipReferDH;
  bool? hipReferGMC;
  bool? hipReferIGMC;
  bool? hipReferMJMJYAndMOUY;
  bool? hipReferDEIC;
  String? dvelopmentalDysplasiaOfHipNote;
  bool? congenitalCatract;
  bool? congenitalTarget;
  bool? congenitalRefer;
  bool? congenitalReferSKNagpur;
  bool? coReferRH;
  bool? coReferSDH;
  bool? coReferDH;
  bool? coReferGMC;
  bool? coReferIGMC;
  bool? coReferMJMJYAndMOUY;
  bool? coReferDEIC;
  String? congenitalCatractNote;
  bool? congenitalDeafness;
  bool? deafnessTarget;
  bool? deafnessRefer;
  bool? deafnessReferSKNagpur;
  bool? cdReferRH;
  bool? cdReferSDH;
  bool? cdReferDH;
  bool? cdReferGMC;
  bool? cdReferIGMC;
  bool? cdReferMJMJYAndMOUY;
  bool? cdReferDEIC;
  String? congenitalDeafnessNote;
  bool? congentialHeartDisease;
  bool? heartDiseaseTarget;
  bool? heartDiseaseRefer;
  bool? heartDiseaseReferSKNagpur;
  bool? hdReferRH;
  bool? hdReferSDH;
  bool? hdReferDH;
  bool? hdReferGMC;
  bool? hdReferIGMC;
  bool? hdReferMJMJYAndMOUY;
  bool? hdReferDEIC;
  String? congentialHeartDiseaseNote;
  bool? retinopathyOfPrematurity;
  bool? retinopathyTreated;
  bool? retinopathyRefer;
  bool? retinopathyReferSKNagpur;
  bool? rpReferRH;
  bool? rpReferSDH;
  bool? rpReferDH;
  bool? rpReferGMC;
  bool? rpReferIGMC;
  bool? rpReferMJMJYAndMOUY;
  bool? rpReferDEIC;
  String? retinopathyOfPrematurityNote;
  bool? other;
  bool? otherTreated;
  bool? otherRefer;
  bool? otherReferSKNagpur;
  bool? otherReferRH;
  bool? otherReferSDH;
  bool? otherReferDH;
  bool? otherReferGMC;
  bool? otherReferIGMC;
  bool? otherReferMJMJYAndMOUY;
  bool? otherReferDEIC;
  String? otherNote;
  bool? deficiencesAtBirth;
  bool? anemia;
  bool? anemiaTreated;
  bool? anemiaRefer;
  bool? anemiaReferSKNagpur;
  bool? anemiaReferRH;
  bool? anemiaReferSDH;
  bool? anemiaReferDH;
  bool? anemiaReferGMC;
  bool? anemiaReferIGMC;
  bool? anemiaReferMJMJYAndMOUY;
  bool? anemiaReferDEIC;
  String? anemiaNote;
  bool? vitaminADef;
  bool? vitaminATreated;
  bool? vitaminARefer;
  bool? vitaminAReferSKNagpur;
  bool? vAReferRH;
  bool? vAReferSDH;
  bool? vAReferDH;
  bool? vAReferGMC;
  bool? vAReferIGMC;
  bool? vAReferMJMJYAndMOUY;
  bool? vAReferDEIC;
  String? vitaminADefNote;
  bool? vitaminDDef;
  bool? vitaminDTreated;
  bool? vitaminDRefer;
  bool? vitaminDReferSKNagpur;
  bool? vDReferRH;
  bool? vDReferSDH;
  bool? vDReferDH;
  bool? vDReferGMC;
  bool? vDReferIGMC;
  bool? vDReferMJMJYAndMOUY;
  bool? vDReferDEIC;
  String? vitaminDDefNote;
  bool? saMStunting;
  bool? samTreated;
  bool? samRefer;
  bool? samReferSKNagpur;
  bool? samReferRH;
  bool? samReferSDH;
  bool? samReferDH;
  bool? samReferGMC;
  bool? samReferIGMC;
  bool? samReferMJMJYAndMOUY;
  bool? samReferDEIC;
  String? saMStuntingNote;
  bool? goiter;
  bool? goiterTreated;
  bool? goiterRefer;
  bool? goiterReferSKNagpur;
  bool? gReferRH;
  bool? gReferSDH;
  bool? gReferDH;
  bool? gReferGMC;
  bool? gReferIGMC;
  bool? gReferMJMJYAndMOUY;
  bool? gReferDEIC;
  String? goiterNote;
  bool? vitaminBcomplexDef;
  bool? vitaminBTreated;
  bool? vitaminBRefer;
  bool? vitaminBReferSKNagpur;
  bool? vBReferRH;
  bool? vBReferSDH;
  bool? vBReferDH;
  bool? vBReferGMC;
  bool? vBReferIGMC;
  bool? vBReferMJMJYAndMOUY;
  bool? vBReferDEIC;
  String? vitaminBcomplexDefNote;
  bool? othersSpecify;
  bool? othersTreated;
  bool? othersRefer;
  bool? othersReferSKNagpur;
  bool? otReferRH;
  bool? otReferSDH;
  bool? otReferDH;
  bool? otReferGMC;
  bool? otReferIGMC;
  bool? otReferMJMJYAndMOUY;
  bool? otReferDEIC;
  String? othersSpecifyNote;
  bool? diseases;
  bool? skinConditionsNotLeprosy;
  bool? skinTrated;
  bool? skinRefer;
  bool? skinReferSKNagpur;
  bool? skReferRH;
  bool? skReferSDH;
  bool? skReferDH;
  bool? skReferGMC;
  bool? skReferIGMC;
  bool? skReferMJMJYAndMOUY;
  bool? skReferDEIC;
  String? skinConditionsNotLeprosyNote;
  bool? otitisMedia;
  bool? otitisMediaTreated;
  bool? otitisMediaRefer;
  bool? otitisMediaReferSKNagpur;
  bool? otmReferRH;
  bool? otmReferSDH;
  bool? otmReferDH;
  bool? otmReferGMC;
  bool? otmReferIGMC;
  bool? otmReferMJMJYAndMOUY;
  bool? otmReferDEIC;
  String? otitisMediaNote;
  bool? rehumaticHeartDisease;
  bool? rehumaticTrated;
  bool? rehumaticRefer;
  bool? rehumaticReferSKNagpur;
  bool? reReferRH;
  bool? reReferSDH;
  bool? reReferDH;
  bool? reReferGMC;
  bool? reReferIGMC;
  bool? reReferMJMJYAndMOUY;
  bool? reReferDEIC;
  String? rehumaticHeartDiseaseNote;
  bool? reactiveAirwayDisease;
  bool? reactiveTreated;
  bool? reactiveRefer;
  bool? reactiveReferSKNagpur;
  bool? raReferRH;
  bool? raReferSDH;
  bool? raReferDH;
  bool? raReferGMC;
  bool? raReferIGMC;
  bool? raReferMJMJYAndMOUY;
  bool? raReferDEIC;
  String? reactiveAirwayDiseaseNote;
  bool? dentalConditions;
  bool? dentalTrated;
  bool? dentalRefer;
  bool? dentalReferSKNagpur;
  bool? deReferRH;
  bool? deReferSDH;
  bool? deReferDH;
  bool? deReferGMC;
  bool? deReferIGMC;
  bool? deReferMJMJYAndMOUY;
  bool? deReferDEIC;
  String? dentalConditionsNote;
  bool? childhoodLeprosyDisease;
  bool? childhoodTreated;
  bool? childhoodRefer;
  bool? childhoodReferSKNagpur;
  bool? chReferRH;
  bool? chReferSDH;
  bool? chReferDH;
  bool? chReferGMC;
  bool? chReferIGMC;
  bool? chReferMJMJYAndMOUY;
  bool? chReferDEIC;
  String? childhoodLeprosyDiseaseNote;
  bool? childhoodTuberculosis;
  bool? cTuberculosisTreated;
  bool? cTuberculosisRefer;
  bool? cTuberculosisReferSKNagpur;
  bool? cTuReferRH;
  bool? cTuReferSDH;
  bool? cTuReferDH;
  bool? cTuReferGMC;
  bool? cTuReferIGMC;
  bool? cTuReferMJMJYAndMOUY;
  bool? cTuReferDEIC;
  String? childhoodTuberculosisNote;
  bool? childhoodTuberculosisExtraPulmonary;
  bool? cTuExtraTreated;
  bool? cTuExtraRefer;
  bool? cTuExtraReferSKNagpur;
  bool? cTuExtraReferRH;
  bool? cTuExtraReferSDH;
  bool? cTuExtraReferDH;
  bool? cTuExtraReferGMC;
  bool? cTuExtraReferIGMC;
  bool? cTuExtraReferMJMJYAndMOUY;
  bool? cTuExtraReferDEIC;
  String? childhoodTuberculosisExtraPulmonaryNote;
  bool? otherdisease;
  bool? otherdiseaseTreated;
  bool? otherdiseaseRefer;
  bool? otherdiseaseReferSKNagpur;
  bool? otherdiseaseReferRH;
  bool? otherdiseaseReferSDH;
  bool? otherdiseaseReferDH;
  bool? otherdiseaseReferGMC;
  bool? otherdiseaseReferIGMC;
  bool? otherdiseaseMJMJYAndMOUY;
  bool? otherdiseaseReferDEIC;
  String? otherdiseaseNote;
  bool? developmentalDelayIncludingDisability;
  bool? visionImpairment;
  bool? visionTreated;
  bool? visionRefer;
  bool? visionReferSKNagpur;
  bool? visionReferRH;
  bool? visionReferSDH;
  bool? visionReferDH;
  bool? visionReferGMC;
  bool? visionReferIGMC;
  bool? visionReferMJMJYAndMOUY;
  bool? visionReferDEIC;
  String? visionImpairmentNote;
  bool? hearingImpairment;
  bool? hearingTreated;
  bool? hearingRefer;
  bool? hearingReferSKNagpur;
  bool? hearingReferRH;
  bool? hearingReferSDH;
  bool? hearingReferDH;
  bool? hearingReferGMC;
  bool? hearingReferIGMC;
  bool? hearingReferMJMJYAndMOUY;
  bool? hearingReferDEIC;
  String? hearingImpairmentNote;
  bool? neuromotorImpairment;
  bool? neuromotorTreated;
  bool? neuromotorRefer;
  bool? neuromotorReferSKNagpur;
  bool? neuroReferRH;
  bool? neuroReferSDH;
  bool? neuroReferDH;
  bool? neuroReferGMC;
  bool? neuroReferIGMC;
  bool? neuroReferMJMJYAndMOUY;
  bool? neuroReferDEIC;
  String? neuromotorImpairmentNote;
  bool? motorDelay;
  bool? motorDealyTrated;
  bool? motorDelayRefer;
  bool? motorDelayReferSKNagpur;
  bool? motorReferRH;
  bool? motorReferSDH;
  bool? motorReferDH;
  bool? motorReferGMC;
  bool? motorReferIGMC;
  bool? motorReferMJMJYAndMOUY;
  bool? motorReferDEIC;
  String? motorDelayNote;
  bool? cognitiveDelay;
  bool? cognitiveTrated;
  bool? cognitiveRefer;
  bool? cognitiveReferSKNagpur;
  bool? cognitiveReferRH;
  bool? cognitiveReferSDH;
  bool? cognitiveReferDH;
  bool? cognitiveReferGMC;
  bool? cognitiveReferIGMC;
  bool? cognitiveReferMJMJYAndMOUY;
  bool? cognitiveReferDEIC;
  String? cognitiveDelayNote;
  bool? speechAndLanguageDelay;
  bool? speechTreated;
  bool? speechRefer;
  bool? speechReferSKNagpur;
  bool? speechReferRH;
  bool? speechReferSDH;
  bool? speechReferDH;
  bool? speechReferGMC;
  bool? speechReferIGMC;
  bool? speechReferMJMJYAndMOUY;
  bool? speechReferDEIC;
  String? speechAndLanguageDelayNote;
  bool? behaviouralDisorder;
  bool? behaviouralTreated;
  bool? behavoiuralRefer;
  bool? behavoiuralReferSKNagpur;
  bool? behavoiuralReferRH;
  bool? behavoiuralReferSDH;
  bool? behavoiuralReferDH;
  bool? behavoiuralReferGMC;
  bool? behavoiuralReferIGMC;
  bool? behavoiuralReferMJMJYAndMOUY;
  bool? behavoiuralReferDEIC;
  String? behaviouralDisorderNote;
  bool? learningDisorder;
  bool? learningTreated;
  bool? learningRefer;
  bool? learningReferSKNagpur;
  bool? learningReferRH;
  bool? learningReferSDH;
  bool? learningReferDH;
  bool? learningReferGMC;
  bool? learningReferIGMC;
  bool? learningReferMJMJYAndMOUY;
  bool? learningReferDEIC;
  String? learningDisorderNote;
  bool? attentionDeficitHyperactivityDisorder;
  bool? attentionTreated;
  bool? attentionRefer;
  bool? attentionReferSKNagpur;
  bool? attentionReferRH;
  bool? attentionReferSDH;
  bool? attentionReferDH;
  bool? attentionReferGMC;
  bool? attentionReferIGMC;
  bool? attentionReferMJMJYAndMOUY;
  bool? attentionReferDEIC;
  String? attentionDeficitHyperactivityDisorderNote;
  bool? otherddid;
  bool? otherddidTreated;
  bool? otherddidRefer;
  bool? otherddidReferSKNagpur;
  bool? otherddidReferRH;
  bool? otherddidReferSDH;
  bool? otherddidReferDH;
  bool? otherddidReferGMC;
  bool? otherddidReferIGMC;
  bool? otherddidMJMJYAndMOUY;
  bool? otherddidReferDEIC;
  String? otherddidNote;
  bool? adolescentSpecificQuestionnare;
  bool? growingUpConcerns;
  bool? growingTreated;
  bool? growingRefer;
  bool? growingReferSKNagpur;
  bool? growingReferRH;
  bool? growingReferSDH;
  bool? growingReferDH;
  bool? growingReferGMC;
  bool? growingReferIGMC;
  bool? growingReferMJMJYAndMOUY;
  bool? growingReferDEIC;
  String? growingUpConcernsNote;
  bool? substanceAbuse;
  bool? substanceTreated;
  bool? substanceRefer;
  bool? substanceReferSKNagpur;
  bool? substanceReferRH;
  bool? substanceReferSDH;
  bool? substanceReferDH;
  bool? substanceReferGMC;
  bool? substanceReferIGMC;
  bool? substanceReferMJMJYAndMOUY;
  bool? substanceReferDEIC;
  String? substanceAbuseNote;
  bool? feelDepressed;
  bool? feelTreated;
  bool? feelRefer;
  bool? feelReferSKNagpur;
  bool? feelReferRH;
  bool? feelReferSDH;
  bool? feelReferDH;
  bool? feelReferGMC;
  bool? feelReferIGMC;
  bool? feelReferMJMJYAndMOUY;
  bool? feelReferDEIC;
  String? feelDepressedNote;
  bool? delayInMenstrualCycles;
  bool? delayTreated;
  bool? delayRefer;
  bool? delayReferSKNagpur;
  bool? delayReferRH;
  bool? delayReferSDH;
  bool? delayReferDH;
  bool? delayReferGMC;
  bool? delayReferIGMC;
  bool? delayReferMJMJYAndMOUY;
  bool? delayReferDEIC;
  String? delayInMenstrualCyclesNote;
  bool? irregularPeriods;
  bool? irregularTreated;
  bool? irregularRefer;
  bool? irregularReferSKNagpur;
  bool? irregularReferRH;
  bool? irregularReferSDH;
  bool? irregularReferDH;
  bool? irregularReferGMC;
  bool? irregularReferIGMC;
  bool? irregularReferMJMJYAndMOUY;
  bool? irregularReferDEIC;
  String? irregularPeriodsNote;
  bool? painOrBurningSensationWhileUrinating;
  bool? painOrBurningTreated;
  bool? painOrBurningRefer;
  bool? painOrBurningReferSKNagpur;
  bool? painOrBurningReferRH;
  bool? painOrBurningReferSDH;
  bool? painOrBurningReferDH;
  bool? painOrBurningReferGMC;
  bool? painOrBurningReferIGMC;
  bool? painOrBurningReferMJMJYAndMOUY;
  bool? painOrBurningReferDEIC;
  String? painOrBurningSensationWhileUrinatingNote;
  bool? discharge;
  bool? dischargeTreated;
  bool? dischargeRefer;
  bool? dischargeReferSKNagpur;
  bool? dischargeReferRH;
  bool? dischargeReferSDH;
  bool? dischargeReferDH;
  bool? dischargeReferGMC;
  bool? dischargeReferIGMC;
  bool? dischargeReferMJMJYAndMOUY;
  bool? dischargeReferDEIC;
  String? dischargeNote;
  bool? painDuringMenstruation;
  bool? painDuringTreated;
  bool? painDuringRefer;
  bool? painDuringReferSKNagpur;
  bool? painDuringReferRH;
  bool? painDuringReferSDH;
  bool? painDuringReferDH;
  bool? painDuringReferGMC;
  bool? painDuringReferIGMC;
  bool? painDuringReferMJMJYAndMOUY;
  bool? painDuringReferDEIC;
  String? painDuringMenstruationNote;
  bool? otherasq;
  bool? otherasqTreated;
  bool? otherasqRefer;
  bool? otherasqReferSKNagpur;
  bool? otherasqReferRH;
  bool? otherasqReferSDH;
  bool? otherasqReferDH;
  bool? otherasqReferGMC;
  bool? otherasqReferIGMC;
  bool? otherasqMJMJYAndMOUY;
  bool? otherasqReferDEIC;
  String? otherasqNote;
  bool? disibility;
  bool? disibilityTreated;
  bool? disibilityRefer;
  bool? disibilityReferSKNagpur;
  bool? disibilityRH;
  bool? disibilitySDH;
  bool? disibilityDH;
  bool? disibilityGMC;
  bool? disibilityIGMC;
  bool? disibilityMJMJYAndMOUY;
  bool? disibilityDEIC;
  String? disibilityNote;
  String? doctorName;
  int? userId;
  String? latitude;
  String? longitude;

  StudentScrenningModel({
    this.schoolId,
    this.anganwadi,
    this.miniAnganwadi,
    this.firstClass,
    this.secondClass,
    this.thirdClass,
    this.fourthClass,
    this.fifthClass,
    this.sixthClass,
    this.seventhClass,
    this.eighthClass,
    this.ninthClass,
    this.tenthClass,
    this.eleventhClass,
    this.twelthClass,
    this.childName,
    this.age,
    this.gender,
    this.aadhaarNo,
    this.fathersName,
    this.fathersContactNo,
    this.weightInKg,
    this.heightInCm,
    this.weightHeightNormal,
    this.weightHeightSAM,
    this.weightHeightMAM,
    this.weightHeightSUW,
    this.weightHeightMUW,
    this.weightHeightStunted,
    this.bloodPressure,
    this.bpNormal,
    this.bpPrehypertension,
    this.bpStage1HTN,
    this.bpStage2HTN,
    this.acuityOfVision,
    this.acuityOfLeftEye,
    this.acuityOfRightEye,
    this.defectsAtBirth,
    this.neuralTubeDefects,
    this.neuralTreated,
    this.neuralRefer,
    this.neuralReferSkNagpur,
    this.neuralReferRH,
    this.neuralReferSDH,
    this.neuralReferDH,
    this.neuralReferGMC,
    this.neuralReferIGMC,
    this.neuralReferMJMJYAndMOUY,
    this.neuralReferDEIC,
    this.neuralTubeDefectsNote,
    this.downsSyndrome,
    this.downsTreated,
    this.downsRefer,
    this.downsReferSKNagpur,
    this.downsReferRH,
    this.downsReferDH,
    this.downsReferSDH,
    this.downsReferGMC,
    this.downsReferIGMC,
    this.downsReferMJMJYAndMOUY,
    this.downsReferDEIC,
    this.downsSyndromeNote,
    this.cleftLipAndPalate,
    this.cleftTreated,
    this.cleftRefer,
    this.cleftReferSKNagpur,
    this.cleftReferRH,
    this.cleftReferSDH,
    this.cleftReferDH,
    this.cleftReferGMC,
    this.cleftReferIGMC,
    this.cleftReferMJMJYAndMOUY,
    this.cleftReferDEIC,
    this.cleftLipAndPalateNote,
    this.talipesClubFoot,
    this.talipesTreated,
    this.talipseRefer,
    this.talipseReferSKNagpur,
    this.talipseReferRH,
    this.talipseReferSDH,
    this.talipseReferDH,
    this.talipseReferGMC,
    this.talipseReferIGMC,
    this.talipseReferMJMJYAndMOUY,
    this.talipseReferDEIC,
    this.talipesClubFootNote,
    this.dvelopmentalDysplasiaOfHip,
    this.hipTreated,
    this.hipRefer,
    this.hipReferSKNagpur,
    this.hipReferRH,
    this.hipReferSDH,
    this.hipReferDH,
    this.hipReferGMC,
    this.hipReferIGMC,
    this.hipReferMJMJYAndMOUY,
    this.hipReferDEIC,
    this.dvelopmentalDysplasiaOfHipNote,
    this.congenitalCatract,
    this.congenitalTarget,
    this.congenitalRefer,
    this.congenitalReferSKNagpur,
    this.coReferRH,
    this.coReferSDH,
    this.coReferDH,
    this.coReferGMC,
    this.coReferIGMC,
    this.coReferMJMJYAndMOUY,
    this.coReferDEIC,
    this.congenitalCatractNote,
    this.congenitalDeafness,
    this.deafnessTarget,
    this.deafnessRefer,
    this.deafnessReferSKNagpur,
    this.cdReferRH,
    this.cdReferSDH,
    this.cdReferDH,
    this.cdReferGMC,
    this.cdReferIGMC,
    this.cdReferMJMJYAndMOUY,
    this.cdReferDEIC,
    this.congenitalDeafnessNote,
    this.congentialHeartDisease,
    this.heartDiseaseTarget,
    this.heartDiseaseRefer,
    this.heartDiseaseReferSKNagpur,
    this.hdReferRH,
    this.hdReferSDH,
    this.hdReferDH,
    this.hdReferGMC,
    this.hdReferIGMC,
    this.hdReferMJMJYAndMOUY,
    this.hdReferDEIC,
    this.congentialHeartDiseaseNote,
    this.retinopathyOfPrematurity,
    this.retinopathyTreated,
    this.retinopathyRefer,
    this.retinopathyReferSKNagpur,
    this.rpReferRH,
    this.rpReferSDH,
    this.rpReferDH,
    this.rpReferGMC,
    this.rpReferIGMC,
    this.rpReferMJMJYAndMOUY,
    this.rpReferDEIC,
    this.retinopathyOfPrematurityNote,
    this.other,
    this.otherTreated,
    this.otherRefer,
    this.otherReferSKNagpur,
    this.otherReferRH,
    this.otherReferSDH,
    this.otherReferDH,
    this.otherReferGMC,
    this.otherReferIGMC,
    this.otherReferMJMJYAndMOUY,
    this.otherReferDEIC,
    this.otherNote,
    this.deficiencesAtBirth,
    this.anemia,
    this.anemiaTreated,
    this.anemiaRefer,
    this.anemiaReferSKNagpur,
    this.anemiaReferRH,
    this.anemiaReferSDH,
    this.anemiaReferDH,
    this.anemiaReferGMC,
    this.anemiaReferIGMC,
    this.anemiaReferMJMJYAndMOUY,
    this.anemiaReferDEIC,
    this.anemiaNote,
    this.vitaminADef,
    this.vitaminATreated,
    this.vitaminARefer,
    this.vitaminAReferSKNagpur,
    this.vAReferRH,
    this.vAReferSDH,
    this.vAReferDH,
    this.vAReferGMC,
    this.vAReferIGMC,
    this.vAReferMJMJYAndMOUY,
    this.vAReferDEIC,
    this.vitaminADefNote,
    this.vitaminDDef,
    this.vitaminDTreated,
    this.vitaminDRefer,
    this.vitaminDReferSKNagpur,
    this.vDReferRH,
    this.vDReferSDH,
    this.vDReferDH,
    this.vDReferGMC,
    this.vDReferIGMC,
    this.vDReferMJMJYAndMOUY,
    this.vDReferDEIC,
    this.vitaminDDefNote,
    this.saMStunting,
    this.samTreated,
    this.samRefer,
    this.samReferSKNagpur,
    this.samReferRH,
    this.samReferSDH,
    this.samReferDH,
    this.samReferGMC,
    this.samReferIGMC,
    this.samReferMJMJYAndMOUY,
    this.samReferDEIC,
    this.saMStuntingNote,
    this.goiter,
    this.goiterTreated,
    this.goiterRefer,
    this.goiterReferSKNagpur,
    this.gReferRH,
    this.gReferSDH,
    this.gReferDH,
    this.gReferGMC,
    this.gReferIGMC,
    this.gReferMJMJYAndMOUY,
    this.gReferDEIC,
    this.goiterNote,
    this.vitaminBcomplexDef,
    this.vitaminBTreated,
    this.vitaminBRefer,
    this.vitaminBReferSKNagpur,
    this.vBReferRH,
    this.vBReferSDH,
    this.vBReferDH,
    this.vBReferGMC,
    this.vBReferIGMC,
    this.vBReferMJMJYAndMOUY,
    this.vBReferDEIC,
    this.vitaminBcomplexDefNote,
    this.othersSpecify,
    this.othersTreated,
    this.othersRefer,
    this.othersReferSKNagpur,
    this.otReferRH,
    this.otReferSDH,
    this.otReferDH,
    this.otReferGMC,
    this.otReferIGMC,
    this.otReferMJMJYAndMOUY,
    this.otReferDEIC,
    this.othersSpecifyNote,
    this.diseases,
    this.skinConditionsNotLeprosy,
    this.skinTrated,
    this.skinRefer,
    this.skinReferSKNagpur,
    this.skReferRH,
    this.skReferSDH,
    this.skReferDH,
    this.skReferGMC,
    this.skReferIGMC,
    this.skReferMJMJYAndMOUY,
    this.skReferDEIC,
    this.skinConditionsNotLeprosyNote,
    this.otitisMedia,
    this.otitisMediaTreated,
    this.otitisMediaRefer,
    this.otitisMediaReferSKNagpur,
    this.otmReferRH,
    this.otmReferSDH,
    this.otmReferDH,
    this.otmReferGMC,
    this.otmReferIGMC,
    this.otmReferMJMJYAndMOUY,
    this.otmReferDEIC,
    this.otitisMediaNote,
    this.rehumaticHeartDisease,
    this.rehumaticTrated,
    this.rehumaticRefer,
    this.rehumaticReferSKNagpur,
    this.reReferRH,
    this.reReferSDH,
    this.reReferDH,
    this.reReferGMC,
    this.reReferIGMC,
    this.reReferMJMJYAndMOUY,
    this.reReferDEIC,
    this.rehumaticHeartDiseaseNote,
    this.reactiveAirwayDisease,
    this.reactiveTreated,
    this.reactiveRefer,
    this.reactiveReferSKNagpur,
    this.raReferRH,
    this.raReferSDH,
    this.raReferDH,
    this.raReferGMC,
    this.raReferIGMC,
    this.raReferMJMJYAndMOUY,
    this.raReferDEIC,
    this.reactiveAirwayDiseaseNote,
    this.dentalConditions,
    this.dentalTrated,
    this.dentalRefer,
    this.dentalReferSKNagpur,
    this.deReferRH,
    this.deReferSDH,
    this.deReferDH,
    this.deReferGMC,
    this.deReferIGMC,
    this.deReferMJMJYAndMOUY,
    this.deReferDEIC,
    this.dentalConditionsNote,
    this.childhoodLeprosyDisease,
    this.childhoodTreated,
    this.childhoodRefer,
    this.childhoodReferSKNagpur,
    this.chReferRH,
    this.chReferSDH,
    this.chReferDH,
    this.chReferGMC,
    this.chReferIGMC,
    this.chReferMJMJYAndMOUY,
    this.chReferDEIC,
    this.childhoodLeprosyDiseaseNote,
    this.childhoodTuberculosis,
    this.cTuberculosisTreated,
    this.cTuberculosisRefer,
    this.cTuberculosisReferSKNagpur,
    this.cTuReferRH,
    this.cTuReferSDH,
    this.cTuReferDH,
    this.cTuReferGMC,
    this.cTuReferIGMC,
    this.cTuReferMJMJYAndMOUY,
    this.cTuReferDEIC,
    this.childhoodTuberculosisNote,
    this.childhoodTuberculosisExtraPulmonary,
    this.cTuExtraTreated,
    this.cTuExtraRefer,
    this.cTuExtraReferSKNagpur,
    this.cTuExtraReferRH,
    this.cTuExtraReferSDH,
    this.cTuExtraReferDH,
    this.cTuExtraReferGMC,
    this.cTuExtraReferIGMC,
    this.cTuExtraReferMJMJYAndMOUY,
    this.cTuExtraReferDEIC,
    this.childhoodTuberculosisExtraPulmonaryNote,
    this.otherdisease,
    this.otherdiseaseTreated,
    this.otherdiseaseRefer,
    this.otherdiseaseReferSKNagpur,
    this.otherdiseaseReferRH,
    this.otherdiseaseReferSDH,
    this.otherdiseaseReferDH,
    this.otherdiseaseReferGMC,
    this.otherdiseaseReferIGMC,
    this.otherdiseaseMJMJYAndMOUY,
    this.otherdiseaseReferDEIC,
    this.otherdiseaseNote,
    this.developmentalDelayIncludingDisability,
    this.visionImpairment,
    this.visionTreated,
    this.visionRefer,
    this.visionReferSKNagpur,
    this.visionReferRH,
    this.visionReferSDH,
    this.visionReferDH,
    this.visionReferGMC,
    this.visionReferIGMC,
    this.visionReferMJMJYAndMOUY,
    this.visionReferDEIC,
    this.visionImpairmentNote,
    this.hearingImpairment,
    this.hearingTreated,
    this.hearingRefer,
    this.hearingReferSKNagpur,
    this.hearingReferRH,
    this.hearingReferSDH,
    this.hearingReferDH,
    this.hearingReferGMC,
    this.hearingReferIGMC,
    this.hearingReferMJMJYAndMOUY,
    this.hearingReferDEIC,
    this.hearingImpairmentNote,
    this.neuromotorImpairment,
    this.neuromotorTreated,
    this.neuromotorRefer,
    this.neuromotorReferSKNagpur,
    this.neuroReferRH,
    this.neuroReferSDH,
    this.neuroReferDH,
    this.neuroReferGMC,
    this.neuroReferIGMC,
    this.neuroReferMJMJYAndMOUY,
    this.neuroReferDEIC,
    this.neuromotorImpairmentNote,
    this.motorDelay,
    this.motorDealyTrated,
    this.motorDelayRefer,
    this.motorDelayReferSKNagpur,
    this.motorReferRH,
    this.motorReferSDH,
    this.motorReferDH,
    this.motorReferGMC,
    this.motorReferIGMC,
    this.motorReferMJMJYAndMOUY,
    this.motorReferDEIC,
    this.motorDelayNote,
    this.cognitiveDelay,
    this.cognitiveTrated,
    this.cognitiveRefer,
    this.cognitiveReferSKNagpur,
    this.cognitiveReferRH,
    this.cognitiveReferSDH,
    this.cognitiveReferDH,
    this.cognitiveReferGMC,
    this.cognitiveReferIGMC,
    this.cognitiveReferMJMJYAndMOUY,
    this.cognitiveReferDEIC,
    this.cognitiveDelayNote,
    this.speechAndLanguageDelay,
    this.speechTreated,
    this.speechRefer,
    this.speechReferSKNagpur,
    this.speechReferRH,
    this.speechReferSDH,
    this.speechReferDH,
    this.speechReferGMC,
    this.speechReferIGMC,
    this.speechReferMJMJYAndMOUY,
    this.speechReferDEIC,
    this.speechAndLanguageDelayNote,
    this.behaviouralDisorder,
    this.behaviouralTreated,
    this.behavoiuralRefer,
    this.behavoiuralReferSKNagpur,
    this.behavoiuralReferRH,
    this.behavoiuralReferSDH,
    this.behavoiuralReferDH,
    this.behavoiuralReferGMC,
    this.behavoiuralReferIGMC,
    this.behavoiuralReferMJMJYAndMOUY,
    this.behavoiuralReferDEIC,
    this.behaviouralDisorderNote,
    this.learningDisorder,
    this.learningTreated,
    this.learningRefer,
    this.learningReferSKNagpur,
    this.learningReferRH,
    this.learningReferSDH,
    this.learningReferDH,
    this.learningReferGMC,
    this.learningReferIGMC,
    this.learningReferMJMJYAndMOUY,
    this.learningReferDEIC,
    this.learningDisorderNote,
    this.attentionDeficitHyperactivityDisorder,
    this.attentionTreated,
    this.attentionRefer,
    this.attentionReferSKNagpur,
    this.attentionReferRH,
    this.attentionReferSDH,
    this.attentionReferDH,
    this.attentionReferGMC,
    this.attentionReferIGMC,
    this.attentionReferMJMJYAndMOUY,
    this.attentionReferDEIC,
    this.attentionDeficitHyperactivityDisorderNote,
    this.otherddid,
    this.otherddidTreated,
    this.otherddidRefer,
    this.otherddidReferSKNagpur,
    this.otherddidReferRH,
    this.otherddidReferSDH,
    this.otherddidReferDH,
    this.otherddidReferGMC,
    this.otherddidReferIGMC,
    this.otherddidMJMJYAndMOUY,
    this.otherddidReferDEIC,
    this.otherddidNote,
    this.adolescentSpecificQuestionnare,
    this.growingUpConcerns,
    this.growingTreated,
    this.growingRefer,
    this.growingReferSKNagpur,
    this.growingReferRH,
    this.growingReferSDH,
    this.growingReferDH,
    this.growingReferGMC,
    this.growingReferIGMC,
    this.growingReferMJMJYAndMOUY,
    this.growingReferDEIC,
    this.growingUpConcernsNote,
    this.substanceAbuse,
    this.substanceTreated,
    this.substanceRefer,
    this.substanceReferSKNagpur,
    this.substanceReferRH,
    this.substanceReferSDH,
    this.substanceReferDH,
    this.substanceReferGMC,
    this.substanceReferIGMC,
    this.substanceReferMJMJYAndMOUY,
    this.substanceReferDEIC,
    this.substanceAbuseNote,
    this.feelDepressed,
    this.feelTreated,
    this.feelRefer,
    this.feelReferSKNagpur,
    this.feelReferRH,
    this.feelReferSDH,
    this.feelReferDH,
    this.feelReferGMC,
    this.feelReferIGMC,
    this.feelReferMJMJYAndMOUY,
    this.feelReferDEIC,
    this.feelDepressedNote,
    this.delayInMenstrualCycles,
    this.delayTreated,
    this.delayRefer,
    this.delayReferSKNagpur,
    this.delayReferRH,
    this.delayReferSDH,
    this.delayReferDH,
    this.delayReferGMC,
    this.delayReferIGMC,
    this.delayReferMJMJYAndMOUY,
    this.delayReferDEIC,
    this.delayInMenstrualCyclesNote,
    this.irregularPeriods,
    this.irregularTreated,
    this.irregularRefer,
    this.irregularReferSKNagpur,
    this.irregularReferRH,
    this.irregularReferSDH,
    this.irregularReferDH,
    this.irregularReferGMC,
    this.irregularReferIGMC,
    this.irregularReferMJMJYAndMOUY,
    this.irregularReferDEIC,
    this.irregularPeriodsNote,
    this.painOrBurningSensationWhileUrinating,
    this.painOrBurningTreated,
    this.painOrBurningRefer,
    this.painOrBurningReferSKNagpur,
    this.painOrBurningReferRH,
    this.painOrBurningReferSDH,
    this.painOrBurningReferDH,
    this.painOrBurningReferGMC,
    this.painOrBurningReferIGMC,
    this.painOrBurningReferMJMJYAndMOUY,
    this.painOrBurningReferDEIC,
    this.painOrBurningSensationWhileUrinatingNote,
    this.discharge,
    this.dischargeTreated,
    this.dischargeRefer,
    this.dischargeReferSKNagpur,
    this.dischargeReferRH,
    this.dischargeReferSDH,
    this.dischargeReferDH,
    this.dischargeReferGMC,
    this.dischargeReferIGMC,
    this.dischargeReferMJMJYAndMOUY,
    this.dischargeReferDEIC,
    this.dischargeNote,
    this.painDuringMenstruation,
    this.painDuringTreated,
    this.painDuringRefer,
    this.painDuringReferSKNagpur,
    this.painDuringReferRH,
    this.painDuringReferSDH,
    this.painDuringReferDH,
    this.painDuringReferGMC,
    this.painDuringReferIGMC,
    this.painDuringReferMJMJYAndMOUY,
    this.painDuringReferDEIC,
    this.painDuringMenstruationNote,
    this.otherasq,
    this.otherasqTreated,
    this.otherasqRefer,
    this.otherasqReferSKNagpur,
    this.otherasqReferRH,
    this.otherasqReferSDH,
    this.otherasqReferDH,
    this.otherasqReferGMC,
    this.otherasqReferIGMC,
    this.otherasqMJMJYAndMOUY,
    this.otherasqReferDEIC,
    this.otherasqNote,
    this.disibility,
    this.disibilityTreated,
    this.disibilityRefer,
    this.disibilityReferSKNagpur,
    this.disibilityRH,
    this.disibilitySDH,
    this.disibilityDH,
    this.disibilityGMC,
    this.disibilityIGMC,
    this.disibilityMJMJYAndMOUY,
    this.disibilityDEIC,
    this.disibilityNote,
    this.doctorName,
    this.userId,
    this.latitude,
    this.longitude,
  });

  StudentScrenningModel.fromJson(Map<String, dynamic> json) {
    schoolId = json['schoolId'];
    anganwadi = json['anganwadi'];
    miniAnganwadi = json['miniAnganwadi'];
    firstClass = json['firstClass'];
    secondClass = json['secondClass'];
    thirdClass = json['thirdClass'];
    fourthClass = json['fourthClass'];
    fifthClass = json['fifthClass'];
    sixthClass = json['sixthClass'];
    seventhClass = json['seventhClass'];
    eighthClass = json['eighthClass'];
    ninthClass = json['ninthClass'];
    tenthClass = json['tenthClass'];
    eleventhClass = json['eleventhClass'];
    twelthClass = json['twelthClass'];
    childName = json['childName'];
    age = json['age'];
    gender = json['gender'];
    aadhaarNo = json['aadhaarNo'];
    fathersName = json['fathersName'];
    fathersContactNo = json['fathersContactNo'];
    weightInKg = json['weightInKg'];
    heightInCm = json['heightInCm'];
    weightHeightNormal = json['weightHeightNormal'];
    weightHeightSAM = json['weightHeightSAM'];
    weightHeightMAM = json['weightHeightMAM'];
    weightHeightSUW = json['weightHeightSUW'];
    weightHeightMUW = json['weightHeightMUW'];
    weightHeightStunted = json['weightHeightStunted'];
    bloodPressure = json['bloodPressure'];
    bpNormal = json['bpNormal'];
    bpPrehypertension = json['bpPrehypertension'];
    bpStage1HTN = json['bpStage1HTN'];
    bpStage2HTN = json['bpStage2HTN'];
    acuityOfVision = json['acuityOfVision'];
    acuityOfLeftEye = json['acuityOfLeftEye'];
    acuityOfRightEye = json['acuityOfRightEye'];
    defectsAtBirth = json['defectsAtBirth'];
    neuralTubeDefects = json['neuralTubeDefects'];
    neuralTreated = json['neuralTreated'];
    neuralRefer = json['neuralRefer'];
    neuralReferSkNagpur = json['neuralRefer_SkNagpur'];
    neuralReferRH = json['neural_Refer_RH'];
    neuralReferSDH = json['neural_Refer_SDH'];
    neuralReferDH = json['neural_Refer_DH'];
    neuralReferGMC = json['neural_Refer_GMC'];
    neuralReferIGMC = json['neural_Refer_IGMC'];
    neuralReferMJMJYAndMOUY = json['neural_Refer_MJMJYAndMOUY'];
    neuralReferDEIC = json['neural_Refer_DEIC'];
    neuralTubeDefectsNote = json['neuralTubeDefects_Note'];
    downsSyndrome = json['downsSyndrome'];
    downsTreated = json['downsTreated'];
    downsRefer = json['downsRefer'];
    downsReferSKNagpur = json['downsRefer_SKNagpur'];
    downsReferRH = json['downs_Refer_RH'];
    downsReferDH = json['downs_Refer_DH'];
    downsReferSDH = json['downs_Refer_SDH'];
    downsReferGMC = json['downs_Refer_GMC'];
    downsReferIGMC = json['downs_Refer_IGMC'];
    downsReferMJMJYAndMOUY = json['downs_Refer_MJMJYAndMOUY'];
    downsReferDEIC = json['downs_Refer_DEIC'];
    downsSyndromeNote = json['downsSyndrome_Note'];
    cleftLipAndPalate = json['cleftLipAndPalate'];
    cleftTreated = json['cleftTreated'];
    cleftRefer = json['cleftRefer'];
    cleftReferSKNagpur = json['cleftRefer_SKNagpur'];
    cleftReferRH = json['cleft_Refer_RH'];
    cleftReferSDH = json['cleft_Refer_SDH'];
    cleftReferDH = json['cleft_Refer_DH'];
    cleftReferGMC = json['cleft_Refer_GMC'];
    cleftReferIGMC = json['cleft_Refer_IGMC'];
    cleftReferMJMJYAndMOUY = json['cleft_Refer_MJMJYAndMOUY'];
    cleftReferDEIC = json['cleft_Refer_DEIC'];
    cleftLipAndPalateNote = json['cleftLipAndPalate_Note'];
    talipesClubFoot = json['talipesClubFoot'];
    talipesTreated = json['talipesTreated'];
    talipseRefer = json['talipseRefer'];
    talipseReferSKNagpur = json['talipseRefer_SKNagpur'];
    talipseReferRH = json['talipse_Refer_RH'];
    talipseReferSDH = json['talipse_Refer_SDH'];
    talipseReferDH = json['talipse_Refer_DH'];
    talipseReferGMC = json['talipse_Refer_GMC'];
    talipseReferIGMC = json['talipse_Refer_IGMC'];
    talipseReferMJMJYAndMOUY = json['talipse_Refer_MJMJYAndMOUY'];
    talipseReferDEIC = json['talipse_Refer_DEIC'];
    talipesClubFootNote = json['talipesClubFoot_Note'];
    dvelopmentalDysplasiaOfHip = json['dvelopmentalDysplasiaOfHip'];
    hipTreated = json['hipTreated'];
    hipRefer = json['hipRefer'];
    hipReferSKNagpur = json['hipRefer_SKNagpur'];
    hipReferRH = json['hip_Refer_RH'];
    hipReferSDH = json['hip_Refer_SDH'];
    hipReferDH = json['hip_Refer_DH'];
    hipReferGMC = json['hip_Refer_GMC'];
    hipReferIGMC = json['hip_Refer_IGMC'];
    hipReferMJMJYAndMOUY = json['hip_Refer_MJMJYAndMOUY'];
    hipReferDEIC = json['hip_Refer_DEIC'];
    dvelopmentalDysplasiaOfHipNote = json['dvelopmentalDysplasiaOfHip_Note'];
    congenitalCatract = json['congenitalCatract'];
    congenitalTarget = json['congenitalTarget'];
    congenitalRefer = json['congenitalRefer'];
    congenitalReferSKNagpur = json['congenitalRefer_SKNagpur'];
    coReferRH = json['co_Refer_RH'];
    coReferSDH = json['co_Refer_SDH'];
    coReferDH = json['co_Refer_DH'];
    coReferGMC = json['co_Refer_GMC'];
    coReferIGMC = json['co_Refer_IGMC'];
    coReferMJMJYAndMOUY = json['co_Refer_MJMJYAndMOUY'];
    coReferDEIC = json['co_Refer_DEIC'];
    congenitalCatractNote = json['congenitalCatract_Note'];
    congenitalDeafness = json['congenitalDeafness'];
    deafnessTarget = json['deafnessTarget'];
    deafnessRefer = json['deafnessRefer'];
    deafnessReferSKNagpur = json['deafnessRefer_SKNagpur'];
    cdReferRH = json['cd_Refer_RH'];
    cdReferSDH = json['cd_Refer_SDH'];
    cdReferDH = json['cd_Refer_DH'];
    cdReferGMC = json['cd_Refer_GMC'];
    cdReferIGMC = json['cd_Refer_IGMC'];
    cdReferMJMJYAndMOUY = json['cd_Refer_MJMJYAndMOUY'];
    cdReferDEIC = json['cd_Refer_DEIC'];
    congenitalDeafnessNote = json['congenitalDeafness_Note'];
    congentialHeartDisease = json['congentialHeartDisease'];
    heartDiseaseTarget = json['heartDiseaseTarget'];
    heartDiseaseRefer = json['heartDiseaseRefer'];
    heartDiseaseReferSKNagpur = json['heartDiseaseRefer_SKNagpur'];
    hdReferRH = json['hd_Refer_RH'];
    hdReferSDH = json['hd_Refer_SDH'];
    hdReferDH = json['hd_Refer_DH'];
    hdReferGMC = json['hd_Refer_GMC'];
    hdReferIGMC = json['hd_Refer_IGMC'];
    hdReferMJMJYAndMOUY = json['hd_Refer_MJMJYAndMOUY'];
    hdReferDEIC = json['hd_Refer_DEIC'];
    congentialHeartDiseaseNote = json['congentialHeartDisease_Note'];
    retinopathyOfPrematurity = json['retinopathyOfPrematurity'];
    retinopathyTreated = json['retinopathyTreated'];
    retinopathyRefer = json['retinopathyRefer'];
    retinopathyReferSKNagpur = json['retinopathyRefer_SKNagpur'];
    rpReferRH = json['rp_Refer_RH'];
    rpReferSDH = json['rp_Refer_SDH'];
    rpReferDH = json['rp_Refer_DH'];
    rpReferGMC = json['rp_Refer_GMC'];
    rpReferIGMC = json['rp_Refer_IGMC'];
    rpReferMJMJYAndMOUY = json['rp_Refer_MJMJYAndMOUY'];
    rpReferDEIC = json['rp_Refer_DEIC'];
    retinopathyOfPrematurityNote = json['retinopathyOfPrematurity_Note'];
    other = json['other'];
    otherTreated = json['otherTreated'];
    otherRefer = json['otherRefer'];
    otherReferSKNagpur = json['otherRefer_SKNagpur'];
    otherReferRH = json['other_Refer_RH'];
    otherReferSDH = json['other_Refer_SDH'];
    otherReferDH = json['other_Refer_DH'];
    otherReferGMC = json['other_Refer_GMC'];
    otherReferIGMC = json['other_Refer_IGMC'];
    otherReferMJMJYAndMOUY = json['other_Refer_MJMJYAndMOUY'];
    otherReferDEIC = json['other_Refer_DEIC'];
    otherNote = json['other_Note'];
    deficiencesAtBirth = json['deficiencesAtBirth'];
    anemia = json['anemia'];
    anemiaTreated = json['anemiaTreated'];
    anemiaRefer = json['anemiaRefer'];
    anemiaReferSKNagpur = json['anemiaRefer_SKNagpur'];
    anemiaReferRH = json['anemia_Refer_RH'];
    anemiaReferSDH = json['anemia_Refer_SDH'];
    anemiaReferDH = json['anemia_Refer_DH'];
    anemiaReferGMC = json['anemia_Refer_GMC'];
    anemiaReferIGMC = json['anemia_Refer_IGMC'];
    anemiaReferMJMJYAndMOUY = json['anemia_Refer_MJMJYAndMOUY'];
    anemiaReferDEIC = json['anemia_Refer_DEIC'];
    anemiaNote = json['anemia_Note'];
    vitaminADef = json['vitaminADef'];
    vitaminATreated = json['vitaminATreated'];
    vitaminARefer = json['vitaminARefer'];
    vitaminAReferSKNagpur = json['vitaminARefer_SKNagpur'];
    vAReferRH = json['vA_Refer_RH'];
    vAReferSDH = json['vA_Refer_SDH'];
    vAReferDH = json['vA_Refer_DH'];
    vAReferGMC = json['vA_Refer_GMC'];
    vAReferIGMC = json['vA_Refer_IGMC'];
    vAReferMJMJYAndMOUY = json['vA_Refer_MJMJYAndMOUY'];
    vAReferDEIC = json['vA_Refer_DEIC'];
    vitaminADefNote = json['vitaminADef_Note'];
    vitaminDDef = json['vitaminDDef'];
    vitaminDTreated = json['vitaminDTreated'];
    vitaminDRefer = json['vitaminDRefer'];
    vitaminDReferSKNagpur = json['vitaminDRefer_SKNagpur'];
    vDReferRH = json['vD_Refer_RH'];
    vDReferSDH = json['vD_Refer_SDH'];
    vDReferDH = json['vD_Refer_DH'];
    vDReferGMC = json['vD_Refer_GMC'];
    vDReferIGMC = json['vD_Refer_IGMC'];
    vDReferMJMJYAndMOUY = json['vD_Refer_MJMJYAndMOUY'];
    vDReferDEIC = json['vD_Refer_DEIC'];
    vitaminDDefNote = json['vitaminDDef_Note'];
    saMStunting = json['saM_Stunting'];
    samTreated = json['samTreated'];
    samRefer = json['samRefer'];
    samReferSKNagpur = json['samRefer_SKNagpur'];
    samReferRH = json['sam_Refer_RH'];
    samReferSDH = json['sam_Refer_SDH'];
    samReferDH = json['sam_Refer_DH'];
    samReferGMC = json['sam_Refer_GMC'];
    samReferIGMC = json['sam_Refer_IGMC'];
    samReferMJMJYAndMOUY = json['sam_Refer_MJMJYAndMOUY'];
    samReferDEIC = json['sam_Refer_DEIC'];
    saMStuntingNote = json['saM_Stunting_Note'];
    goiter = json['goiter'];
    goiterTreated = json['goiterTreated'];
    goiterRefer = json['goiterRefer'];
    goiterReferSKNagpur = json['goiterRefer_SKNagpur'];
    gReferRH = json['g_Refer_RH'];
    gReferSDH = json['g_Refer_SDH'];
    gReferDH = json['g_Refer_DH'];
    gReferGMC = json['g_Refer_GMC'];
    gReferIGMC = json['g_Refer_IGMC'];
    gReferMJMJYAndMOUY = json['g_Refer_MJMJYAndMOUY'];
    gReferDEIC = json['g_Refer_DEIC'];
    goiterNote = json['goiter_Note'];
    vitaminBcomplexDef = json['vitaminBcomplexDef'];
    vitaminBTreated = json['vitaminBTreated'];
    vitaminBRefer = json['vitaminBRefer'];
    vitaminBReferSKNagpur = json['vitaminBRefer_SKNagpur'];
    vBReferRH = json['vB_Refer_RH'];
    vBReferSDH = json['vB_Refer_SDH'];
    vBReferDH = json['vB_Refer_DH'];
    vBReferGMC = json['vB_Refer_GMC'];
    vBReferIGMC = json['vB_Refer_IGMC'];
    vBReferMJMJYAndMOUY = json['vB_Refer_MJMJYAndMOUY'];
    vBReferDEIC = json['vB_Refer_DEIC'];
    vitaminBcomplexDefNote = json['vitaminBcomplexDef_Note'];
    othersSpecify = json['othersSpecify'];
    othersTreated = json['othersTreated'];
    othersRefer = json['othersRefer'];
    othersReferSKNagpur = json['othersRefer_SKNagpur'];
    otReferRH = json['ot_Refer_RH'];
    otReferSDH = json['ot_Refer_SDH'];
    otReferDH = json['ot_Refer_DH'];
    otReferGMC = json['ot_Refer_GMC'];
    otReferIGMC = json['ot_Refer_IGMC'];
    otReferMJMJYAndMOUY = json['ot_Refer_MJMJYAndMOUY'];
    otReferDEIC = json['ot_Refer_DEIC'];
    othersSpecifyNote = json['othersSpecify_Note'];
    diseases = json['diseases'];
    skinConditionsNotLeprosy = json['skinConditionsNotLeprosy'];
    skinTrated = json['skinTrated'];
    skinRefer = json['skinRefer'];
    skinReferSKNagpur = json['skinRefer_SKNagpur'];
    skReferRH = json['sk_Refer_RH'];
    skReferSDH = json['sk_Refer_SDH'];
    skReferDH = json['sk_Refer_DH'];
    skReferGMC = json['sk_Refer_GMC'];
    skReferIGMC = json['sk_Refer_IGMC'];
    skReferMJMJYAndMOUY = json['sk_Refer_MJMJYAndMOUY'];
    skReferDEIC = json['sk_Refer_DEIC'];
    skinConditionsNotLeprosyNote = json['skinConditionsNotLeprosy_Note'];
    otitisMedia = json['otitisMedia'];
    otitisMediaTreated = json['otitisMediaTreated'];
    otitisMediaRefer = json['otitisMediaRefer'];
    otitisMediaReferSKNagpur = json['otitisMediaRefer_SKNagpur'];
    otmReferRH = json['otm_Refer_RH'];
    otmReferSDH = json['otm_Refer_SDH'];
    otmReferDH = json['otm_Refer_DH'];
    otmReferGMC = json['otm_Refer_GMC'];
    otmReferIGMC = json['otm_Refer_IGMC'];
    otmReferMJMJYAndMOUY = json['otm_Refer_MJMJYAndMOUY'];
    otmReferDEIC = json['otm_Refer_DEIC'];
    otitisMediaNote = json['otitisMedia_Note'];
    rehumaticHeartDisease = json['rehumaticHeartDisease'];
    rehumaticTrated = json['rehumaticTrated'];
    rehumaticRefer = json['rehumaticRefer'];
    rehumaticReferSKNagpur = json['rehumaticRefer_SKNagpur'];
    reReferRH = json['re_Refer_RH'];
    reReferSDH = json['re_Refer_SDH'];
    reReferDH = json['re_Refer_DH'];
    reReferGMC = json['re_Refer_GMC'];
    reReferIGMC = json['re_Refer_IGMC'];
    reReferMJMJYAndMOUY = json['re_Refer_MJMJYAndMOUY'];
    reReferDEIC = json['re_Refer_DEIC'];
    rehumaticHeartDiseaseNote = json['rehumaticHeartDisease_Note'];
    reactiveAirwayDisease = json['reactiveAirwayDisease'];
    reactiveTreated = json['reactiveTreated'];
    reactiveRefer = json['reactiveRefer'];
    reactiveReferSKNagpur = json['reactiveRefer_SKNagpur'];
    raReferRH = json['ra_Refer_RH'];
    raReferSDH = json['ra_Refer_SDH'];
    raReferDH = json['ra_Refer_DH'];
    raReferGMC = json['ra_Refer_GMC'];
    raReferIGMC = json['ra_Refer_IGMC'];
    raReferMJMJYAndMOUY = json['ra_Refer_MJMJYAndMOUY'];
    raReferDEIC = json['ra_Refer_DEIC'];
    reactiveAirwayDiseaseNote = json['reactiveAirwayDisease_Note'];
    dentalConditions = json['dentalConditions'];
    dentalTrated = json['dentalTrated'];
    dentalRefer = json['dentalRefer'];
    dentalReferSKNagpur = json['dentalRefer_SKNagpur'];
    deReferRH = json['de_Refer_RH'];
    deReferSDH = json['de_Refer_SDH'];
    deReferDH = json['de_Refer_DH'];
    deReferGMC = json['de_Refer_GMC'];
    deReferIGMC = json['de_Refer_IGMC'];
    deReferMJMJYAndMOUY = json['de_Refer_MJMJYAndMOUY'];
    deReferDEIC = json['de_Refer_DEIC'];
    dentalConditionsNote = json['dentalConditions_Note'];
    childhoodLeprosyDisease = json['childhoodLeprosyDisease'];
    childhoodTreated = json['childhoodTreated'];
    childhoodRefer = json['childhoodRefer'];
    childhoodReferSKNagpur = json['childhoodRefer_SKNagpur'];
    chReferRH = json['ch_Refer_RH'];
    chReferSDH = json['ch_Refer_SDH'];
    chReferDH = json['ch_Refer_DH'];
    chReferGMC = json['ch_Refer_GMC'];
    chReferIGMC = json['ch_Refer_IGMC'];
    chReferMJMJYAndMOUY = json['ch_Refer_MJMJYAndMOUY'];
    chReferDEIC = json['ch_Refer_DEIC'];
    childhoodLeprosyDiseaseNote = json['childhoodLeprosyDisease_Note'];
    childhoodTuberculosis = json['childhoodTuberculosis'];
    cTuberculosisTreated = json['cTuberculosisTreated'];
    cTuberculosisRefer = json['cTuberculosisRefer'];
    cTuberculosisReferSKNagpur = json['cTuberculosisRefer_SKNagpur'];
    cTuReferRH = json['cTu_Refer_RH'];
    cTuReferSDH = json['cTu_Refer_SDH'];
    cTuReferDH = json['cTu_Refer_DH'];
    cTuReferGMC = json['cTu_Refer_GMC'];
    cTuReferIGMC = json['cTu_Refer_IGMC'];
    cTuReferMJMJYAndMOUY = json['cTu_Refer_MJMJYAndMOUY'];
    cTuReferDEIC = json['cTu_Refer_DEIC'];
    childhoodTuberculosisNote = json['childhoodTuberculosis_Note'];
    childhoodTuberculosisExtraPulmonary =
        json['childhoodTuberculosisExtraPulmonary'];
    cTuExtraTreated = json['cTuExtraTreated'];
    cTuExtraRefer = json['cTuExtraRefer'];
    cTuExtraReferSKNagpur = json['cTuExtraRefer_SKNagpur'];
    cTuExtraReferRH = json['cTuExtra_Refer_RH'];
    cTuExtraReferSDH = json['cTuExtra_Refer_SDH'];
    cTuExtraReferDH = json['cTuExtra_Refer_DH'];
    cTuExtraReferGMC = json['cTuExtra_Refer_GMC'];
    cTuExtraReferIGMC = json['cTuExtra_Refer_IGMC'];
    cTuExtraReferMJMJYAndMOUY = json['cTuExtra_Refer_MJMJYAndMOUY'];
    cTuExtraReferDEIC = json['cTuExtra_Refer_DEIC'];
    childhoodTuberculosisExtraPulmonaryNote =
        json['childhoodTuberculosisExtraPulmonary_Note'];
    otherdisease = json['other_disease'];
    otherdiseaseTreated = json['other_diseaseTreated'];
    otherdiseaseRefer = json['other_diseaseRefer'];
    otherdiseaseReferSKNagpur = json['other_diseaseRefer_SKNagpur'];
    otherdiseaseReferRH = json['other_diseaseRefer_RH'];
    otherdiseaseReferSDH = json['other_diseaseRefer_SDH'];
    otherdiseaseReferDH = json['other_diseaseRefer_DH'];
    otherdiseaseReferGMC = json['other_diseaseRefer_GMC'];
    otherdiseaseReferIGMC = json['other_diseaseRefer_IGMC'];
    otherdiseaseMJMJYAndMOUY = json['other_diseaseMJMJYAndMOUY'];
    otherdiseaseReferDEIC = json['other_diseaseRefer_DEIC'];
    otherdiseaseNote = json['other_disease_Note'];
    developmentalDelayIncludingDisability =
        json['developmentalDelayIncludingDisability'];
    visionImpairment = json['visionImpairment'];
    visionTreated = json['visionTreated'];
    visionRefer = json['visionRefer'];
    visionReferSKNagpur = json['visionRefer_SKNagpur'];
    visionReferRH = json['vision_Refer_RH'];
    visionReferSDH = json['vision_Refer_SDH'];
    visionReferDH = json['vision_Refer_DH'];
    visionReferGMC = json['vision_Refer_GMC'];
    visionReferIGMC = json['vision_Refer_IGMC'];
    visionReferMJMJYAndMOUY = json['vision_Refer_MJMJYAndMOUY'];
    visionReferDEIC = json['vision_Refer_DEIC'];
    visionImpairmentNote = json['visionImpairment_Note'];
    hearingImpairment = json['hearingImpairment'];
    hearingTreated = json['hearingTreated'];
    hearingRefer = json['hearingRefer'];
    hearingReferSKNagpur = json['hearingRefer_SKNagpur'];
    hearingReferRH = json['hearing_Refer_RH'];
    hearingReferSDH = json['hearing_Refer_SDH'];
    hearingReferDH = json['hearing_Refer_DH'];
    hearingReferGMC = json['hearing_Refer_GMC'];
    hearingReferIGMC = json['hearing_Refer_IGMC'];
    hearingReferMJMJYAndMOUY = json['hearing_Refer_MJMJYAndMOUY'];
    hearingReferDEIC = json['hearing_Refer_DEIC'];
    hearingImpairmentNote = json['hearingImpairment_Note'];
    neuromotorImpairment = json['neuromotorImpairment'];
    neuromotorTreated = json['neuromotorTreated'];
    neuromotorRefer = json['neuromotorRefer'];
    neuromotorReferSKNagpur = json['neuromotorRefer_SKNagpur'];
    neuroReferRH = json['neuro_Refer_RH'];
    neuroReferSDH = json['neuro_Refer_SDH'];
    neuroReferDH = json['neuro_Refer_DH'];
    neuroReferGMC = json['neuro_Refer_GMC'];
    neuroReferIGMC = json['neuro_Refer_IGMC'];
    neuroReferMJMJYAndMOUY = json['neuro_Refer_MJMJYAndMOUY'];
    neuroReferDEIC = json['neuro_Refer_DEIC'];
    neuromotorImpairmentNote = json['neuromotorImpairment_Note'];
    motorDelay = json['motorDelay'];
    motorDealyTrated = json['motorDealyTrated'];
    motorDelayRefer = json['motorDelayRefer'];
    motorDelayReferSKNagpur = json['motorDelayRefer_SKNagpur'];
    motorReferRH = json['motor_Refer_RH'];
    motorReferSDH = json['motor_Refer_SDH'];
    motorReferDH = json['motor_Refer_DH'];
    motorReferGMC = json['motor_Refer_GMC'];
    motorReferIGMC = json['motor_Refer_IGMC'];
    motorReferMJMJYAndMOUY = json['motor_Refer_MJMJYAndMOUY'];
    motorReferDEIC = json['motor_Refer_DEIC'];
    motorDelayNote = json['motorDelay_Note'];
    cognitiveDelay = json['cognitiveDelay'];
    cognitiveTrated = json['cognitiveTrated'];
    cognitiveRefer = json['cognitiveRefer'];
    cognitiveReferSKNagpur = json['cognitiveRefer_SKNagpur'];
    cognitiveReferRH = json['cognitive_Refer_RH'];
    cognitiveReferSDH = json['cognitive_Refer_SDH'];
    cognitiveReferDH = json['cognitive_Refer_DH'];
    cognitiveReferGMC = json['cognitive_Refer_GMC'];
    cognitiveReferIGMC = json['cognitive_Refer_IGMC'];
    cognitiveReferMJMJYAndMOUY = json['cognitive_Refer_MJMJYAndMOUY'];
    cognitiveReferDEIC = json['cognitive_Refer_DEIC'];
    cognitiveDelayNote = json['cognitiveDelay_Note'];
    speechAndLanguageDelay = json['speechAndLanguageDelay'];
    speechTreated = json['speechTreated'];
    speechRefer = json['speechRefer'];
    speechReferSKNagpur = json['speechRefer_SKNagpur'];
    speechReferRH = json['speech_Refer_RH'];
    speechReferSDH = json['speech_Refer_SDH'];
    speechReferDH = json['speech_Refer_DH'];
    speechReferGMC = json['speech_Refer_GMC'];
    speechReferIGMC = json['speech_Refer_IGMC'];
    speechReferMJMJYAndMOUY = json['speech_Refer_MJMJYAndMOUY'];
    speechReferDEIC = json['speech_Refer_DEIC'];
    speechAndLanguageDelayNote = json['speechAndLanguageDelay_Note'];
    behaviouralDisorder = json['behaviouralDisorder'];
    behaviouralTreated = json['behaviouralTreated'];
    behavoiuralRefer = json['behavoiuralRefer'];
    behavoiuralReferSKNagpur = json['behavoiuralRefer_SKNagpur'];
    behavoiuralReferRH = json['behavoiural_Refer_RH'];
    behavoiuralReferSDH = json['behavoiural_Refer_SDH'];
    behavoiuralReferDH = json['behavoiural_Refer_DH'];
    behavoiuralReferGMC = json['behavoiural_Refer_GMC'];
    behavoiuralReferIGMC = json['behavoiural_Refer_IGMC'];
    behavoiuralReferMJMJYAndMOUY = json['behavoiural_Refer_MJMJYAndMOUY'];
    behavoiuralReferDEIC = json['behavoiural_Refer_DEIC'];
    behaviouralDisorderNote = json['behaviouralDisorder_Note'];
    learningDisorder = json['learningDisorder'];
    learningTreated = json['learningTreated'];
    learningRefer = json['learningRefer'];
    learningReferSKNagpur = json['learningRefer_SKNagpur'];
    learningReferRH = json['learning_Refer_RH'];
    learningReferSDH = json['learning_Refer_SDH'];
    learningReferDH = json['learning_Refer_DH'];
    learningReferGMC = json['learning_Refer_GMC'];
    learningReferIGMC = json['learning_Refer_IGMC'];
    learningReferMJMJYAndMOUY = json['learning_Refer_MJMJYAndMOUY'];
    learningReferDEIC = json['learning_Refer_DEIC'];
    learningDisorderNote = json['learningDisorder_Note'];
    attentionDeficitHyperactivityDisorder =
        json['attentionDeficitHyperactivityDisorder'];
    attentionTreated = json['attentionTreated'];
    attentionRefer = json['attentionRefer'];
    attentionReferSKNagpur = json['attentionRefer_SKNagpur'];
    attentionReferRH = json['attention_Refer_RH'];
    attentionReferSDH = json['attention_Refer_SDH'];
    attentionReferDH = json['attention_Refer_DH'];
    attentionReferGMC = json['attention_Refer_GMC'];
    attentionReferIGMC = json['attention_Refer_IGMC'];
    attentionReferMJMJYAndMOUY = json['attention_Refer_MJMJYAndMOUY'];
    attentionReferDEIC = json['attention_Refer_DEIC'];
    attentionDeficitHyperactivityDisorderNote =
        json['attentionDeficitHyperactivityDisorder_Note'];
    otherddid = json['other_ddid'];
    otherddidTreated = json['other_ddidTreated'];
    otherddidRefer = json['other_ddidRefer'];
    otherddidReferSKNagpur = json['other_ddidRefer_SKNagpur'];
    otherddidReferRH = json['other_ddidRefer_RH'];
    otherddidReferSDH = json['other_ddidRefer_SDH'];
    otherddidReferDH = json['other_ddidRefer_DH'];
    otherddidReferGMC = json['other_ddidRefer_GMC'];
    otherddidReferIGMC = json['other_ddidRefer_IGMC'];
    otherddidMJMJYAndMOUY = json['other_ddidMJMJYAndMOUY'];
    otherddidReferDEIC = json['other_ddidRefer_DEIC'];
    otherddidNote = json['other_ddid_Note'];
    adolescentSpecificQuestionnare = json['adolescentSpecificQuestionnare'];
    growingUpConcerns = json['growingUpConcerns'];
    growingTreated = json['growingTreated'];
    growingRefer = json['growingRefer'];
    growingReferSKNagpur = json['growingRefer_SKNagpur'];
    growingReferRH = json['growing_Refer_RH'];
    growingReferSDH = json['growing_Refer_SDH'];
    growingReferDH = json['growing_Refer_DH'];
    growingReferGMC = json['growing_Refer_GMC'];
    growingReferIGMC = json['growing_Refer_IGMC'];
    growingReferMJMJYAndMOUY = json['growing_Refer_MJMJYAndMOUY'];
    growingReferDEIC = json['growing_Refer_DEIC'];
    growingUpConcernsNote = json['growingUpConcerns_Note'];
    substanceAbuse = json['substanceAbuse'];
    substanceTreated = json['substanceTreated'];
    substanceRefer = json['substanceRefer'];
    substanceReferSKNagpur = json['substanceRefer_SKNagpur'];
    substanceReferRH = json['substance_Refer_RH'];
    substanceReferSDH = json['substance_Refer_SDH'];
    substanceReferDH = json['substance_Refer_DH'];
    substanceReferGMC = json['substance_Refer_GMC'];
    substanceReferIGMC = json['substance_Refer_IGMC'];
    substanceReferMJMJYAndMOUY = json['substance_Refer_MJMJYAndMOUY'];
    substanceReferDEIC = json['substance_Refer_DEIC'];
    substanceAbuseNote = json['substanceAbuse_Note'];
    feelDepressed = json['feelDepressed'];
    feelTreated = json['feelTreated'];
    feelRefer = json['feelRefer'];
    feelReferSKNagpur = json['feelRefer_SKNagpur'];
    feelReferRH = json['feel_Refer_RH'];
    feelReferSDH = json['feel_Refer_SDH'];
    feelReferDH = json['feel_Refer_DH'];
    feelReferGMC = json['feel_Refer_GMC'];
    feelReferIGMC = json['feel_Refer_IGMC'];
    feelReferMJMJYAndMOUY = json['feel_Refer_MJMJYAndMOUY'];
    feelReferDEIC = json['feel_Refer_DEIC'];
    feelDepressedNote = json['feelDepressed_Note'];
    delayInMenstrualCycles = json['delayInMenstrualCycles'];
    delayTreated = json['delayTreated'];
    delayRefer = json['delayRefer'];
    delayReferSKNagpur = json['delayRefer_SKNagpur'];
    delayReferRH = json['delay_Refer_RH'];
    delayReferSDH = json['delay_Refer_SDH'];
    delayReferDH = json['delay_Refer_DH'];
    delayReferGMC = json['delay_Refer_GMC'];
    delayReferIGMC = json['delay_Refer_IGMC'];
    delayReferMJMJYAndMOUY = json['delay_Refer_MJMJYAndMOUY'];
    delayReferDEIC = json['delay_Refer_DEIC'];
    delayInMenstrualCyclesNote = json['delayInMenstrualCycles_Note'];
    irregularPeriods = json['irregularPeriods'];
    irregularTreated = json['irregularTreated'];
    irregularRefer = json['irregularRefer'];
    irregularReferSKNagpur = json['irregularRefer_SKNagpur'];
    irregularReferRH = json['irregular_Refer_RH'];
    irregularReferSDH = json['irregular_Refer_SDH'];
    irregularReferDH = json['irregular_Refer_DH'];
    irregularReferGMC = json['irregular_Refer_GMC'];
    irregularReferIGMC = json['irregular_Refer_IGMC'];
    irregularReferMJMJYAndMOUY = json['irregular_Refer_MJMJYAndMOUY'];
    irregularReferDEIC = json['irregular_Refer_DEIC'];
    irregularPeriodsNote = json['irregularPeriods_Note'];
    painOrBurningSensationWhileUrinating =
        json['painOrBurningSensationWhileUrinating'];
    painOrBurningTreated = json['painOrBurningTreated'];
    painOrBurningRefer = json['painOrBurningRefer'];
    painOrBurningReferSKNagpur = json['painOrBurningRefer_SKNagpur'];
    painOrBurningReferRH = json['painOrBurning_Refer_RH'];
    painOrBurningReferSDH = json['painOrBurning_Refer_SDH'];
    painOrBurningReferDH = json['painOrBurning_Refer_DH'];
    painOrBurningReferGMC = json['painOrBurning_Refer_GMC'];
    painOrBurningReferIGMC = json['painOrBurning_Refer_IGMC'];
    painOrBurningReferMJMJYAndMOUY = json['painOrBurning_Refer_MJMJYAndMOUY'];
    painOrBurningReferDEIC = json['painOrBurning_Refer_DEIC'];
    painOrBurningSensationWhileUrinatingNote =
        json['painOrBurningSensationWhileUrinating_Note'];
    discharge = json['discharge'];
    dischargeTreated = json['dischargeTreated'];
    dischargeRefer = json['dischargeRefer'];
    dischargeReferSKNagpur = json['dischargeRefer_SKNagpur'];
    dischargeReferRH = json['discharge_Refer_RH'];
    dischargeReferSDH = json['discharge_Refer_SDH'];
    dischargeReferDH = json['discharge_Refer_DH'];
    dischargeReferGMC = json['discharge_Refer_GMC'];
    dischargeReferIGMC = json['discharge_Refer_IGMC'];
    dischargeReferMJMJYAndMOUY = json['discharge_Refer_MJMJYAndMOUY'];
    dischargeReferDEIC = json['discharge_Refer_DEIC'];
    dischargeNote = json['discharge_Note'];
    painDuringMenstruation = json['painDuringMenstruation'];
    painDuringTreated = json['painDuringTreated'];
    painDuringRefer = json['painDuringRefer'];
    painDuringReferSKNagpur = json['painDuringRefer_SKNagpur'];
    painDuringReferRH = json['painDuring_Refer_RH'];
    painDuringReferSDH = json['painDuring_Refer_SDH'];
    painDuringReferDH = json['painDuring_Refer_DH'];
    painDuringReferGMC = json['painDuring_Refer_GMC'];
    painDuringReferIGMC = json['painDuring_Refer_IGMC'];
    painDuringReferMJMJYAndMOUY = json['painDuring_Refer_MJMJYAndMOUY'];
    painDuringReferDEIC = json['painDuring_Refer_DEIC'];
    painDuringMenstruationNote = json['painDuringMenstruation_Note'];
    otherasq = json['other_asq'];
    otherasqTreated = json['other_asqTreated'];
    otherasqRefer = json['other_asqRefer'];
    otherasqReferSKNagpur = json['other_asqRefer_SKNagpur'];
    otherasqReferRH = json['other_asqRefer_RH'];
    otherasqReferSDH = json['other_asqRefer_SDH'];
    otherasqReferDH = json['other_asqRefer_DH'];
    otherasqReferGMC = json['other_asqRefer_GMC'];
    otherasqReferIGMC = json['other_asqRefer_IGMC'];
    otherasqMJMJYAndMOUY = json['other_asqMJMJYAndMOUY'];
    otherasqReferDEIC = json['other_asqRefer_DEIC'];
    otherasqNote = json['other_asq_Note'];
    disibility = json['disibility'];
    disibilityTreated = json['disibilityTreated'];
    disibilityRefer = json['disibilityRefer'];
    disibilityReferSKNagpur = json['disibilityRefer_SKNagpur'];
    disibilityRH = json['disibility_RH'];
    disibilitySDH = json['disibility_SDH'];
    disibilityDH = json['disibility_DH'];
    disibilityGMC = json['disibility_GMC'];
    disibilityIGMC = json['disibility_IGMC'];
    disibilityMJMJYAndMOUY = json['disibility_MJMJYAndMOUY'];
    disibilityDEIC = json['disibility_DEIC'];
    disibilityNote = json['disibility_Note'];
    doctorName = json['doctorName'];
    userId = json['userId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['schoolId'] = schoolId;
    data['anganwadi'] = anganwadi;
    data['miniAnganwadi'] = miniAnganwadi;
    data['firstClass'] = firstClass;
    data['secondClass'] = secondClass;
    data['thirdClass'] = thirdClass;
    data['fourthClass'] = fourthClass;
    data['fifthClass'] = fifthClass;
    data['sixthClass'] = sixthClass;
    data['seventhClass'] = seventhClass;
    data['eighthClass'] = eighthClass;
    data['ninthClass'] = ninthClass;
    data['tenthClass'] = tenthClass;
    data['eleventhClass'] = eleventhClass;
    data['twelthClass'] = twelthClass;
    data['childName'] = childName;
    data['age'] = age;
    data['gender'] = gender;
    data['aadhaarNo'] = aadhaarNo;
    data['fathersName'] = fathersName;
    data['fathersContactNo'] = fathersContactNo;
    data['weightInKg'] = weightInKg;
    data['heightInCm'] = heightInCm;
    data['weightHeightNormal'] = weightHeightNormal;
    data['weightHeightSAM'] = weightHeightSAM;
    data['weightHeightMAM'] = weightHeightMAM;
    data['weightHeightSUW'] = weightHeightSUW;
    data['weightHeightMUW'] = weightHeightMUW;
    data['weightHeightStunted'] = weightHeightStunted;
    data['bloodPressure'] = bloodPressure;
    data['bpNormal'] = bpNormal;
    data['bpPrehypertension'] = bpPrehypertension;
    data['bpStage1HTN'] = bpStage1HTN;
    data['bpStage2HTN'] = bpStage2HTN;
    data['acuityOfVision'] = acuityOfVision;
    data['acuityOfLeftEye'] = acuityOfLeftEye;
    data['acuityOfRightEye'] = acuityOfRightEye;
    data['defectsAtBirth'] = defectsAtBirth;
    data['neuralTubeDefects'] = neuralTubeDefects;
    data['neuralTreated'] = neuralTreated;
    data['neuralRefer'] = neuralRefer;
    data['neuralRefer_SkNagpur'] = neuralReferSkNagpur;
    data['neural_Refer_RH'] = neuralReferRH;
    data['neural_Refer_SDH'] = neuralReferSDH;
    data['neural_Refer_DH'] = neuralReferDH;
    data['neural_Refer_GMC'] = neuralReferGMC;
    data['neural_Refer_IGMC'] = neuralReferIGMC;
    data['neural_Refer_MJMJYAndMOUY'] = neuralReferMJMJYAndMOUY;
    data['neural_Refer_DEIC'] = neuralReferDEIC;
    data['neuralTubeDefects_Note'] = neuralTubeDefectsNote;
    data['downsSyndrome'] = downsSyndrome;
    data['downsTreated'] = downsTreated;
    data['downsRefer'] = downsRefer;
    data['downsRefer_SKNagpur'] = downsReferSKNagpur;
    data['downs_Refer_RH'] = downsReferRH;
    data['downs_Refer_DH'] = downsReferDH;
    data['downs_Refer_SDH'] = downsReferSDH;
    data['downs_Refer_GMC'] = downsReferGMC;
    data['downs_Refer_IGMC'] = downsReferIGMC;
    data['downs_Refer_MJMJYAndMOUY'] = downsReferMJMJYAndMOUY;
    data['downs_Refer_DEIC'] = downsReferDEIC;
    data['downsSyndrome_Note'] = downsSyndromeNote;
    data['cleftLipAndPalate'] = cleftLipAndPalate;
    data['cleftTreated'] = cleftTreated;
    data['cleftRefer'] = cleftRefer;
    data['cleftRefer_SKNagpur'] = cleftReferSKNagpur;
    data['cleft_Refer_RH'] = cleftReferRH;
    data['cleft_Refer_SDH'] = cleftReferSDH;
    data['cleft_Refer_DH'] = cleftReferDH;
    data['cleft_Refer_GMC'] = cleftReferGMC;
    data['cleft_Refer_IGMC'] = cleftReferIGMC;
    data['cleft_Refer_MJMJYAndMOUY'] = cleftReferMJMJYAndMOUY;
    data['cleft_Refer_DEIC'] = cleftReferDEIC;
    data['cleftLipAndPalate_Note'] = cleftLipAndPalateNote;
    data['talipesClubFoot'] = talipesClubFoot;
    data['talipesTreated'] = talipesTreated;
    data['talipseRefer'] = talipseRefer;
    data['talipseRefer_SKNagpur'] = talipseReferSKNagpur;
    data['talipse_Refer_RH'] = talipseReferRH;
    data['talipse_Refer_SDH'] = talipseReferSDH;
    data['talipse_Refer_DH'] = talipseReferDH;
    data['talipse_Refer_GMC'] = talipseReferGMC;
    data['talipse_Refer_IGMC'] = talipseReferIGMC;
    data['talipse_Refer_MJMJYAndMOUY'] = talipseReferMJMJYAndMOUY;
    data['talipse_Refer_DEIC'] = talipseReferDEIC;
    data['talipesClubFoot_Note'] = talipesClubFootNote;
    data['dvelopmentalDysplasiaOfHip'] = dvelopmentalDysplasiaOfHip;
    data['hipTreated'] = hipTreated;
    data['hipRefer'] = hipRefer;
    data['hipRefer_SKNagpur'] = hipReferSKNagpur;
    data['hip_Refer_RH'] = hipReferRH;
    data['hip_Refer_SDH'] = hipReferSDH;
    data['hip_Refer_DH'] = hipReferDH;
    data['hip_Refer_GMC'] = hipReferGMC;
    data['hip_Refer_IGMC'] = hipReferIGMC;
    data['hip_Refer_MJMJYAndMOUY'] = hipReferMJMJYAndMOUY;
    data['hip_Refer_DEIC'] = hipReferDEIC;
    data['dvelopmentalDysplasiaOfHip_Note'] = dvelopmentalDysplasiaOfHipNote;
    data['congenitalCatract'] = congenitalCatract;
    data['congenitalTarget'] = congenitalTarget;
    data['congenitalRefer'] = congenitalRefer;
    data['congenitalRefer_SKNagpur'] = congenitalReferSKNagpur;
    data['co_Refer_RH'] = coReferRH;
    data['co_Refer_SDH'] = coReferSDH;
    data['co_Refer_DH'] = coReferDH;
    data['co_Refer_GMC'] = coReferGMC;
    data['co_Refer_IGMC'] = coReferIGMC;
    data['co_Refer_MJMJYAndMOUY'] = coReferMJMJYAndMOUY;
    data['co_Refer_DEIC'] = coReferDEIC;
    data['congenitalCatract_Note'] = congenitalCatractNote;
    data['congenitalDeafness'] = congenitalDeafness;
    data['deafnessTarget'] = deafnessTarget;
    data['deafnessRefer'] = deafnessRefer;
    data['deafnessRefer_SKNagpur'] = deafnessReferSKNagpur;
    data['cd_Refer_RH'] = cdReferRH;
    data['cd_Refer_SDH'] = cdReferSDH;
    data['cd_Refer_DH'] = cdReferDH;
    data['cd_Refer_GMC'] = cdReferGMC;
    data['cd_Refer_IGMC'] = cdReferIGMC;
    data['cd_Refer_MJMJYAndMOUY'] = cdReferMJMJYAndMOUY;
    data['cd_Refer_DEIC'] = cdReferDEIC;
    data['congenitalDeafness_Note'] = congenitalDeafnessNote;
    data['congentialHeartDisease'] = congentialHeartDisease;
    data['heartDiseaseTarget'] = heartDiseaseTarget;
    data['heartDiseaseRefer'] = heartDiseaseRefer;
    data['heartDiseaseRefer_SKNagpur'] = heartDiseaseReferSKNagpur;
    data['hd_Refer_RH'] = hdReferRH;
    data['hd_Refer_SDH'] = hdReferSDH;
    data['hd_Refer_DH'] = hdReferDH;
    data['hd_Refer_GMC'] = hdReferGMC;
    data['hd_Refer_IGMC'] = hdReferIGMC;
    data['hd_Refer_MJMJYAndMOUY'] = hdReferMJMJYAndMOUY;
    data['hd_Refer_DEIC'] = hdReferDEIC;
    data['congentialHeartDisease_Note'] = congentialHeartDiseaseNote;
    data['retinopathyOfPrematurity'] = retinopathyOfPrematurity;
    data['retinopathyTreated'] = retinopathyTreated;
    data['retinopathyRefer'] = retinopathyRefer;
    data['retinopathyRefer_SKNagpur'] = retinopathyReferSKNagpur;
    data['rp_Refer_RH'] = rpReferRH;
    data['rp_Refer_SDH'] = rpReferSDH;
    data['rp_Refer_DH'] = rpReferDH;
    data['rp_Refer_GMC'] = rpReferGMC;
    data['rp_Refer_IGMC'] = rpReferIGMC;
    data['rp_Refer_MJMJYAndMOUY'] = rpReferMJMJYAndMOUY;
    data['rp_Refer_DEIC'] = rpReferDEIC;
    data['retinopathyOfPrematurity_Note'] = retinopathyOfPrematurityNote;
    data['other'] = other;
    data['otherTreated'] = otherTreated;
    data['otherRefer'] = otherRefer;
    data['otherRefer_SKNagpur'] = otherReferSKNagpur;
    data['other_Refer_RH'] = otherReferRH;
    data['other_Refer_SDH'] = otherReferSDH;
    data['other_Refer_DH'] = otherReferDH;
    data['other_Refer_GMC'] = otherReferGMC;
    data['other_Refer_IGMC'] = otherReferIGMC;
    data['other_Refer_MJMJYAndMOUY'] = otherReferMJMJYAndMOUY;
    data['other_Refer_DEIC'] = otherReferDEIC;
    data['other_Note'] = otherNote;
    data['deficiencesAtBirth'] = deficiencesAtBirth;
    data['anemia'] = anemia;
    data['anemiaTreated'] = anemiaTreated;
    data['anemiaRefer'] = anemiaRefer;
    data['anemiaRefer_SKNagpur'] = anemiaReferSKNagpur;
    data['anemia_Refer_RH'] = anemiaReferRH;
    data['anemia_Refer_SDH'] = anemiaReferSDH;
    data['anemia_Refer_DH'] = anemiaReferDH;
    data['anemia_Refer_GMC'] = anemiaReferGMC;
    data['anemia_Refer_IGMC'] = anemiaReferIGMC;
    data['anemia_Refer_MJMJYAndMOUY'] = anemiaReferMJMJYAndMOUY;
    data['anemia_Refer_DEIC'] = anemiaReferDEIC;
    data['anemia_Note'] = anemiaNote;
    data['vitaminADef'] = vitaminADef;
    data['vitaminATreated'] = vitaminATreated;
    data['vitaminARefer'] = vitaminARefer;
    data['vitaminARefer_SKNagpur'] = vitaminAReferSKNagpur;
    data['vA_Refer_RH'] = vAReferRH;
    data['vA_Refer_SDH'] = vAReferSDH;
    data['vA_Refer_DH'] = vAReferDH;
    data['vA_Refer_GMC'] = vAReferGMC;
    data['vA_Refer_IGMC'] = vAReferIGMC;
    data['vA_Refer_MJMJYAndMOUY'] = vAReferMJMJYAndMOUY;
    data['vA_Refer_DEIC'] = vAReferDEIC;
    data['vitaminADef_Note'] = vitaminADefNote;
    data['vitaminDDef'] = vitaminDDef;
    data['vitaminDTreated'] = vitaminDTreated;
    data['vitaminDRefer'] = vitaminDRefer;
    data['vitaminDRefer_SKNagpur'] = vitaminDReferSKNagpur;
    data['vD_Refer_RH'] = vDReferRH;
    data['vD_Refer_SDH'] = vDReferSDH;
    data['vD_Refer_DH'] = vDReferDH;
    data['vD_Refer_GMC'] = vDReferGMC;
    data['vD_Refer_IGMC'] = vDReferIGMC;
    data['vD_Refer_MJMJYAndMOUY'] = vDReferMJMJYAndMOUY;
    data['vD_Refer_DEIC'] = vDReferDEIC;
    data['vitaminDDef_Note'] = vitaminDDefNote;
    data['saM_Stunting'] = saMStunting;
    data['samTreated'] = samTreated;
    data['samRefer'] = samRefer;
    data['samRefer_SKNagpur'] = samReferSKNagpur;
    data['sam_Refer_RH'] = samReferRH;
    data['sam_Refer_SDH'] = samReferSDH;
    data['sam_Refer_DH'] = samReferDH;
    data['sam_Refer_GMC'] = samReferGMC;
    data['sam_Refer_IGMC'] = samReferIGMC;
    data['sam_Refer_MJMJYAndMOUY'] = samReferMJMJYAndMOUY;
    data['sam_Refer_DEIC'] = samReferDEIC;
    data['saM_Stunting_Note'] = saMStuntingNote;
    data['goiter'] = goiter;
    data['goiterTreated'] = goiterTreated;
    data['goiterRefer'] = goiterRefer;
    data['goiterRefer_SKNagpur'] = goiterReferSKNagpur;
    data['g_Refer_RH'] = gReferRH;
    data['g_Refer_SDH'] = gReferSDH;
    data['g_Refer_DH'] = gReferDH;
    data['g_Refer_GMC'] = gReferGMC;
    data['g_Refer_IGMC'] = gReferIGMC;
    data['g_Refer_MJMJYAndMOUY'] = gReferMJMJYAndMOUY;
    data['g_Refer_DEIC'] = gReferDEIC;
    data['goiter_Note'] = goiterNote;
    data['vitaminBcomplexDef'] = vitaminBcomplexDef;
    data['vitaminBTreated'] = vitaminBTreated;
    data['vitaminBRefer'] = vitaminBRefer;
    data['vitaminBRefer_SKNagpur'] = vitaminBReferSKNagpur;
    data['vB_Refer_RH'] = vBReferRH;
    data['vB_Refer_SDH'] = vBReferSDH;
    data['vB_Refer_DH'] = vBReferDH;
    data['vB_Refer_GMC'] = vBReferGMC;
    data['vB_Refer_IGMC'] = vBReferIGMC;
    data['vB_Refer_MJMJYAndMOUY'] = vBReferMJMJYAndMOUY;
    data['vB_Refer_DEIC'] = vBReferDEIC;
    data['vitaminBcomplexDef_Note'] = vitaminBcomplexDefNote;
    data['othersSpecify'] = othersSpecify;
    data['othersTreated'] = othersTreated;
    data['othersRefer'] = othersRefer;
    data['othersRefer_SKNagpur'] = othersReferSKNagpur;
    data['ot_Refer_RH'] = otReferRH;
    data['ot_Refer_SDH'] = otReferSDH;
    data['ot_Refer_DH'] = otReferDH;
    data['ot_Refer_GMC'] = otReferGMC;
    data['ot_Refer_IGMC'] = otReferIGMC;
    data['ot_Refer_MJMJYAndMOUY'] = otReferMJMJYAndMOUY;
    data['ot_Refer_DEIC'] = otReferDEIC;
    data['othersSpecify_Note'] = othersSpecifyNote;
    data['diseases'] = diseases;
    data['skinConditionsNotLeprosy'] = skinConditionsNotLeprosy;
    data['skinTrated'] = skinTrated;
    data['skinRefer'] = skinRefer;
    data['skinRefer_SKNagpur'] = skinReferSKNagpur;
    data['sk_Refer_RH'] = skReferRH;
    data['sk_Refer_SDH'] = skReferSDH;
    data['sk_Refer_DH'] = skReferDH;
    data['sk_Refer_GMC'] = skReferGMC;
    data['sk_Refer_IGMC'] = skReferIGMC;
    data['sk_Refer_MJMJYAndMOUY'] = skReferMJMJYAndMOUY;
    data['sk_Refer_DEIC'] = skReferDEIC;
    data['skinConditionsNotLeprosy_Note'] = skinConditionsNotLeprosyNote;
    data['otitisMedia'] = otitisMedia;
    data['otitisMediaTreated'] = otitisMediaTreated;
    data['otitisMediaRefer'] = otitisMediaRefer;
    data['otitisMediaRefer_SKNagpur'] = otitisMediaReferSKNagpur;
    data['otm_Refer_RH'] = otmReferRH;
    data['otm_Refer_SDH'] = otmReferSDH;
    data['otm_Refer_DH'] = otmReferDH;
    data['otm_Refer_GMC'] = otmReferGMC;
    data['otm_Refer_IGMC'] = otmReferIGMC;
    data['otm_Refer_MJMJYAndMOUY'] = otmReferMJMJYAndMOUY;
    data['otm_Refer_DEIC'] = otmReferDEIC;
    data['otitisMedia_Note'] = otitisMediaNote;
    data['rehumaticHeartDisease'] = rehumaticHeartDisease;
    data['rehumaticTrated'] = rehumaticTrated;
    data['rehumaticRefer'] = rehumaticRefer;
    data['rehumaticRefer_SKNagpur'] = rehumaticReferSKNagpur;
    data['re_Refer_RH'] = reReferRH;
    data['re_Refer_SDH'] = reReferSDH;
    data['re_Refer_DH'] = reReferDH;
    data['re_Refer_GMC'] = reReferGMC;
    data['re_Refer_IGMC'] = reReferIGMC;
    data['re_Refer_MJMJYAndMOUY'] = reReferMJMJYAndMOUY;
    data['re_Refer_DEIC'] = reReferDEIC;
    data['rehumaticHeartDisease_Note'] = rehumaticHeartDiseaseNote;
    data['reactiveAirwayDisease'] = reactiveAirwayDisease;
    data['reactiveTreated'] = reactiveTreated;
    data['reactiveRefer'] = reactiveRefer;
    data['reactiveRefer_SKNagpur'] = reactiveReferSKNagpur;
    data['ra_Refer_RH'] = raReferRH;
    data['ra_Refer_SDH'] = raReferSDH;
    data['ra_Refer_DH'] = raReferDH;
    data['ra_Refer_GMC'] = raReferGMC;
    data['ra_Refer_IGMC'] = raReferIGMC;
    data['ra_Refer_MJMJYAndMOUY'] = raReferMJMJYAndMOUY;
    data['ra_Refer_DEIC'] = raReferDEIC;
    data['reactiveAirwayDisease_Note'] = reactiveAirwayDiseaseNote;
    data['dentalConditions'] = dentalConditions;
    data['dentalTrated'] = dentalTrated;
    data['dentalRefer'] = dentalRefer;
    data['dentalRefer_SKNagpur'] = dentalReferSKNagpur;
    data['de_Refer_RH'] = deReferRH;
    data['de_Refer_SDH'] = deReferSDH;
    data['de_Refer_DH'] = deReferDH;
    data['de_Refer_GMC'] = deReferGMC;
    data['de_Refer_IGMC'] = deReferIGMC;
    data['de_Refer_MJMJYAndMOUY'] = deReferMJMJYAndMOUY;
    data['de_Refer_DEIC'] = deReferDEIC;
    data['dentalConditions_Note'] = dentalConditionsNote;
    data['childhoodLeprosyDisease'] = childhoodLeprosyDisease;
    data['childhoodTreated'] = childhoodTreated;
    data['childhoodRefer'] = childhoodRefer;
    data['childhoodRefer_SKNagpur'] = childhoodReferSKNagpur;
    data['ch_Refer_RH'] = chReferRH;
    data['ch_Refer_SDH'] = chReferSDH;
    data['ch_Refer_DH'] = chReferDH;
    data['ch_Refer_GMC'] = chReferGMC;
    data['ch_Refer_IGMC'] = chReferIGMC;
    data['ch_Refer_MJMJYAndMOUY'] = chReferMJMJYAndMOUY;
    data['ch_Refer_DEIC'] = chReferDEIC;
    data['childhoodLeprosyDisease_Note'] = childhoodLeprosyDiseaseNote;
    data['childhoodTuberculosis'] = childhoodTuberculosis;
    data['cTuberculosisTreated'] = cTuberculosisTreated;
    data['cTuberculosisRefer'] = cTuberculosisRefer;
    data['cTuberculosisRefer_SKNagpur'] = cTuberculosisReferSKNagpur;
    data['cTu_Refer_RH'] = cTuReferRH;
    data['cTu_Refer_SDH'] = cTuReferSDH;
    data['cTu_Refer_DH'] = cTuReferDH;
    data['cTu_Refer_GMC'] = cTuReferGMC;
    data['cTu_Refer_IGMC'] = cTuReferIGMC;
    data['cTu_Refer_MJMJYAndMOUY'] = cTuReferMJMJYAndMOUY;
    data['cTu_Refer_DEIC'] = cTuReferDEIC;
    data['childhoodTuberculosis_Note'] = childhoodTuberculosisNote;
    data['childhoodTuberculosisExtraPulmonary'] =
        childhoodTuberculosisExtraPulmonary;
    data['cTuExtraTreated'] = cTuExtraTreated;
    data['cTuExtraRefer'] = cTuExtraRefer;
    data['cTuExtraRefer_SKNagpur'] = cTuExtraReferSKNagpur;
    data['cTuExtra_Refer_RH'] = cTuExtraReferRH;
    data['cTuExtra_Refer_SDH'] = cTuExtraReferSDH;
    data['cTuExtra_Refer_DH'] = cTuExtraReferDH;
    data['cTuExtra_Refer_GMC'] = cTuExtraReferGMC;
    data['cTuExtra_Refer_IGMC'] = cTuExtraReferIGMC;
    data['cTuExtra_Refer_MJMJYAndMOUY'] = cTuExtraReferMJMJYAndMOUY;
    data['cTuExtra_Refer_DEIC'] = cTuExtraReferDEIC;
    data['childhoodTuberculosisExtraPulmonary_Note'] =
        childhoodTuberculosisExtraPulmonaryNote;
    data['other_disease'] = otherdisease;
    data['other_diseaseTreated'] = otherdiseaseTreated;
    data['other_diseaseRefer'] = otherdiseaseRefer;
    data['other_diseaseRefer_SKNagpur'] = otherdiseaseReferSKNagpur;
    data['other_diseaseRefer_RH'] = otherdiseaseReferRH;
    data['other_diseaseRefer_SDH'] = otherdiseaseReferSDH;
    data['other_diseaseRefer_DH'] = otherdiseaseReferDH;
    data['other_diseaseRefer_GMC'] = otherdiseaseReferGMC;
    data['other_diseaseRefer_IGMC'] = otherdiseaseReferIGMC;
    data['other_diseaseMJMJYAndMOUY'] = otherdiseaseMJMJYAndMOUY;
    data['other_diseaseRefer_DEIC'] = otherdiseaseReferDEIC;
    data['other_disease_Note'] = otherdiseaseNote;
    data['developmentalDelayIncludingDisability'] =
        developmentalDelayIncludingDisability;
    data['visionImpairment'] = visionImpairment;
    data['visionTreated'] = visionTreated;
    data['visionRefer'] = visionRefer;
    data['visionRefer_SKNagpur'] = visionReferSKNagpur;
    data['vision_Refer_RH'] = visionReferRH;
    data['vision_Refer_SDH'] = visionReferSDH;
    data['vision_Refer_DH'] = visionReferDH;
    data['vision_Refer_GMC'] = visionReferGMC;
    data['vision_Refer_IGMC'] = visionReferIGMC;
    data['vision_Refer_MJMJYAndMOUY'] = visionReferMJMJYAndMOUY;
    data['vision_Refer_DEIC'] = visionReferDEIC;
    data['visionImpairment_Note'] = visionImpairmentNote;
    data['hearingImpairment'] = hearingImpairment;
    data['hearingTreated'] = hearingTreated;
    data['hearingRefer'] = hearingRefer;
    data['hearingRefer_SKNagpur'] = hearingReferSKNagpur;
    data['hearing_Refer_RH'] = hearingReferRH;
    data['hearing_Refer_SDH'] = hearingReferSDH;
    data['hearing_Refer_DH'] = hearingReferDH;
    data['hearing_Refer_GMC'] = hearingReferGMC;
    data['hearing_Refer_IGMC'] = hearingReferIGMC;
    data['hearing_Refer_MJMJYAndMOUY'] = hearingReferMJMJYAndMOUY;
    data['hearing_Refer_DEIC'] = hearingReferDEIC;
    data['hearingImpairment_Note'] = hearingImpairmentNote;
    data['neuromotorImpairment'] = neuromotorImpairment;
    data['neuromotorTreated'] = neuromotorTreated;
    data['neuromotorRefer'] = neuromotorRefer;
    data['neuromotorRefer_SKNagpur'] = neuromotorReferSKNagpur;
    data['neuro_Refer_RH'] = neuroReferRH;
    data['neuro_Refer_SDH'] = neuroReferSDH;
    data['neuro_Refer_DH'] = neuroReferDH;
    data['neuro_Refer_GMC'] = neuroReferGMC;
    data['neuro_Refer_IGMC'] = neuroReferIGMC;
    data['neuro_Refer_MJMJYAndMOUY'] = neuroReferMJMJYAndMOUY;
    data['neuro_Refer_DEIC'] = neuroReferDEIC;
    data['neuromotorImpairment_Note'] = neuromotorImpairmentNote;
    data['motorDelay'] = motorDelay;
    data['motorDealyTrated'] = motorDealyTrated;
    data['motorDelayRefer'] = motorDelayRefer;
    data['motorDelayRefer_SKNagpur'] = motorDelayReferSKNagpur;
    data['motor_Refer_RH'] = motorReferRH;
    data['motor_Refer_SDH'] = motorReferSDH;
    data['motor_Refer_DH'] = motorReferDH;
    data['motor_Refer_GMC'] = motorReferGMC;
    data['motor_Refer_IGMC'] = motorReferIGMC;
    data['motor_Refer_MJMJYAndMOUY'] = motorReferMJMJYAndMOUY;
    data['motor_Refer_DEIC'] = motorReferDEIC;
    data['motorDelay_Note'] = motorDelayNote;
    data['cognitiveDelay'] = cognitiveDelay;
    data['cognitiveTrated'] = cognitiveTrated;
    data['cognitiveRefer'] = cognitiveRefer;
    data['cognitiveRefer_SKNagpur'] = cognitiveReferSKNagpur;
    data['cognitive_Refer_RH'] = cognitiveReferRH;
    data['cognitive_Refer_SDH'] = cognitiveReferSDH;
    data['cognitive_Refer_DH'] = cognitiveReferDH;
    data['cognitive_Refer_GMC'] = cognitiveReferGMC;
    data['cognitive_Refer_IGMC'] = cognitiveReferIGMC;
    data['cognitive_Refer_MJMJYAndMOUY'] = cognitiveReferMJMJYAndMOUY;
    data['cognitive_Refer_DEIC'] = cognitiveReferDEIC;
    data['cognitiveDelay_Note'] = cognitiveDelayNote;
    data['speechAndLanguageDelay'] = speechAndLanguageDelay;
    data['speechTreated'] = speechTreated;
    data['speechRefer'] = speechRefer;
    data['speechRefer_SKNagpur'] = speechReferSKNagpur;
    data['speech_Refer_RH'] = speechReferRH;
    data['speech_Refer_SDH'] = speechReferSDH;
    data['speech_Refer_DH'] = speechReferDH;
    data['speech_Refer_GMC'] = speechReferGMC;
    data['speech_Refer_IGMC'] = speechReferIGMC;
    data['speech_Refer_MJMJYAndMOUY'] = speechReferMJMJYAndMOUY;
    data['speech_Refer_DEIC'] = speechReferDEIC;
    data['speechAndLanguageDelay_Note'] = speechAndLanguageDelayNote;
    data['behaviouralDisorder'] = behaviouralDisorder;
    data['behaviouralTreated'] = behaviouralTreated;
    data['behavoiuralRefer'] = behavoiuralRefer;
    data['behavoiuralRefer_SKNagpur'] = behavoiuralReferSKNagpur;
    data['behavoiural_Refer_RH'] = behavoiuralReferRH;
    data['behavoiural_Refer_SDH'] = behavoiuralReferSDH;
    data['behavoiural_Refer_DH'] = behavoiuralReferDH;
    data['behavoiural_Refer_GMC'] = behavoiuralReferGMC;
    data['behavoiural_Refer_IGMC'] = behavoiuralReferIGMC;
    data['behavoiural_Refer_MJMJYAndMOUY'] = behavoiuralReferMJMJYAndMOUY;
    data['behavoiural_Refer_DEIC'] = behavoiuralReferDEIC;
    data['behaviouralDisorder_Note'] = behaviouralDisorderNote;
    data['learningDisorder'] = learningDisorder;
    data['learningTreated'] = learningTreated;
    data['learningRefer'] = learningRefer;
    data['learningRefer_SKNagpur'] = learningReferSKNagpur;
    data['learning_Refer_RH'] = learningReferRH;
    data['learning_Refer_SDH'] = learningReferSDH;
    data['learning_Refer_DH'] = learningReferDH;
    data['learning_Refer_GMC'] = learningReferGMC;
    data['learning_Refer_IGMC'] = learningReferIGMC;
    data['learning_Refer_MJMJYAndMOUY'] = learningReferMJMJYAndMOUY;
    data['learning_Refer_DEIC'] = learningReferDEIC;
    data['learningDisorder_Note'] = learningDisorderNote;
    data['attentionDeficitHyperactivityDisorder'] =
        attentionDeficitHyperactivityDisorder;
    data['attentionTreated'] = attentionTreated;
    data['attentionRefer'] = attentionRefer;
    data['attentionRefer_SKNagpur'] = attentionReferSKNagpur;
    data['attention_Refer_RH'] = attentionReferRH;
    data['attention_Refer_SDH'] = attentionReferSDH;
    data['attention_Refer_DH'] = attentionReferDH;
    data['attention_Refer_GMC'] = attentionReferGMC;
    data['attention_Refer_IGMC'] = attentionReferIGMC;
    data['attention_Refer_MJMJYAndMOUY'] = attentionReferMJMJYAndMOUY;
    data['attention_Refer_DEIC'] = attentionReferDEIC;
    data['attentionDeficitHyperactivityDisorder_Note'] =
        attentionDeficitHyperactivityDisorderNote;
    data['other_ddid'] = otherddid;
    data['other_ddidTreated'] = otherddidTreated;
    data['other_ddidRefer'] = otherddidRefer;
    data['other_ddidRefer_SKNagpur'] = otherddidReferSKNagpur;
    data['other_ddidRefer_RH'] = otherddidReferRH;
    data['other_ddidRefer_SDH'] = otherddidReferSDH;
    data['other_ddidRefer_DH'] = otherddidReferDH;
    data['other_ddidRefer_GMC'] = otherddidReferGMC;
    data['other_ddidRefer_IGMC'] = otherddidReferIGMC;
    data['other_ddidMJMJYAndMOUY'] = otherddidMJMJYAndMOUY;
    data['other_ddidRefer_DEIC'] = otherddidReferDEIC;
    data['other_ddid_Note'] = otherddidNote;
    data['adolescentSpecificQuestionnare'] = adolescentSpecificQuestionnare;
    data['growingUpConcerns'] = growingUpConcerns;
    data['growingTreated'] = growingTreated;
    data['growingRefer'] = growingRefer;
    data['growingRefer_SKNagpur'] = growingReferSKNagpur;
    data['growing_Refer_RH'] = growingReferRH;
    data['growing_Refer_SDH'] = growingReferSDH;
    data['growing_Refer_DH'] = growingReferDH;
    data['growing_Refer_GMC'] = growingReferGMC;
    data['growing_Refer_IGMC'] = growingReferIGMC;
    data['growing_Refer_MJMJYAndMOUY'] = growingReferMJMJYAndMOUY;
    data['growing_Refer_DEIC'] = growingReferDEIC;
    data['growingUpConcerns_Note'] = growingUpConcernsNote;
    data['substanceAbuse'] = substanceAbuse;
    data['substanceTreated'] = substanceTreated;
    data['substanceRefer'] = substanceRefer;
    data['substanceRefer_SKNagpur'] = substanceReferSKNagpur;
    data['substance_Refer_RH'] = substanceReferRH;
    data['substance_Refer_SDH'] = substanceReferSDH;
    data['substance_Refer_DH'] = substanceReferDH;
    data['substance_Refer_GMC'] = substanceReferGMC;
    data['substance_Refer_IGMC'] = substanceReferIGMC;
    data['substance_Refer_MJMJYAndMOUY'] = substanceReferMJMJYAndMOUY;
    data['substance_Refer_DEIC'] = substanceReferDEIC;
    data['substanceAbuse_Note'] = substanceAbuseNote;
    data['feelDepressed'] = feelDepressed;
    data['feelTreated'] = feelTreated;
    data['feelRefer'] = feelRefer;
    data['feelRefer_SKNagpur'] = feelReferSKNagpur;
    data['feel_Refer_RH'] = feelReferRH;
    data['feel_Refer_SDH'] = feelReferSDH;
    data['feel_Refer_DH'] = feelReferDH;
    data['feel_Refer_GMC'] = feelReferGMC;
    data['feel_Refer_IGMC'] = feelReferIGMC;
    data['feel_Refer_MJMJYAndMOUY'] = feelReferMJMJYAndMOUY;
    data['feel_Refer_DEIC'] = feelReferDEIC;
    data['feelDepressed_Note'] = feelDepressedNote;
    data['delayInMenstrualCycles'] = delayInMenstrualCycles;
    data['delayTreated'] = delayTreated;
    data['delayRefer'] = delayRefer;
    data['delayRefer_SKNagpur'] = delayReferSKNagpur;
    data['delay_Refer_RH'] = delayReferRH;
    data['delay_Refer_SDH'] = delayReferSDH;
    data['delay_Refer_DH'] = delayReferDH;
    data['delay_Refer_GMC'] = delayReferGMC;
    data['delay_Refer_IGMC'] = delayReferIGMC;
    data['delay_Refer_MJMJYAndMOUY'] = delayReferMJMJYAndMOUY;
    data['delay_Refer_DEIC'] = delayReferDEIC;
    data['delayInMenstrualCycles_Note'] = delayInMenstrualCyclesNote;
    data['irregularPeriods'] = irregularPeriods;
    data['irregularTreated'] = irregularTreated;
    data['irregularRefer'] = irregularRefer;
    data['irregularRefer_SKNagpur'] = irregularReferSKNagpur;
    data['irregular_Refer_RH'] = irregularReferRH;
    data['irregular_Refer_SDH'] = irregularReferSDH;
    data['irregular_Refer_DH'] = irregularReferDH;
    data['irregular_Refer_GMC'] = irregularReferGMC;
    data['irregular_Refer_IGMC'] = irregularReferIGMC;
    data['irregular_Refer_MJMJYAndMOUY'] = irregularReferMJMJYAndMOUY;
    data['irregular_Refer_DEIC'] = irregularReferDEIC;
    data['irregularPeriods_Note'] = irregularPeriodsNote;
    data['painOrBurningSensationWhileUrinating'] =
        painOrBurningSensationWhileUrinating;
    data['painOrBurningTreated'] = painOrBurningTreated;
    data['painOrBurningRefer'] = painOrBurningRefer;
    data['painOrBurningRefer_SKNagpur'] = painOrBurningReferSKNagpur;
    data['painOrBurning_Refer_RH'] = painOrBurningReferRH;
    data['painOrBurning_Refer_SDH'] = painOrBurningReferSDH;
    data['painOrBurning_Refer_DH'] = painOrBurningReferDH;
    data['painOrBurning_Refer_GMC'] = painOrBurningReferGMC;
    data['painOrBurning_Refer_IGMC'] = painOrBurningReferIGMC;
    data['painOrBurning_Refer_MJMJYAndMOUY'] = painOrBurningReferMJMJYAndMOUY;
    data['painOrBurning_Refer_DEIC'] = painOrBurningReferDEIC;
    data['painOrBurningSensationWhileUrinating_Note'] =
        painOrBurningSensationWhileUrinatingNote;
    data['discharge'] = discharge;
    data['dischargeTreated'] = dischargeTreated;
    data['dischargeRefer'] = dischargeRefer;
    data['dischargeRefer_SKNagpur'] = dischargeReferSKNagpur;
    data['discharge_Refer_RH'] = dischargeReferRH;
    data['discharge_Refer_SDH'] = dischargeReferSDH;
    data['discharge_Refer_DH'] = dischargeReferDH;
    data['discharge_Refer_GMC'] = dischargeReferGMC;
    data['discharge_Refer_IGMC'] = dischargeReferIGMC;
    data['discharge_Refer_MJMJYAndMOUY'] = dischargeReferMJMJYAndMOUY;
    data['discharge_Refer_DEIC'] = dischargeReferDEIC;
    data['discharge_Note'] = dischargeNote;
    data['painDuringMenstruation'] = painDuringMenstruation;
    data['painDuringTreated'] = painDuringTreated;
    data['painDuringRefer'] = painDuringRefer;
    data['painDuringRefer_SKNagpur'] = painDuringReferSKNagpur;
    data['painDuring_Refer_RH'] = painDuringReferRH;
    data['painDuring_Refer_SDH'] = painDuringReferSDH;
    data['painDuring_Refer_DH'] = painDuringReferDH;
    data['painDuring_Refer_GMC'] = painDuringReferGMC;
    data['painDuring_Refer_IGMC'] = painDuringReferIGMC;
    data['painDuring_Refer_MJMJYAndMOUY'] = painDuringReferMJMJYAndMOUY;
    data['painDuring_Refer_DEIC'] = painDuringReferDEIC;
    data['painDuringMenstruation_Note'] = painDuringMenstruationNote;
    data['other_asq'] = otherasq;
    data['other_asqTreated'] = otherasqTreated;
    data['other_asqRefer'] = otherasqRefer;
    data['other_asqRefer_SKNagpur'] = otherasqReferSKNagpur;
    data['other_asqRefer_RH'] = otherasqReferRH;
    data['other_asqRefer_SDH'] = otherasqReferSDH;
    data['other_asqRefer_DH'] = otherasqReferDH;
    data['other_asqRefer_GMC'] = otherasqReferGMC;
    data['other_asqRefer_IGMC'] = otherasqReferIGMC;
    data['other_asqMJMJYAndMOUY'] = otherasqMJMJYAndMOUY;
    data['other_asqRefer_DEIC'] = otherasqReferDEIC;
    data['other_asq_Note'] = otherasqNote;
    data['disibility'] = disibility;
    data['disibilityTreated'] = disibilityTreated;
    data['disibilityRefer'] = disibilityRefer;
    data['disibilityRefer_SKNagpur'] = disibilityReferSKNagpur;
    data['disibility_RH'] = disibilityRH;
    data['disibility_SDH'] = disibilitySDH;
    data['disibility_DH'] = disibilityDH;
    data['disibility_GMC'] = disibilityGMC;
    data['disibility_IGMC'] = disibilityIGMC;
    data['disibility_MJMJYAndMOUY'] = disibilityMJMJYAndMOUY;
    data['disibility_DEIC'] = disibilityDEIC;
    data['disibility_Note'] = disibilityNote;
    data['doctorName'] = doctorName;
    data['userId'] = userId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
