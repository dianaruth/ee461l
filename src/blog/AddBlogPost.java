package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class AddBlogPost extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	ObjectifyService.register(Post.class);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String heading = req.getParameter("heading");
        String content = req.getParameter("content");
        if (!heading.equals("") && !content.equals("")) {
	        Post post = new Post(user, heading, content);
	        ofy().save().entity(post).now();   // synchronous
	        resp.sendRedirect("/blog.jsp");
        }
        else {
        	resp.sendRedirect("/new_post.jsp");
        }
    }

}