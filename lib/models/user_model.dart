class UserModel {
  final String admin;
  final int age;
  final String belt;
  final String comments;
  final String curriculum;
  final String email;
  final double firstname;
  final bool isApproved;
  final String lastname;
  final String stripe;

  UserModel({
    required this.admin,
    required this.age,
    required this.belt,
    required this.comments,
    required this.curriculum,
    required this.email,
    required this.firstname,
    required this.isApproved,
    required this.lastname,
    required this.stripe,
  });

  factory UserModel.fromRTDB(Map<String, dynamic> data) {
    return UserModel(
        admin: data['admin'] ?? 'admin',
        age: data['age'] ?? 0,
        belt: data['belt'] ?? 'belt',
        comments: data['comments'] ?? 'comments',
        curriculum: data['curriculum'] ?? 'curriculum',
        email: data['email'] ?? 'email',
        firstname: data['firstname'] ?? 'firstname',
        isApproved: data['isApproved'] ?? false,
        lastname: data['lastname'] ?? 'lastname',
        stripe: data['stripe'] ?? 'stripe');
  }
}
