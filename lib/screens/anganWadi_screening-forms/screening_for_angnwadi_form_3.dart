import 'package:flutter/material.dart';
import 'package:school_test/screens/anganWadi_screening-forms/screening_for_angnwadi_form4.dart';


class ScreeningFormAngnwadiScreenThree extends StatefulWidget {
  final Map<String, dynamic> previousFormData;
  const ScreeningFormAngnwadiScreenThree({
    super.key,
    required this.previousFormData,
  });

  @override
  State<ScreeningFormAngnwadiScreenThree> createState() =>
      _ScreeningFormAngnwadiScreenThreeState();
}

class _ScreeningFormAngnwadiScreenThreeState
    extends State<ScreeningFormAngnwadiScreenThree> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _noteControllers = {};
  bool hasDeficiency = false;

  Map<String, bool> deficiencies = {
    'Anemia': false,
    'Vitamin A Def': false,
    'Vitamin D Def (Rickets)': false,
    'SAM/Stunting': false,
    'Goiter': false,
    'Vitamin B complex def': false,
    'Others': false,
  };

  Map<String, String> deficiencyTreatment = {};
  Map<String, String> referralOptions = {};

  final List<String> referralChoices = [
    'SK Nagpur',
    'RH',
    'SDH',
    'DH',
    'GMC',
    'IGMC',
    'MJMJY & MOUY',
    'DEIC',
  ];

  @override
  void initState() {
    super.initState();
    deficiencies.keys.forEach((deficiency) {
      deficiencyTreatment[deficiency] = '';
      referralOptions[deficiency] = '';
      _noteControllers[deficiency] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _noteControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Screening Form"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '3/7',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'B. Deficiencies at Birth',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('No', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: !hasDeficiency,
                        onChanged: (value) {
                          setState(() {
                            hasDeficiency = !(value ?? false);
                            if (!hasDeficiency) {
                              deficiencies.updateAll((key, value) => false);
                              deficiencyTreatment.updateAll((key, value) => '');
                              referralOptions.updateAll((key, value) => '');
                            }
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text('Yes', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: hasDeficiency,
                        onChanged: (value) {
                          setState(() {
                            hasDeficiency = value ?? false;
                            if (!hasDeficiency) {
                              deficiencies.updateAll((key, value) => false);
                              deficiencyTreatment.updateAll((key, value) => '');
                              referralOptions.updateAll((key, value) => '');
                            }
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
                if (hasDeficiency) ...[
                  const SizedBox(height: 16),
                  ...deficiencies.keys.toList().asMap().entries.map((entry) {
                    int index = entry.key;
                    String deficiency = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1}. ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                deficiency,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: deficiencies[deficiency]!,
                                onChanged: (value) {
                                  setState(() {
                                    deficiencies[deficiency] = value ?? false;
                                    if (!deficiencies[deficiency]!) {
                                      deficiencyTreatment[deficiency] = '';
                                      referralOptions[deficiency] = '';
                                      _noteControllers[deficiency]?.clear();
                                    }
                                  });
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (deficiencies[deficiency]!) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Treated',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value:
                                        deficiencyTreatment[deficiency] ==
                                        'Treated',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          deficiencyTreatment[deficiency] =
                                              'Treated';
                                          referralOptions[deficiency] = '';
                                        } else {
                                          deficiencyTreatment[deficiency] = '';
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  'Refer',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value:
                                        deficiencyTreatment[deficiency] ==
                                        'Refer',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          deficiencyTreatment[deficiency] =
                                              'Refer';
                                          _showReferralOptions(deficiency);
                                        } else {
                                          deficiencyTreatment[deficiency] = '';
                                          referralOptions[deficiency] = '';
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                if (referralOptions[deficiency]!
                                    .isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    referralOptions[deficiency]!,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (deficiencyTreatment[deficiency] == 'Refer' &&
                              referralOptions[deficiency]!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller: _noteControllers[deficiency],
                                decoration: InputDecoration(
                                  labelText: 'Enter Refer Note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                                  ),
                                ),
                                validator: (value) {
                                  if (deficiencyTreatment[deficiency] ==
                                          'Refer' &&
                                      referralOptions[deficiency]!.isNotEmpty &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter refer note';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                          if (deficiencyTreatment[deficiency] == 'Treated') ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller: _noteControllers[deficiency],
                                decoration: InputDecoration(
                                  labelText: 'Enter Treated Note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF2196F3)),
                                  ),
                                ),
                                validator: (value) {
                                  if (deficiencyTreatment[deficiency] ==
                                          'Treated' &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter treated note';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25,),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A5F7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final combinedData = _prepareFormData();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScreeningForAngnwadiClassFormFour(
                                        previousData: combinedData,
                                      ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A5F7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReferralOptions(String deficiency) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Referral Option',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...referralChoices.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        referralOptions[deficiency] = option;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        '${index + 1}. $option',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _prepareFormData() {
  Map<String, dynamic> formData = Map.from(widget.previousFormData);

  formData['deficiencesAtBirth'] = hasDeficiency;

  // Anemia
  formData['anemia'] = deficiencies['Anemia'] ?? false;
  formData['anemiaTreated'] = deficiencyTreatment['Anemia'] == 'Treated';
  formData['anemiaRefer'] = deficiencyTreatment['Anemia'] == 'Refer';
  formData['anemiaRefer_SKNagpur'] = referralOptions['Anemia'] == 'SK Nagpur';
  formData['anemia_Refer_RH'] = referralOptions['Anemia'] == 'RH';
  formData['anemia_Refer_SDH'] = referralOptions['Anemia'] == 'SDH';
  formData['anemia_Refer_DH'] = referralOptions['Anemia'] == 'DH';
  formData['anemia_Refer_GMC'] = referralOptions['Anemia'] == 'GMC';
  formData['anemia_Refer_IGMC'] = referralOptions['Anemia'] == 'IGMC';
  formData['anemia_Refer_MJMJYAndMOUY'] = referralOptions['Anemia'] == 'MJMJY & MOUY';
  formData['anemia_Refer_DEIC'] = referralOptions['Anemia'] == 'DEIC';
  formData['anemia_Note'] = _noteControllers['Anemia']?.text ?? '';

  // Vitamin A Def
  formData['vitaminADef'] = deficiencies['Vitamin A Def'] ?? false;
  formData['vitaminATreated'] = deficiencyTreatment['Vitamin A Def'] == 'Treated';
  formData['vitaminARefer'] = deficiencyTreatment['Vitamin A Def'] == 'Refer';
  formData['vitaminARefer_SKNagpur'] = referralOptions['Vitamin A Def'] == 'SK Nagpur';
  formData['vA_Refer_RH'] = referralOptions['Vitamin A Def'] == 'RH';
  formData['vA_Refer_SDH'] = referralOptions['Vitamin A Def'] == 'SDH';
  formData['vA_Refer_DH'] = referralOptions['Vitamin A Def'] == 'DH';
  formData['vA_Refer_GMC'] = referralOptions['Vitamin A Def'] == 'GMC';
  formData['vA_Refer_IGMC'] = referralOptions['Vitamin A Def'] == 'IGMC';
  formData['vA_Refer_MJMJYAndMOUY'] = referralOptions['Vitamin A Def'] == 'MJMJY & MOUY';
  formData['vA_Refer_DEIC'] = referralOptions['Vitamin A Def'] == 'DEIC';
  formData['vitaminADef_Note'] = _noteControllers['Vitamin A Def']?.text ?? '';

  // Vitamin D Def (Rickets)
  formData['vitaminDDef'] = deficiencies['Vitamin D Def (Rickets)'] ?? false;
  formData['vitaminDTreated'] = deficiencyTreatment['Vitamin D Def (Rickets)'] == 'Treated';
  formData['vitaminDRefer'] = deficiencyTreatment['Vitamin D Def (Rickets)'] == 'Refer';
  formData['vitaminDRefer_SKNagpur'] = referralOptions['Vitamin D Def (Rickets)'] == 'SK Nagpur';
  formData['vD_Refer_RH'] = referralOptions['Vitamin D Def (Rickets)'] == 'RH';
  formData['vD_Refer_SDH'] = referralOptions['Vitamin D Def (Rickets)'] == 'SDH';
  formData['vD_Refer_DH'] = referralOptions['Vitamin D Def (Rickets)'] == 'DH';
  formData['vD_Refer_GMC'] = referralOptions['Vitamin D Def (Rickets)'] == 'GMC';
  formData['vD_Refer_IGMC'] = referralOptions['Vitamin D Def (Rickets)'] == 'IGMC';
  formData['vD_Refer_MJMJYAndMOUY'] = referralOptions['Vitamin D Def (Rickets)'] == 'MJMJY & MOUY';
  formData['vD_Refer_DEIC'] = referralOptions['Vitamin D Def (Rickets)'] == 'DEIC';
  formData['vitaminDDef_Note'] = _noteControllers['Vitamin D Def (Rickets)']?.text ?? '';

  // SAM/Stunting
  formData['saM_Stunting'] = deficiencies['SAM/Stunting'] ?? false;
  formData['samTreated'] = deficiencyTreatment['SAM/Stunting'] == 'Treated';
  formData['samRefer'] = deficiencyTreatment['SAM/Stunting'] == 'Refer';
  formData['samRefer_SKNagpur'] = referralOptions['SAM/Stunting'] == 'SK Nagpur';
  formData['sam_Refer_RH'] = referralOptions['SAM/Stunting'] == 'RH';
  formData['sam_Refer_SDH'] = referralOptions['SAM/Stunting'] == 'SDH';
  formData['sam_Refer_DH'] = referralOptions['SAM/Stunting'] == 'DH';
  formData['sam_Refer_GMC'] = referralOptions['SAM/Stunting'] == 'GMC';
  formData['sam_Refer_IGMC'] = referralOptions['SAM/Stunting'] == 'IGMC';
  formData['sam_Refer_MJMJYAndMOUY'] = referralOptions['SAM/Stunting'] == 'MJMJY & MOUY';
  formData['sam_Refer_DEIC'] = referralOptions['SAM/Stunting'] == 'DEIC';
  formData['saM_Stunting_Note'] = _noteControllers['SAM/Stunting']?.text ?? '';

  // Goiter
  formData['goiter'] = deficiencies['Goiter'] ?? false;
  formData['goiterTreated'] = deficiencyTreatment['Goiter'] == 'Treated';
  formData['goiterRefer'] = deficiencyTreatment['Goiter'] == 'Refer';
  formData['goiterRefer_SKNagpur'] = referralOptions['Goiter'] == 'SK Nagpur';
  formData['g_Refer_RH'] = referralOptions['Goiter'] == 'RH';
  formData['g_Refer_SDH'] = referralOptions['Goiter'] == 'SDH';
  formData['g_Refer_DH'] = referralOptions['Goiter'] == 'DH';
  formData['g_Refer_GMC'] = referralOptions['Goiter'] == 'GMC';
  formData['g_Refer_IGMC'] = referralOptions['Goiter'] == 'IGMC';
  formData['g_Refer_MJMJYAndMOUY'] = referralOptions['Goiter'] == 'MJMJY & MOUY';
  formData['g_Refer_DEIC'] = referralOptions['Goiter'] == 'DEIC';
  formData['goiter_Note'] = _noteControllers['Goiter']?.text ?? '';

  // Vitamin B complex def
  formData['vitaminBcomplexDef'] = deficiencies['Vitamin B complex def'] ?? false;
  formData['vitaminBTreated'] = deficiencyTreatment['Vitamin B complex def'] == 'Treated';
  formData['vitaminBRefer'] = deficiencyTreatment['Vitamin B complex def'] == 'Refer';
  formData['vitaminBRefer_SKNagpur'] = referralOptions['Vitamin B complex def'] == 'SK Nagpur';
  formData['vB_Refer_RH'] = referralOptions['Vitamin B complex def'] == 'RH';
  formData['vB_Refer_SDH'] = referralOptions['Vitamin B complex def'] == 'SDH';
  formData['vB_Refer_DH'] = referralOptions['Vitamin B complex def'] == 'DH';
  formData['vB_Refer_GMC'] = referralOptions['Vitamin B complex def'] == 'GMC';
  formData['vB_Refer_IGMC'] = referralOptions['Vitamin B complex def'] == 'IGMC';
  formData['vB_Refer_MJMJYAndMOUY'] = referralOptions['Vitamin B complex def'] == 'MJMJY & MOUY';
  formData['vB_Refer_DEIC'] = referralOptions['Vitamin B complex def'] == 'DEIC';
  formData['vitaminBcomplexDef_Note'] = _noteControllers['Vitamin B complex def']?.text ?? '';

  // Others
  formData['othersSpecify'] = deficiencies['Others'] ?? false;
  formData['othersTreated'] = deficiencyTreatment['Others'] == 'Treated';
  formData['othersRefer'] = deficiencyTreatment['Others'] == 'Refer';
  formData['othersRefer_SKNagpur'] = referralOptions['Others'] == 'SK Nagpur';
  formData['ot_Refer_RH'] = referralOptions['Others'] == 'RH';
  formData['ot_Refer_SDH'] = referralOptions['Others'] == 'SDH';
  formData['ot_Refer_DH'] = referralOptions['Others'] == 'DH';
  formData['ot_Refer_GMC'] = referralOptions['Others'] == 'GMC';
  formData['ot_Refer_IGMC'] = referralOptions['Others'] == 'IGMC';
  formData['ot_Refer_MJMJYAndMOUY'] = referralOptions['Others'] == 'MJMJY & MOUY';
  formData['ot_Refer_DEIC'] = referralOptions['Others'] == 'DEIC';
  formData['othersSpecify_Note'] = _noteControllers['Others']?.text ?? '';

  return formData;
}
}
