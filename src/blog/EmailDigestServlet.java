package blog;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.googlecode.objectify.ObjectifyService;

import java.util.*;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@SuppressWarnings("serial")
public class EmailDigestServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
		String msgBody = "Posts within the last 24 hours:\n\n";
		try {
			ObjectifyService.register(Email.class);
			ObjectifyService.register(Post.class);
        	List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();
        	List<Post> recentPosts = new ArrayList<Post>();
        	Collections.sort(posts);
        	Calendar cal;
        	Date date;
        	Date postDate;
        	for (int i = 1; i <= posts.size(); i++) {
        		postDate = posts.get(posts.size() - i).getDate();
        		cal = Calendar.getInstance();
        		cal.add(Calendar.DATE, -1);
        		date = cal.getTime();
        		if (date.before(postDate)) {
        			recentPosts.add(posts.get(posts.size() - i));
        		}
        	}
        	if (!recentPosts.isEmpty()) {
        		for (Post post : recentPosts) {
        			msgBody += post.getHeader() + "\n" + post.getContent() + "\n\n";
        		}
		        List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();
			    Message msg = new MimeMessage(session);
			    msg.setFrom(new InternetAddress("emaildigest@eng-carport-107918.appspotmail.com", "Google App Engine Blog Admin"));
			    for (Email email : emails) {
			    	msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email.getAddress(), ""));
		        }
			    msg.setSubject("Daily Email Digest");
			    msg.setText(msgBody);
			    Transport.send(msg);
        	}
		}
		catch (AddressException e) {
		    e.printStackTrace();
		}
		catch (MessagingException e) {
		    e.printStackTrace();
		}
}

@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}