# ee461l_blog
## <insert link here>
A Google App Engine Blog implemented using servlets and JSP files, with a Bootstrap frontend.

### Google App Engine
I used the Google App Engine plugin for Eclipse to create a web blog hosted on the Google App Engine. Users, once signed in using the Google Sign-In service, can create new blog posts.

### Front End
The visual appearance of the blog is based on a free Bootstrap theme called "Clean Blog." I thought it would be appropriate to showcase the blog in a classy manner without overtaking the functionality of the blog.

### Objectify
I used the Objectify library to improve the speed and readibility of the servlet.

### Email Digest
The blog uses a Cron job to allow users to subscribe or unsubscribe to a daily post digest email that details the posts that have been created since the previous day.
