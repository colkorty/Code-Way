class Profession {
    final String id;
    final String title;
    final int step;
    final String shortDescription;
    final String fullInfo;
    final List<String> skills;
    final List<String> resources;

    Profession({
        required this.id,
        required this.title,
        required this.step,
        required this.shortDescription,
        required this.fullInfo,
        required this.skills,
        required this.resources,
    });

    factory Profession.fromFirestore(String docId, Map<String, dynamic> data) {
        return Profession(
            id: docId,
            title: data['title'] ?? 'No name',
            step: data['step'] ?? 0,
            shortDescription: data['short_description'] ?? 'No description',
            fullInfo: data['full_info'] ?? 'No info',
            skills: List<String>.from(data['skills'] ?? []),
            resources: List<String>.from(data['resources'] ?? []),
        );
    }
}
