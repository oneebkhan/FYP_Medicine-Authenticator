class CoronaModel {
  final int infected;
  final int tested;
  final int recovered;
  final int deceased;
  final int critical;
  final String lastUpdated;

  const CoronaModel({
    this.infected,
    this.tested,
    this.recovered,
    this.deceased,
    this.critical,
    this.lastUpdated,
  });

  factory CoronaModel.fromJson(final json) {
    return CoronaModel(
      infected: json["infected"],
      tested: json["tested"],
      recovered: json["recovered"],
      deceased: json["deceased"],
      critical: json["critical"],
      lastUpdated: json["lastUpdatedAtApify"],
    );
  }
}
