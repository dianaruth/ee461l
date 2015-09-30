package blog;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.*;

@SuppressWarnings("serial")
public class EmailDigestServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(EmailDigestServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			_logger.info("Cron Job has been executed");

			//Put your logic here
			//BEGIN
			//END
		}
		catch (Exception ex) {
			_logger.info("An exception was thrown");
		}
	}

@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}