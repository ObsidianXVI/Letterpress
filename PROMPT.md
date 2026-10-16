

MINOR IMPROVEMENTS

- When within an article view (blogule/post), after scrolling down past the cover image/title area, and when the top info bar (article title + date) appears, include the following additional widgets within the bar:
  a. the leftmost side should be a sqaure iconbutton that
- Improve the selectable text experience within and outside of the articles themselves, allow other text in the app to be selectable too. Use the latest native Flutter API features for that, and allow inter-paragraph selections (currently not possible). Display native context menu on right-click (currently the selection jumps to another word before context menu is displayed).
- code blocks can be styled better. maybe consider a third party package for line numbering, text selection, syntax highlighting, etc. Improve also inline code formatting and rendering.
- in the sticky header widget for the render view when reading articles, at the top center include also the current section/subsection (e.g. "Chapter 1" or "Intro > Some Background On This") based on the LP headings of the article and what's in view. Allow this to be clickable and it shows a dropdown of all sections to easily jump to a section.
- Disable swipe right to navigate to previous page (browser-level)
- Spacing for Discover area on home page: some content cut off, ensure layout and sizing is proper
- ensure mobile experience is just as good
- add in rigorous tests

