# Subscriptions

Readers can subscribe to a **post** (told when it is updated) or to a
**newsletter** (sent a PDF of each new issue). Sending is manual: a local CLI,
run deliberately, not a trigger on publish.

## Shape

```
Flutter web  ──write──►  Firestore  ◄──read──  local CLI  ──►  email provider
```

Nothing else runs. There is no server in the sending path.

## Does this need Cloud Run or Cloud Functions?

**For sending, no.** The CLI runs on your machine, authenticates to Firestore
with your own credentials, reads the subscriber list and calls the provider API
directly. Nothing needs to be deployed or kept running, and the provider API key
never leaves your machine.

**For subscribing, it depends on one decision.** The web app has to get an
address into Firestore, and there are only two ways:

**Single opt-in — no server.** The client writes straight to Firestore under
security rules. Workable, and it is what the current code assumes. The cost is
that nothing verifies the address belongs to the person typing it, so anyone can
subscribe anyone else. For a personal blog that is an annoyance rather than a
breach, but it also hurts deliverability: addresses that never asked to be
mailed generate spam complaints.

**Double opt-in — needs a server endpoint.** A confirmation email has to be sent
at subscribe time, and that means calling the provider, and the provider API key
cannot be in a web bundle where anyone can read it. That is one Cloud Run
service doing one thing. It is the correct answer if the list is ever going to
matter.

Either way, the subscribe path is the only reason a server would exist. Recorded
in `DECISIONS_NEEDED.md`.

## Firestore rules

Two properties matter, and they are easy to get wrong:

**The collection must not be readable by clients.** A readable subscriber
collection is an address book anyone can download.

**Duplicate detection must not require a read.** "Is this address already
subscribed?" looks like a query, and a query needs read access — which is the
thing we just forbade. Instead the document id is derived from the target and
the address (`LPSubscriptionTarget.documentIdFor`), and the rule allows `create`
only. A second subscribe hits an existing id, the create is rejected, and the
client reports "already subscribed" without ever being able to read anything.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /subscriptions/{id} {
      // Create only: no read, no update, no delete from any client.
      allow read, update, delete: if false;
      allow create: if request.resource.data.keys().hasOnly(
                        ['email', 'kind', 'slug', 'createdAt', 'confirmed'])
                    && request.resource.data.email is string
                    && request.resource.data.email.size() < 320
                    && request.resource.data.kind in ['post', 'newsletter']
                    && request.resource.data.slug is string
                    && request.resource.data.confirmed == false;
    }
  }
}
```

Turn on **App Check** as well, or the rules above are a public write endpoint
that anyone can fill with junk. Rules cannot rate-limit.

## Still to do

1. Pick a provider (`DECISIONS_NEEDED.md`), decide single vs double opt-in.
2. `flutterfire configure` against `letterpress-project`, which generates
   `firebase_options.dart` and adds `firebase_core` + `cloud_firestore`.
3. Implement `FirestoreLPSubscriptions` against the `LPSubscriptions` interface
   and assign it to `LPSubscriptions.instance` at startup. Until then the
   in-memory stub is installed, and it reports failure rather than pretending a
   subscription was stored — a reader told they are subscribed when nothing was
   saved is worse than one told it did not work.
4. Deploy the rules above and enable App Check.
5. Write the CLI: read subscribers for a target, render the email, attach the
   issue PDF, send, record what was sent so a re-run does not double-send.
