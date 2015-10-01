package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.googlecode.objectify.ObjectifyService;

public class Subscribe extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	ObjectifyService.register(Email.class);
        String address = req.getParameter("email");
        Email email = new Email(address);
        ofy().save().entity(email).now();   // synchronous
        resp.sendRedirect("/blog.jsp");
    }

}