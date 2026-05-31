part of letterpress.store;

class Openly_Open_Source extends LPModule {
  Openly_Open_Source({required bool renderWithPost, required bool isPreviewMode})
    : super(
        title: "Openly Open-Source",
        coverImgName: 'Infinitude',
        lastUpdate: DateTime(2025, 03, 16),
        publicationDate: DateTime(2024, 11, 23),
        tags: [],
        includeTableOfContents: false,
        isPreviewMode: isPreviewMode,
        components: [
          LPTextSpan(
            lpTextComponents: [
              LPText.plainBody(
                content:
                    "I have worked on many personal projects before, and they're sitting on my GitHub as public repos with GPLv3 licenses. If that counts as open-source, then consider me a professional ",
              ),
              LPText.hyperlink(
                content: "open-sourcer",
                url:
                    "https://github.com/drknzz/GitHub-Achievements/blob/main/Media/Badges/Open-Sourcerer/PNG/OpenSourcerer.png",
              ),
              LPText.plainBody(content: ". "),
              LPText.plainBody(
                content:
                    "But of course, we're talking about open-source that involves the community and benefits at least a handful of users. And so how do you get started with those projects? I personally have intended for some of my projects to be used by the open source community, though for many of them, the progress bar has been stuck at 60% for quite a while now. But recently, one of my projects has reached a stable alpha version (I know, that sounds a bit suspicious) — most of its core features are working, and I would like to build up traction and feedback from the community as I develop it further.",
              ),
            ],
          ),
          LPText.header1(content: "Introduction to Affogato"),
          LPText.plainBody(
            content:
                "Before we get any further into the discussion, I'll provide some context around the project I'm planning to open source. As you might know, I dabble mostly with Flutter/Dart applications, and as I developed some web apps that utilised code editing interfaces, I realised that a suitable substitute for Monaco Editor simply wasn't there (bear in mind this is approximately a year ago, when there were around two or three code editor packages on pub.dev). Writing an entire IDE from scratch is something I've always wanted to do, and since there was a real need for it, I was sold on the idea. I got to work trying out different architectures for managing state, rendering the editor, laying out panes, etc. and soon enough (two or so weeks worth of man-hours but in actuality spanning six months) I had an editor up and running with core functionality. And now we are back to present time. There are still a trillion features I want to and need to add before the IDE can be considered anywhere near complete, but with the core features on hand, I wanted to quickly get the wheels of the ground before, you know, life happens.",
          ),
          LPText.header1(content: "When the Goalpost Keeps Shifting"),
          LPTextSpan(
            lpTextComponents: [
              LPText.plainBody(content: "Now, for those acquainted with my "),
              LPText.hyperlink(
                content: "previous articles",
                url:
                    "https://letterpress-project.web.app/#/blogules/perfekshun",
              ),
              LPText.plainBody(
                content:
                    ", you would know that I struggle to rein in the perfectionist in me. Turning an already public repo into an open-source project shouldn't be that tough right? Well, you'll be surprised at how I've managed to turn it into rocket science and a week-long endeavour.",
              ),
            ],
          ),
          LPImage.url(
            url:
                'https://en.meming.world/images/en/thumb/0/0d/Larry_the_Lobster_%22Observe%22.jpg/600px-Larry_the_Lobster_%22Observe%22.jpg',
            width: 400,
            height: 400,
          ),
          LPText.plainBody(
            content:
                "This is an outline of the TODO list that I came up with to plan my tasks (I say outline but in fact this was the only thing that I religiously referred to when deciding what tasks had to be done):",
          ),
          const LPCodeBlock(
            content: """Thread 1 (community)
1. LP deploy new changes, + add interactive elements
	=> subscribe to post updates, 
	=> analytics
2. Write about Affogato open-sourcing process on LP
3. Put affogato on pub.dev
4. Create community/reach out to subreddits
--
 * update Wiki with FAQ
 . Get domain verification

Thread 2 (Affogato dev)
1. Build out features (LSP, bug fixes, styling)
2. Dev testing/telemetry infra
3. Update issue queue with known issues
4. User documentation

Thread 3 (Affogato+Cortado Site)
1. Create animation frames
2. Build site (cross platform)
3. Add beta access list
4. Ask community about pricing model, prices
""",
          ),
          LPText.plainBody(
            content:
                "You'll notice I split it up into multiple threads, and that's because naturally, there are multiple independent deliverables and this multi-threaded approach would help me still get stuff done while one thread is blocked (due to errors or while waiting on some information).",
          ),
          LPTextSpan(
            lpTextComponents: [
              LPText.hyperlink(
                content: "IMAGE",
                url: "https://i.redd.it/zsmfa93b0tjd1.jpeg",
              ),
              LPText.plainBody(content: "\nFrom ("),
              LPText.hyperlink(
                content:
                    "https://www.reddit.com/r/ProgrammerHumor/comments/1ewt16f/multithreadingiseasy/?utm_source=share&amp;utm_medium=web3x&amp;utm_name=web3xcss&amp;utm_term=1&amp;utm_content=share_button",
                url:
                    "https://www.reddit.com/r/ProgrammerHumor/comments/1ewt16f/multithreadingiseasy/?utm_source=share&amp;utm_medium=web3x&amp;utm_name=web3xcss&amp;utm_term=1&amp;utm_content=share_button",
              ),
              LPText.plainBody(content: ")"),
            ],
          ),
          LPText.plainBody(
            content:
                'instance, refers to this blog, Letterpress. I needed to add "new changes" such as the ability to subscribe to email notifications and to send anonymous analytics about which articles were clicking. After that, I could write and publish a few articles about my experience with going open source and then Letterpress would be fully ready to face the world. I was hoping that at the same time as I was promoting the Affogato Project on Reddit, I could also spread the word about Letterpress, in which case I would need to have at least a few really good articles that would interest visitors.',
          ),
          LPTextSpan(
            lpTextComponents: [
              LPText.plainBody(
                content:
                    "The second thread relates to the actual features I need to add on before releasing even v0.0.1 to pub.dev. I even considered writing some tests, but didn't since ",
              ),
              LPText.hyperlink(
                content: "real men test in production",
                url: "https://youtu.be/H9RSeDUdkCA?si=c0zjVdBTTeyAiHXG",
              ),
              LPText.plainBody(
                content:
                    ". Maybe there's a chance that quite possibly, at some time in the future, I might consider 100% test coverage. But for now, I've decided that I won't be accepting contributions as yet. I'm really swamped with a lot of work not just in the Affogato Project, but also in other projects, and the headache of documentation, writing tests, reviewing PRs and building CI/CD pipelines is something I don't need right now. So I'm just sticking to the good ol' it-seems-alright-testing.",
              ),
            ],
          ),
          LPText.plainBody(
            content:
                "The third thread is actually an extension of my open-source project, where I develop a SaaS offering which combines the groundwork laid by Affogato with cloud computing resources to provide integrated terminals, code execution, and third-party extensions. That is actually a really interesting process too, and it's also my first time launching a SaaS (or even any form of paid software), so you can read more about my experience in this post. Unfortunately, though, this thread turned out to be a little too burdensome for me, partly because I bit off more than I could chew by trying to add a scroll-based animation to the site's landing page. I not only had to draw and animate each frame by hand, but also had to ensure the site was compatible across different screen sizes. After that was done, I would have to hook it up to a backend sever, similar to how I did with Letterpress, to store email addresses for the beta access list.",
          ),
          LPText.plainBody(
            content:
                "So basically, I had gone from simply having to publish my package on pub.dev and having to write some documentation to now needing to build a website, draw animations, create two backed servers, write new blog posts, and so on. Oh, and one more thing. Did I mention I was heavily insecure about launching a semi-finished package out for the open-source community to see? All in all, it feels like I've overcomplicated the process of going open-source, but I don't know if others also follow a similar sequence of steps and I'm just overreacting, or whether I need to learn to be okay with imperfect.",
          ),
          LPText.header1(content: "Ball, regardless"),
          LPText.plainBody(
            content:
                """It took a few hours of pondering and a few nights of sleeping-it-over before I could convince 	myself that this was a project that I started, I poured my heart and soul into, and that only I know of. I can do whatever the 🦆 I want with it. I can go full open-source, or maybe half, or even a bit less than that. I can take my time with it. And honestly, amid all the AI slop and multimillion-dollar-SaaS-vibe-coded-in-3-hours, only the real devs know the value of handcrafted goods. The satisfaction and fulfilment of knowing the ins and outs of every line of code and of bringing a real software artifact with a soul, to life. So it doesn't matter too much what others think or what they want me to do with the project. At the end of the day, I'm just trying to create value for myself and others. This means neither "myself" nor "others" should get sidelined by the other party. And if that means gradually improving the project rather than rushing through the steps, then that's what it gotta be.""",
          ),
          LPText.plainBody(
            content:
                "With that in mind, I took my time and created a banger landing page.",
          ),
        ],
        projectName: 'affogato',
        renderWithPost: renderWithPost,
      );
}
