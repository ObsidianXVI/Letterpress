part of letterpress.ds;

class EmailSubscriptionDialog extends StatefulWidget {
  final bool isSubscribed;

  const EmailSubscriptionDialog({required this.isSubscribed, super.key});

  @override
  State<StatefulWidget> createState() => EmailSubscriptionDialogState();
}

class EmailSubscriptionDialogState extends State<EmailSubscriptionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fieldController = TextEditingController();
  final List<DropdownMenuEntry<String>> entries = [
    for (final label in _fields)
      DropdownMenuEntry(
        value: label.replaceAll(' ', '-').toLowerCase(),
        label: label,
        labelWidget: Text(
          label,
          style: body2.apply(const TextStyle(color: LPColor.gripperBlue_500)),
        ),
      ),
  ];
  String? fieldError;

  @override
  void initState() {
    nameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    fieldController.addListener(() {
      validateFieldEntry();
      setState(() {});
    });
    super.initState();
  }

  bool validateFieldEntry() {
    if (!_fields.any(
      (field) => field
          .replaceAll(' ', '-')
          .toLowerCase()
          .contains(fieldController.text.replaceAll(' ', '-').toLowerCase()),
    )) {
      fieldError =
          "Sorry, but you have to choose from one of the given options.";
    } else {
      fieldError = null;
    }
    setState(() {});
    // print((isFormFilled && (fieldError != null)));
    return fieldError != null;
  }

  @override
  Widget build(BuildContext context) {
    final bool useLargeLayout = context.isDesktopLayout;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: useLargeLayout
            ? Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                height: MediaQuery.sizeOf(context).height * 0.65,
                decoration: BoxDecoration(
                  color: LPColor.inkBlue_500,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: LPColor.rollerBlue_500),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'Email Notifications',
                            style: DialogTitle().apply(
                              const TextStyle(color: LPColor.rollerBlue_500),
                            ),
                          ),
                          const SizedBox(height: 360),
                          LPText.plainBody(
                            content:
                                "You can opt to be notified via email when I publish more blogules in this series. I won't sell your data, I won't send you promotional emails for anything, I won't spam you with useless updates about Letterpress. Just a notification each time there's more to read in this series. And you can unsubscribe any time with one click from your inbox, no questions asked.",
                          ),
                          const SizedBox(height: 20),
                          LPText.plainBody(
                            content:
                                "If this sounds cool with you, please fill out this poorly-designed form so I can get to know you a bit better!",
                          ),
                          const SizedBox(height: 60),
                          TextFormField(
                            controller: nameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                ? null
                                : "Please don't leave this field empty. I need to be able to identify you somehow!",
                            style: body2.apply(
                              const TextStyle(color: LPColor.gripperBlue_500),
                            ),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                              errorStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.chaseRed_500.withOpacity(0.6),
                                ),
                              ),
                              helperText:
                                  'So that I can address you appropriately in my emails.',
                              hintText: 'Name, in any form',
                              hintStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.6,
                                  ),
                                ),
                              ),
                              helperStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.isValidEmail()
                                ? null
                                : "Please provide a valid email.",
                            style: body2.apply(
                              const TextStyle(color: LPColor.gripperBlue_500),
                            ),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                              errorStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.chaseRed_500.withOpacity(0.6),
                                ),
                              ),
                              helperText:
                                  'So that the email finds you, hopefully well.',
                              hintText: 'Email address',
                              hintStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.6,
                                  ),
                                ),
                              ),
                              helperStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          DropdownMenu<String>(
                            controller: fieldController,
                            onSelected: (_) {
                              validateFieldEntry();
                              setState(() {});
                            },
                            enableFilter: true,
                            filterCallback: (entries, filter) {
                              final res = entries.where(
                                (e) => e.label.toLowerCase().startsWith(filter),
                              );
                              return res.isEmpty ? entries : res.toList();
                            },
                            textStyle: body2.apply(
                              const TextStyle(color: LPColor.gripperBlue_500),
                            ),
                            hintText: 'The primary field you specialise in',
                            errorText: fieldError,
                            inputDecorationTheme: InputDecorationTheme(
                              hintStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.6,
                                  ),
                                ),
                              ),
                              helperStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.4,
                                  ),
                                ),
                              ),
                              errorStyle: body2.apply(
                                TextStyle(
                                  color: LPColor.chaseRed_500.withOpacity(0.6),
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                            ),
                            width:
                                MediaQuery.of(context).size.width * 0.6 - 120,
                            menuStyle: MenuStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                LPColor.inkBlue_500,
                              ),
                              side: WidgetStatePropertyAll(
                                BorderSide(
                                  color: LPColor.gripperBlue_500.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                            ),
                            dropdownMenuEntries: entries,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              LPButton(
                                width: 320,
                                height: 80,
                                child: Center(
                                  child: Text(
                                    "No, thanks",
                                    style: body.apply(
                                      const TextStyle(
                                        color: LPColor.gripperBlue_400,
                                      ),
                                    ),
                                  ),
                                ),
                                callback: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              const SizedBox(width: 20),
                              LPButton(
                                width: 320,
                                height: 80,
                                initialState:
                                    isFormFilled && validateFieldEntry()
                                    ? ButtonState.enabled
                                    : ButtonState.disabled,
                                child: Center(
                                  child: Text(
                                    "Count me in!",
                                    style: body.apply(
                                      TextStyle(
                                        color:
                                            isFormFilled && validateFieldEntry()
                                            ? LPColor.gripperBlue_400
                                            : LPColor.gripperBlue_400
                                                  .withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                ),
                                callback: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  bool get isFormFilled =>
      (nameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      fieldController.text.isNotEmpty);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    fieldController.dispose();
    super.dispose();
  }

  static const _fields = <String>[
    "Student",
    "Developer",
    "IT Manager",
    "Other",
  ];
}

// from https://stackoverflow.com/a/61512807
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}
