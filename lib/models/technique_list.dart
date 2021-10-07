class TechniqueList {
  final String color;
  final String desc;
  final String family;
  final String img;
  final String jawara_muda;
  final double jm_stripe;
  final double numbering;
  final double order;
  final String satria_muda;
  final double sm_stripe;
  final String technique;
  final String vidName;
  final String videoUrl;

  TechniqueList({ required this.desc, required this.color}) ;

  factory TechniqueList.fromRTDB(Map<String, dynamic> data) {
    return TechniqueList(
      desc: data['desc'] ?? 'No Description',
      color: data['color'] ?? 'white'
    );
  }
}