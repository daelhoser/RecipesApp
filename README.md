#  RecipeApp

### Summary: Include screen shots or a video of your app highlighting its features

https://github.com/user-attachments/assets/0cbae946-def8-47f7-a243-60d63780fc2f

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I decided to focus more on setting up the the Clean architecture and writing Soft code with minimal lines of code, and minimal dependencies, making the app easy to test and debug. I also focused on writing tests for one of the most important parts of the app, the repository, since the core of the app is fetching data remotely

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spent approximately 4.5 hours, on and off spread out through 3 days. Please take a look at my commits to see, a little more detailed, how i spent time working on the project. I always try to make my commits small (although sometimes i get out of hand), to make my PRs a little easier to handle. 

Time Allocation:
1. Gathering the requirements and thinking about my process of attack: ~20-30 min. Probably more than I should but i wanted to prioritize showing clean code without overengineering theh application.
2. TDD on the RecipeRepository: ~1hr - I spent approximately one hour since i had to work a few minutes here and there i needed a bit of time to see my current progress and what needed to be done next
3. Setting up the Structure and writing and FetchRecipes UseCase:  ~1 hr
4. Recipes UI including ViewModel, UseCase and using the Repository. Includes debugging ~30min
5. Setting up my dependency container: ~20 min
6. Image Caching ~30 min
7. Debugging and making sure i met my requirements: ~15


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

I took some time trying to decide whether i can inject my cache and image repository to the ImageView using environment object to utilize SwiftUIs feature and i think that would've been the correct choice if i were writing my ImageView as a cache. However, since i just wanted to meet my requirements i didn't need to make this a SwiftUI reusable component (ie CachedImage) and felt i didn't need to inject the componenets using Environment Object. Instead i went with creating a ViewModel (which can also be used for formatting text if needed), UseCase etc.

### Weakest Part of the Project: What do you think is the weakest part of your project?

I'd say the Views are my weakest part. I focused too much on setting up a good structure that i lost track of time on getting project done in a reasonable amount of time.  

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

Overall, this is a great project to test an individuals knowledge. We often use third party helpers (regardless of within or outside the company) to speed up development process, which is great but it also limits our creativity at times. I've been using a third party helper to download and cache our images. For that reason, it took me a while to figure out a 'clean' way of downloading and caching images (the entire feature). I don't feel 100% happy with my process but am glad i wrote it cleanly in case i need to make changes. 
