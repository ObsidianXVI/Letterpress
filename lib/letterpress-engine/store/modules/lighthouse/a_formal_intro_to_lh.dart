part of letterpress.store;

class A_Formal_Intro_To_Lh extends LPModule {
  A_Formal_Intro_To_Lh({required bool renderWithPost})
      : super(
          title: "A formal introduction to Lighthouse",
          lastUpdate: DateTime(2023, 10, 29),
          publicationDate: DateTime(2023, 9, 4),
          tags: [],
          includeTableOfContents: false,
          components: [
            LPText.plainBody(
                content:
                    "Lighthouse is a project I started in the June of 2022, 3 months after I first started coding. Even though Lighthouse was my first coding project (I had never completed even a single mini-project while learning to code), I wanted to go big."),
            LPText.plainBody(
                content:
                    "I asked myself, “What would be a useful application to develop? What is something that people, including me, would actually use?”. At the time of thinking, I was really into productivity and the like. I was playing around with many different types of software, from project management tools like Jira or Asana, to calendars like the one by Apple or Google. Learning about integration and IoT was another big thing that I had going on at the time, and that constitutes the other half of the driving force behind Lighthouse."),
            LPText.plainBody(
                content:
                    "Having just discovered all the amazing things possible in the world of 0s and 1s, I was obviously more interested in learning what it could do for me. So I got into scripting. Nope, not Python as you would think, but instead, with iOS Shortcuts. For those who don't know, Shortcuts is an iOS application where you can create programs and automations to execute commands on your iPhone easily. I was trying to use Shortcuts to integrate the different tools I used, and went so far as to try out different URL schemes and X-callbacks. What I found to be sorely lacking was integration and interoperability between the different tools."),
            LPText.plainBody(
                content:
                    "As such, I wanted Lighthouse to be the ultimate productivity tool — one that could help you get your entire act together, not just your personal or professional acts; one that integrates with various tools that you already use; one that was customisable and extensible; one that actually worked with you instead of just increasing administrative overhead."),
            LPText.plainBody(
                content:
                    "Needless to say, all of this was a very ambitious undertaking, but what better did I know? All I had at the time was a basic understanding of Python and a burning desire to build Lighthouse. They say a journey of a thousand miles begins with a single step, and I dived headfirst into this bitch."),
          ],
          projectName: 'lighthouse',
          renderWithPost: renderWithPost,
        );
}
