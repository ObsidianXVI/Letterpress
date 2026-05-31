As you have understood the project structure and context files in this project, the current contents of all the context files are from another project, intended as examples for reference. Once you've understood it, start over from scratch on all those files.

Your tasks now are:


General UI Requirements
1. Responsiveness of cards, images, and paddings. As much as possible, try not to scale font size.
2. Make blogules route itself inaccessible, only individual `blogules/<title>` allowed


Specific UI Features
- Actually selectable text (use latest Flutter APIs for it, the SDK has come a long way now to natively support selectable text) instead of being limited with intra-para selections only or not having proper context menu
- code blocks can be styled better. maybe consider a third party package for line numbering, text selection, syntax highlighting, etc. Improve also inline code formatting and rendering.
- in the sticky header widget for the render view when reading articles, at the top center include also the current section/subsection (e.g. "Chapter 1" or "Intro > Some Background On This") based on the LP headings of the article and what's in view. Allow this to be clickable and it shows a dropdown of all sections to easily jump to a section.

Broader Release Requirements
In the subsequent release I want to also start publishing newsletters. These will be PDFs, so i will need to be able to show the first page as thumbnails in the same way posts are displayed (except the content on the card will be the PDF's first page). Make the card portrait in the same ratio as PDF width/height. Once clicked, I would like to launch the browser native PDF viewer. The PDF for now will be stored in `lp_store/newsletters/<issue-name.pdf>`

Please plan and get started on this only after the previous tasks are done and committed.