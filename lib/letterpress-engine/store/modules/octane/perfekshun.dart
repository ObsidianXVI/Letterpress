part of letterpress.store;

class Perfekshun extends LPModule {
  Perfekshun({required bool renderWithPost})
      : super(
          title: "Perfekshun.",
          coverImgName: 'Grayscales',
          lastUpdate: DateTime(2023, 10, 30),
          publicationDate: DateTime(2023, 10, 30),
          tags: [],
          includeTableOfContents: false,
          components: [
            LPText.plainBody(
                content:
                    "This year, I finally started work on a long overdue project, Octane, which is what I named my personal portfolio page. Designed to embody all my skills, values, and personality in a web page, I knew this had to be my best piece of work so far. And that's a common pitfall for me and probably many other perfections out there as well. We want to either put out things that are perfect, or nothing at all. We do not want to be associated with a piece that does not seem like our best effort. But that mindset has to change because it is so detrimental to the creative process and our overall productivity."),
            LPText.plainBody(
                content:
                    "I realised in the early stages of ideating for Octane that no idea ever seemed “worthy” enough, and I soon became aware of my perfectionistic attitude. Suddenly, I recalled all the instances in past projects were I was generating ideas or developing a feature and seemed to place too much emphasis on ironing out all the details. I would consequently end up getting frustrated (in the case of idea generation) or procrastinating (in the case of development). Obviously, I had to do something about this habit of mine."),
            LPText.plainBody(
                content:
                    "So with Octane, I decided that I will set specific durations for each stage of the process: a week for ideation, three weeks for development, and around one week for deployment. The idea was that at the end of the allotted duration for each stage, I would move on to the next step with whatever I had so far. While this did motivate me to work harder and generate better ideas initially, I still struggled with keeping myself accountable. There was nothing stopping me from extending my own deadlines. And that's where I sort of hit a wall, because I wasn't exactly eager on roping in an “accountability partner”. Finally, I settled on the carrot to dangle in front of myself — an interesting side project that I was really eager to do. When I started my blog, Letterpress, there were some side projects I had in mind which I wanted to do and document while doing. I knew I was really excited for some of those projects, so I picked the most exciting one, and told myself that as soon as I pushed out V1 of Octane, I could start work on that."),
            LPText.plainBody(
                content:
                    "So for the rest of the pieces in this project, join me as I fight my demons to create a personal portfolio site."),
          ],
          projectName: 'octane',
          renderWithPost: renderWithPost,
        );
}
