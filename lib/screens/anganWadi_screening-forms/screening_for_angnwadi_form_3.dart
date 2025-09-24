import 'package:flutter/material.dart';
import 'package:school_test/screens/anganWadi_screening-forms/screening_for_angnwadi_form4.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form4.dart';

class ScreeningFormAngnwadiScreenThree extends StatefulWidget {
  const ScreeningFormAngnwadiScreenThree({super.key});

  @override
  State<ScreeningFormAngnwadiScreenThree> createState() => _ScreeningFormAngnwadiScreenThreeState();
}

class _ScreeningFormAngnwadiScreenThreeState extends State<ScreeningFormAngnwadiScreenThree> {
  bool hasDeficiency = false;

  final List<String> deficiencyList = [
    'Anemia',
    'Vitamin A Def',
    'Vitamin D Def (Rickets)',
    'SAM/Stunting',
    'Goiter',
    'Vitamin B complex def',
    'Others',
  ];

  // Store selection state
  Map<String, bool> selectedDeficiencies = {};
  Map<String, String?> actionType = {}; // "Treated" or "Referred"
  Map<String, String?> treatedNotes = {};
  Map<String, String?> referredTo = {};

  final List<String> referralOptions = [
    'RH',
    'SDH',
    'DH',
    'GMC',
    'IGMC',
    'MJMJY & MOUY',
    'DEIC',
    'Samaj Kalyan Nagpur'
  ];

  @override
  void initState() {
    super.initState();
    for (var d in deficiencyList) {
      selectedDeficiencies[d] = false;
      actionType[d] = null;
      treatedNotes[d] = null;
      referredTo[d] = null;
    }
  }

  Future<String?> _showActionDialog() async {
    String? selectedOption;

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // force user to pick
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Action"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text("Treated"),
                    value: "Treated",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Refer"),
                    value: "Refer",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() => selectedOption = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedOption == null
                      ? null
                      : () => Navigator.pop(context, selectedOption),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showReferralDialog() async {
    String? selectedReferral;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Referral"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: referralOptions.length,
                  itemBuilder: (ctx, index) {
                    final option = referralOptions[index];
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedReferral,
                      onChanged: (value) {
                        setState(() => selectedReferral = value);
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedReferral == null
                      ? null
                      : () => Navigator.pop(context, selectedReferral),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Screening For Angnwadi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'B. Deficiencies at Birth',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('No', style: TextStyle(fontSize: 16)),
                  Checkbox(
                    value: !hasDeficiency,
                    onChanged: (value) {
                      setState(() {
                        hasDeficiency = !(value ?? true);
                        if (!hasDeficiency) {
                          for (var d in deficiencyList) {
                            selectedDeficiencies[d] = false;
                            actionType[d] = null;
                            treatedNotes[d] = null;
                            referredTo[d] = null;
                          }
                        }
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(width: 20),
                  const Text('Yes', style: TextStyle(fontSize: 16)),
                  Checkbox(
                    value: hasDeficiency,
                    onChanged: (value) {
                      setState(() => hasDeficiency = value ?? false);
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              if (hasDeficiency) ...[
                const SizedBox(height: 16),
                ...deficiencyList.map((deficiency) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(deficiency,
                                style: const TextStyle(fontSize: 16)),
                          ),
                          Checkbox(
                            value: selectedDeficiencies[deficiency]!,
                            onChanged: (value) async {
                              if (value == true) {
                                final result = await _showActionDialog();
                                if (result != null) {
                                  setState(() {
                                    selectedDeficiencies[deficiency] = true;
                                    actionType[deficiency] = result;
                                    if (result == "Refer") {
                                      treatedNotes[deficiency] = null;
                                      _showReferralDialog().then((ref) {
                                        if (ref != null) {
                                          setState(() {
                                            referredTo[deficiency] = ref;
                                          });
                                        }
                                      });
                                    } else if (result == "Treated") {
                                      referredTo[deficiency] = null;
                                    }
                                  });
                                }
                              } else {
                                setState(() {
                                  selectedDeficiencies[deficiency] = false;
                                  actionType[deficiency] = null;
                                  treatedNotes[deficiency] = null;
                                  referredTo[deficiency] = null;
                                });
                              }
                            },
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      if (selectedDeficiencies[deficiency]! &&
                          actionType[deficiency] == "Treated")
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Enter Treated Note',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              treatedNotes[deficiency] = val;
                            },
                          ),
                        ),
                      if (selectedDeficiencies[deficiency]! &&
                          actionType[deficiency] == "Refer" &&
                          referredTo[deficiency] != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 4),
                          child: Text(
                            'Referred to: ${referredTo[deficiency]}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A5F7A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Previous',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Collect form data here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScreeningForAngnwadiClassFormFour()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A5F7A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child:
                          const Text('Next', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
