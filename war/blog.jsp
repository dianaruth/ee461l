<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="blog.Post" %>
<%@ page import="blog.Email" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Google App Engine Blog - Diana Ruth</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/clean-blog.min.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href='http://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-custom navbar-fixed-top">
        <div class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header page-scroll">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <a href="blog.jsp">Home</a>
                    </li>
                    <li>
                        <a href="posts.jsp">Posts</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <!-- Page Header -->
    <!-- Set your background image for this header on the line below. -->
    <header class="intro-header" style="background-image: url('img/home-bg.jpg')">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
                    <div class="site-heading">
                        <h1>Google App Engine Blog</h1>
                        <hr class="small">
                        <span class="subheading">created by Diana Ruth</span>
                        <br>
                        <span class="subheading">
                        	<%
    						UserService userService = UserServiceFactory.getUserService();
    						User user = userService.getCurrentUser();
    						if (user != null) {
      							pageContext.setAttribute("user", user);
							%>
							Hello, ${fn:escapeXml(user.nickname)}! (You can
							<a style="color: #66CCFF" href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)
							<%
							}
    						else {
							%>
							Hello! <a style="color: #66CCFF" href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> to make new posts.
							<%
							}
							%>
							<%
							if (user != null) {
								ObjectifyService.register(Email.class);
				            	List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();
				            	boolean contains = false;
				            	for (Email email : emails) {
				            		String name = user.getEmail();
				            		if (email.getAddress().equals(name)) {
				            			contains = true;
				            			break;
				            		}
				            	}
				            	if (contains) { %>
				            		<br><br>
				            		Click below to unsubscribe to the email list.<br><br><form action="unsubscribe" method="post"><input type="hidden" name="email" value="${fn:escapeXml(user.email)}"><input style="width: 170px;" class="btn btn-primary" type="submit" value="Unsubscribe"/></form>
				            	<%
				            	}
				            	else {
				            	%>
				            		<br><br>
									Click below to subscribe to the email list and receive daily email digests of recent posts.<br><br><form action="subscribe" method="post"><input type="hidden" name="email" value="${fn:escapeXml(user.email)}"><input style="width: 150px;" class="btn btn-primary" type="submit" value="Subscribe"/></form>
								<%
								}
							}
							%>     	
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
            	<%
            	ObjectifyService.register(Post.class);
            	List<Post> posts = ObjectifyService.ofy().load().type(Post.class).list();   
            	Collections.sort(posts);
            	if (posts.size() >= 5) {
            		for (int i = 1; i <= 5; i++) {
            			pageContext.setAttribute("post_header", posts.get(posts.size() - i).getHeader());
            			pageContext.setAttribute("post_content", posts.get(posts.size() - i).getContent());
            			pageContext.setAttribute("post_user", posts.get(posts.size() - i).getUser());
            			pageContext.setAttribute("post_date", posts.get(posts.size() - i).getDate());
            	%>
                <div class="post-preview">
                    <a href="posts.jsp">
                        <h2 class="post-title">
                            ${fn:escapeXml(post_header)}
                        </h2>
                        <p>
                            ${fn:escapeXml(post_content)}
                        </p>
                    </a>
                    <p class="post-meta">Posted by ${fn:escapeXml(post_user.nickname)} on ${fn:escapeXml(post_date)}</p>
                </div>
                <%
            		}
            	}
            	else {
            		for (int i = 1; i <= posts.size(); i++) {
            			pageContext.setAttribute("post_header", posts.get(posts.size() - i).getHeader());
            			pageContext.setAttribute("post_content", posts.get(posts.size() - i).getContent());
            			pageContext.setAttribute("post_user", posts.get(posts.size() - i).getUser());
            			pageContext.setAttribute("post_date", posts.get(posts.size() - i).getDate());
            	%>
            	<div class="post-preview">
                    <a href="posts.jsp">
                        <h2 class="post-title">
                            ${fn:escapeXml(post_header)}
                        </h2>
                        <p>
                            ${fn:escapeXml(post_content)}
                        </p>
                    </a>
                    <p class="post-meta">Posted by ${fn:escapeXml(post_user.nickname)} on ${fn:escapeXml(post_date)}</p>
                </div>
            	<%
            		}
            	}
            	%>
                <hr>
                <!-- Pager -->
                <ul class="pager">
                    <li class="next">
                        <a href="posts.jsp">View All Posts &rarr;</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <hr>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
                    <ul class="list-inline text-center">
                        <li>
                            <a href="https://www.youtube.com/channel/UCDv_zt5mQC0mGGY-8wS9YxA" target="blank">
                                <span class="fa-stack fa-lg">
                                    <i class="fa fa-circle fa-stack-2x"></i>
                                    <i class="fa fa-youtube fa-stack-1x fa-inverse"></i>
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="https://www.facebook.com/diana.ruth.16" target="blank">
                                <span class="fa-stack fa-lg">
                                    <i class="fa fa-circle fa-stack-2x"></i>
                                    <i class="fa fa-facebook fa-stack-1x fa-inverse"></i>
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/dianaruth" target="blank">
                                <span class="fa-stack fa-lg">
                                    <i class="fa fa-circle fa-stack-2x"></i>
                                    <i class="fa fa-github fa-stack-1x fa-inverse"></i>
                                </span>
                            </a>
                        </li>
                    </ul>
                    <p class="copyright text-muted">Copyright &copy; Diana Ruth 2015</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="js/clean-blog.min.js"></script>

</body>

</html>
