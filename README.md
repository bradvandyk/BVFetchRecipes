# BVFetchRecipes


TODO:

### Summary: Include screen shots or a video of your app highlighting its features
<img width="568" alt="image" src="https://github.com/user-attachments/assets/805df7b4-b2f7-48e6-b14e-1d442573ebd9" />

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
* completeness
* MVVM
* image caching
* tests
* consistency

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
* ~ 2 weeks 30 mins / day

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
* Focused on reaching completeness. In hindsight would have spent more time with a proper SwiftUI Image caching approach. Right now it converts the images to UIKit UIImage and wonder if a more elegant solution could have been reached
* This also affected testing. Due to how UIImage compression / data saving works, I was not able to compare saving/loading images to be an exact match and instead just ensure that it properly saves something. I commented out the imagesAreEqual part and would revisit with more time

### Weakest Part of the Project: What do you think is the weakest part of your project?
* Image Caching

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
* No, fun exercise and project!
