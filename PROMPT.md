General UI Requirements
1. Responsiveness of cards, images, and paddings. As much as possible, try not to scale font size.
2. Make blogules route itself inaccessible, only individual `blogules/<title>` allowed


Specific UI Features
- Actually selectable text (use latest Flutter APIs for it, the SDK has come a long way now to natively support selectable text) instead of being limited with intra-para selections only or not having proper context menu
- code blocks can be styled better. maybe consider a third party package for line numbering, text selection, syntax highlighting, etc. Improve also inline code formatting and rendering.
- in the sticky header widget for the render view when reading articles, at the top center include also the current section/subsection (e.g. "Chapter 1" or "Intro > Some Background On This") based on the LP headings of the article and what's in view. Allow this to be clickable and it shows a dropdown of all sections to easily jump to a section.
