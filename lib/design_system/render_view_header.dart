part of letterpress.ds;

class RenderViewHeader extends StatefulWidget {
  final double vpWidth;
  final LPArticle article;

  const RenderViewHeader({
    required this.vpWidth,
    required this.article,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => RenderViewHeaderState();
}

class RenderViewHeaderState extends State<RenderViewHeader> {
  bool isSubscribedToPost = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.vpWidth,
      height:
          Multiplatform.currentPlatform == const DesktopPlatform() ? 70 : 50,
      decoration: BoxDecoration(
        color: LPColor.inkBlue_500.withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.article.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body.apply(
                      const TextStyle(
                        color: LPColor.gripperBlue_400,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (widget.article is LPPost)
                    LPButton(
                      width: 54,
                      height: 32,
                      callback: () async {
                        final givenEmail = await showDialog<bool>(
                          context: context,
                          builder: (context) => EmailSubscriptionDialog(
                            isSubscribed: isSubscribedToPost,
                          ),
                        );
                        setState(() {
                          isSubscribedToPost =
                              (givenEmail != null && givenEmail == true)
                                  ? true
                                  : isSubscribedToPost;
                        });
                      },
                      child: Icon(
                        isSubscribedToPost ? Icons.mark_email_read : Icons.mail,
                        size: 24,
                        color: LPColor.rollerBlue_500,
                      ),
                    ),
                  const SizedBox(width: 20),
                  Text(
                    widget.article.lastUpdate.toDateString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: body.apply(
                      TextStyle(
                        color: LPColor.gripperBlue_400.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
