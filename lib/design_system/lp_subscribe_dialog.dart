part of letterpress.ds;

/// Asks for an email address and subscribes it to one thing.
///
/// Replaces the old three-field form, which asked for a name and a
/// specialisation before it would let anyone subscribe, rendered nothing at all
/// on mobile, and did not store what it collected. An address is the only field
/// actually needed to send an email to someone.
class LPSubscribeDialog extends StatefulWidget {
  final LPSubscriptionTarget target;

  const LPSubscribeDialog({required this.target, super.key});

  /// Opens the dialog. Resolves true if a subscription was created.
  static Future<bool> show(
    BuildContext context,
    LPSubscriptionTarget target,
  ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierColor: LPColor.inkBlue_700.withOpacity(0.72),
      builder: (_) => LPSubscribeDialog(target: target),
    );
    return result ?? false;
  }

  @override
  State<LPSubscribeDialog> createState() => LPSubscribeDialogState();
}

class LPSubscribeDialogState extends State<LPSubscribeDialog> {
  final TextEditingController email = TextEditingController();
  bool submitting = false;
  LPSubscribeOutcome? outcome;

  @override
  void initState() {
    super.initState();
    email.addListener(() {
      // Clear a previous verdict as soon as the address is edited, so a stale
      // "already subscribed" does not sit under a different address.
      if (outcome != null) setState(() => outcome = null);
    });
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  String get _blurb => switch (widget.target.kind) {
        LPSubscriptionKind.post =>
          'I will email you when this post is updated — new sections, corrections, '
              'rewrites. Nothing else, ever, and one click unsubscribes you.',
        LPSubscriptionKind.newsletter =>
          'I will email you a PDF of each new issue as it is published. Nothing '
              'else, ever, and one click unsubscribes you.',
      };

  Future<void> submit() async {
    setState(() => submitting = true);
    final LPSubscribeOutcome result = await LPSubscriptions.instance.subscribe(
      email: email.text,
      target: widget.target,
    );
    if (!mounted) return;
    setState(() {
      submitting = false;
      outcome = result;
    });
    if (result == LPSubscribeOutcome.subscribed) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: math.min(560, vp.size.width * vp.pick(mobile: 0.9, desktop: 0.5)),
          padding: EdgeInsets.all(vp.pick(mobile: 24, desktop: 40)),
          decoration: BoxDecoration(
            color: LPColor.inkBlue_500,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: LPColor.rollerBlue_500),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.target.label,
                style: header2.apply(
                  const TextStyle(color: LPColor.gripperBlue_500),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _blurb,
                style: body2.apply(
                  TextStyle(color: LPColor.gripperBlue_400.withOpacity(0.85)),
                ),
              ),
              const SizedBox(height: 26),
              TextField(
                controller: email,
                autofocus: true,
                enabled: !submitting,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => submit(),
                style: body2.apply(
                  const TextStyle(color: LPColor.gripperBlue_500),
                ),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: body2.apply(
                    TextStyle(color: LPColor.gripperBlue_500.withOpacity(0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: LPColor.rollerBlue_500.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: LPColor.rollerBlue_500),
                  ),
                ),
              ),
              if (outcome != null) ...[
                const SizedBox(height: 14),
                _Verdict(outcome: outcome!),
              ],
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LPButton(
                    width: 120,
                    height: 44,
                    callback: () => Navigator.of(context).pop(false),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: body2.apply(
                          TextStyle(
                            color: LPColor.gripperBlue_400.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  LPButton(
                    width: 150,
                    height: 44,
                    initialState: submitting
                        ? ButtonState.disabled
                        : ButtonState.enabled,
                    callback: submitting ? () {} : submit,
                    child: Center(
                      child: Text(
                        submitting ? 'One moment…' : 'Subscribe',
                        style: body2.apply(
                          const TextStyle(color: LPColor.gripperBlue_400),
                        ),
                      ),
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

class _Verdict extends StatelessWidget {
  final LPSubscribeOutcome outcome;

  const _Verdict({required this.outcome});

  @override
  Widget build(BuildContext context) {
    final (String message, Color colour) = switch (outcome) {
      LPSubscribeOutcome.subscribed => (
          'Done — you are on the list.',
          LPColor.gripperBlue_500,
        ),
      LPSubscribeOutcome.alreadySubscribed => (
          'That address is already subscribed to this.',
          LPColor.gripperBlue_400,
        ),
      LPSubscribeOutcome.invalidEmail => (
          'That does not look like an email address.',
          LPColor.chaseRed_500,
        ),
      LPSubscribeOutcome.failed => (
          'Could not save that just now. Please try again later.',
          LPColor.chaseRed_500,
        ),
    };

    return Text(
      message,
      style: body2.apply(TextStyle(color: colour)),
    );
  }
}

/// The square mail button that opens [LPSubscribeDialog].
class LPSubscribeButton extends StatelessWidget {
  final LPSubscriptionTarget target;
  final double size;

  const LPSubscribeButton({
    required this.target,
    this.size = 40,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Subscribe to ${target.label}',
      child: LPButton(
        width: size,
        height: size,
        callback: () => LPSubscribeDialog.show(context, target),
        child: Icon(
          Icons.mail_outline,
          size: size * 0.5,
          color: LPColor.rollerBlue_500,
        ),
      ),
    );
  }
}
