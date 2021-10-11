class TechniqueList {
  final String color;
  final String desc;
  final String family;
  /*final String img;
  final String jawara_muda;
  final double jm_stripe;
  final double numbering;
  final double order;
  final String satria_muda;
  final double sm_stripe;
  final String technique;
  final String vidName;
  final String videoUrl;*/

  TechniqueList({
    required this.desc,
    required this.color,
    required this.family,
  /*  required this.img,
    required this.jawara_muda,
    required this.jm_stripe,
    required this.numbering,
    required this.order,
    required this.satria_muda,
    required this.sm_stripe,
    required this.technique,
    required this.vidName,
    required this.videoUrl,*/
  });

  factory TechniqueList.fromRTDB(Map<String, dynamic> data) {
    return TechniqueList(
        desc: data['desc'] ?? 'No Description',
        color: data['color'] ?? 'white',
        family: data['family'] ?? 'no family');
  }
}
