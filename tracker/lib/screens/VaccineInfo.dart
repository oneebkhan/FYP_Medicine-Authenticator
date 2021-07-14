import 'package:flutter/material.dart';

class VaccineInfo extends StatefulWidget {
  //VaccineInfo({Key? key}) : super(key: key);

  @override
  _VaccineInfoState createState() => _VaccineInfoState();
}

class _VaccineInfoState extends State<VaccineInfo> {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width / 20,
                ),
                _vaccineModel(
                  width: width,
                  title: '1. Sinopharm/Sinovac/Pakvac',
                  description:
                      'Dose: 2 vaccines, 2 weeks apart\n\nAll are inactivated virus vaccines. This means they’re made from viral particles produced in a lab, which are then inactivated so they can’t infect you with COVID-19. Many other vaccines use similar platforms, including injectable polio, Hepatitis A and flu vaccines.\n\nSide-effects: fever and fatigue, were found to be uncommon after Sinovac or Sinopharm. Only 79 people reported mostly mild adverse events following 1.1 million doses of Sinopharm in China, much lower than usual rates of adverse event reporting following immunisation.',
                ),
                SizedBox(
                  height: width / 8,
                ),
                _vaccineModel(
                  width: width,
                  title: '2. Sputnik',
                  description:
                      'Dose: 2 vaccines, 2 weeks apart\n\nThe original vaccine, Sputnik V, which Russia’s Gamaleya Research Institute of Epidemiology and Microbiology developed, consists of two different adenoviruses that require delivery by two separate vaccinations. Both doses contain non-replicating viral vectors. The first uses adenovirus type 26 (AD26), and the second — which a person receives 21 days later — contains adenovirus type 5 (AD5). The vaccine offers a 79.4% efficacy and costs less than \$10 per dose.\n\nSide effects: mild pain at the injection site, fever, headaches, fatigue, muscle aches',
                ),
                SizedBox(
                  height: width / 8,
                ),
                _vaccineModel(
                    width: width,
                    title: '3. Pfizer',
                    description:
                        'Dose: 2 vaccines, 2 weeks apart\n\nVaccine formulated in America and currently one of the most effective, along side the russian based sputnik.\n\nSide effects: mild pain at the injection site, fever, headaches, fatigue, muscle aches'),
                SizedBox(
                  height: width / 8,
                ),
                _vaccineModel(
                    width: width,
                    title: '4. AstraZeneca ⚠',
                    description:
                        'BANNED! AVOID NOW!\n\nDose: 2 vaccines 2 months apart\n\nThis viral vector vaccine contains the gene that encodes for the spike protein on the surface of the SARS-CoV-2 virus. Once delivered to our cells, the gene is transcribed, prompting our cells to make the spike protein. The presence of this protein triggers the body’s immune system to produce antibodies to fight against the spike protein, which then prepares the body to fight against SARS-CoV-2 should it enter the body.\n\nSide Effects: mild pain at the injection site, fever, headaches, fatigue, muscle aches, rare cases of blood clotting and the vaccine has hence been banned'),
                SizedBox(
                  height: width / 7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _vaccineModel({String title, String description, double width}) {
    return Container(
      width: width / 1.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: width / 18,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: width / 30,
            ),
          ),
        ],
      ),
    );
  }
}
