library letterpress.subscriptions;

/// What a reader is asking to be told about.
enum LPSubscriptionKind {
  /// A post, notified when it is updated.
  post,

  /// A newsletter, notified with a PDF when an issue is published.
  newsletter,
}

/// The thing being subscribed to.
class LPSubscriptionTarget {
  final LPSubscriptionKind kind;

  /// Stable identifier. For newsletters this is [LPNewsletter.slug]; for posts,
  /// the URL slug. It is the key subscriptions are stored under, so it must not
  /// change once anyone has subscribed.
  final String slug;

  /// Shown to the reader in the dialog.
  final String label;

  const LPSubscriptionTarget({
    required this.kind,
    required this.slug,
    required this.label,
  });

  /// Document id for a subscription, derived rather than random.
  ///
  /// Deriving it is what lets a duplicate subscribe be rejected by a
  /// create-only security rule instead of by a query. A query would mean
  /// granting read access to the subscriber collection, which would turn it
  /// into an address-book anyone could walk.
  String documentIdFor(String email) =>
      '${kind.name}__${slug}__${email.trim().toLowerCase()}';
}

/// Outcome of a subscribe attempt.
enum LPSubscribeOutcome {
  subscribed,

  /// This address is already on the list for this target.
  alreadySubscribed,

  /// Rejected before it was stored — a malformed address, say.
  invalidEmail,

  /// Something went wrong reaching the store.
  failed,
}

/// Where subscriptions go.
///
/// An interface rather than a direct Firestore call, so the storage and the
/// eventual sending provider can change without the UI knowing. The dialog only
/// ever sees an [LPSubscribeOutcome].
abstract class LPSubscriptions {
  Future<LPSubscribeOutcome> subscribe({
    required String email,
    required LPSubscriptionTarget target,
  });

  /// The instance the app uses. Swapped at startup once Firestore is
  /// configured; see docs/subscriptions.md.
  static LPSubscriptions instance = InMemoryLPSubscriptions();
}

/// Stand-in until Firestore is wired up.
///
/// Deliberately not a silent no-op that reports success: a reader told they are
/// subscribed when nothing was stored is worse than one told it did not work.
/// It records within the session so the "already subscribed" path is
/// exercisable, and reports failure otherwise.
class InMemoryLPSubscriptions implements LPSubscriptions {
  final Set<String> _seen = <String>{};

  /// Set true only in tests and local UI work.
  final bool pretendItWorks;

  InMemoryLPSubscriptions({this.pretendItWorks = false});

  @override
  Future<LPSubscribeOutcome> subscribe({
    required String email,
    required LPSubscriptionTarget target,
  }) async {
    if (!_looksLikeEmail(email)) return LPSubscribeOutcome.invalidEmail;
    if (!pretendItWorks) return LPSubscribeOutcome.failed;

    final String id = target.documentIdFor(email);
    if (!_seen.add(id)) return LPSubscribeOutcome.alreadySubscribed;
    return LPSubscribeOutcome.subscribed;
  }
}

bool _looksLikeEmail(String value) {
  final String v = value.trim();
  // Deliberately loose. Anything stricter rejects addresses that are perfectly
  // valid, and the confirmation email is what actually proves an address works.
  return RegExp(r'^[^@\s]+@[^@\s.]+\.[^@\s]+$').hasMatch(v);
}
