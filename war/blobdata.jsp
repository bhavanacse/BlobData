<%@page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilter" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>

<% 
  BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService(); 
%>

<html>
  <head>
    <title>Upload and Download Page</title>
  </head>

  <body BGCOLOR="#000000" TEXT="#FFFF00" LINK="#FF0000" VLINK="#FFFFFF" ALINK="#00FF00">

<%
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
      
  	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
  	Key rootKey = KeyFactory.createKey("BlobSpace", "root");
%>

<p>Hello <%=user.getNickname()%>!!!!!! (You have signed in. You can click on
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a> for signing out.)</p><br> 
<h2 style="background-color:gray;">Below are the sections to upload and download files</h2>
	<h2 style="background-color:purple;"> Upload Section: </h2>
        <form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data" onsubmit="return checkImageFileExistence();">
          
          	<h3> Image </h3>
          	<h6 style="color:White">Note: Supports jpg, gif, png, bmp, jpeg files</h6>
            Image: <input type="file" name="imageName" id = "imageFileNameId">
            <input type="submit" value="Upload Image">
            
        </form>
        <br>
        <form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data" onsubmit="return checkAudioFileExistence();">
            
            <h3> Audio </h3>
            <h6 style="color:White">Note: Supports mp3, mmf, wma, msv, dvf files</h6>
            Audio: <input type="file" name="audioName" id = "audioFileNameId">
            <input type="submit" value="Upload Audio"> 
            
        </form>
        <br>
        <form action="<%= blobstoreService.createUploadUrl("/upload") %>" method="post" enctype="multipart/form-data" onsubmit="return checkVideoFileExistence();">
            
            <h3> Video </h3>
            <h6 style="color:White">Note: Supports m4v, avi, mpg, mp4, 3gp files</h6>
            Video: <input type="file" name="videoName" id = "videoFileNameId">
            <input type="submit" value="Upload Video"> 
            
        </form>
        <br>
        <br>
        <br>
        <h2 style="background-color:purple;">Download Section:</h2>
        <h6 style="color:White">Note: Click on a specific file to download. Non-visited links will be shown in "Red" color and Visited will be in "White" color.</h6>
        
        <form>
        	
        	<h3>List of Image Files</h3>
        	
        	<%
        	    // Run an ancestor query to ensure we see the most up-to-date
			    // view of the Blobs belonging to the tagname "imageName".
			    Query imageQuery = new Query("BlobSpace", rootKey).addFilter("tagname", Query.FilterOperator.EQUAL, "imageName");
			    List<Entity> imageBlobs = datastore.prepare(imageQuery).asList(FetchOptions.Builder.withLimit(10));
				
			    if (imageBlobs.size() == 0) {
			    	%>
			        <p style="color:red">Image Store has no images.</p>
			        <%
			    } else {
			        for (Entity imageBlob : imageBlobs) {
			        	if (imageBlob.getProperty("blobsize") != null && imageBlob.getProperty("filename") != null && (((User)imageBlob.getProperty("user")).getNickname()).equals(user.getNickname())) {
			                
			  				String imageName = imageBlob.getProperty("filename").toString();
			  				
			  				%>
			  				<a href = "/serve?blob-key= <%= ((BlobKey)imageBlob.getProperty("blobkey")).getKeyString() %>&amp;filename=<%=imageName %>" >
								<%= imageName %><br>
							</a> 
			  				<%
			            }
			        }
			    }
			%>
        </form>
        <br>
        <form>
        	
        	<h3>List of Audio Files</h3>
        	
        	<%
        		// Run an ancestor query to ensure we see the most up-to-date
			    // view of the Blobs belonging to the tagname "audioName".
			    Query audioQuery = new Query("BlobSpace", rootKey).addFilter("tagname", Query.FilterOperator.EQUAL, "audioName");
			    List<Entity> audioBlobs = datastore.prepare(audioQuery).asList(FetchOptions.Builder.withLimit(10));
				
			    if (audioBlobs.size() == 0) {
			    	%>
			        <p style="color:red">Audio Store has no audio files.</p>
			        <%
			    } else {
			        for (Entity audioBlob : audioBlobs) {
			            if (audioBlob.getProperty("blobsize") != null && audioBlob.getProperty("filename") != null && (((User)audioBlob.getProperty("user")).getNickname()).equals(user.getNickname())) {
			                
			  				String audioFileName = audioBlob.getProperty("filename").toString();
			  				
			  				%>
			  				<a href = "/serve?blob-key= <%= ((BlobKey)audioBlob.getProperty("blobkey")).getKeyString() %>&amp;filename=<%=audioFileName %>" >
			  					<%= audioFileName %><br>
		  					</a> 
			  				<%
			            }
			        }
			    }
			%>
        </form>
        <br>
        <form>
        	
        	<h3>List of Video Files</h3>
        	
        	<%
        		// Run an ancestor query to ensure we see the most up-to-date
			    // view of the Blobs belonging to the tagname "videoName".
			    Query videoQuery = new Query("BlobSpace", rootKey).addFilter("tagname", Query.FilterOperator.EQUAL, "videoName");
			    List<Entity> videoBlobs = datastore.prepare(videoQuery).asList(FetchOptions.Builder.withLimit(10));
				
			    if (videoBlobs.size() == 0) {
			    	%>
			        <p style="color:red">Video Store has no video files.</p>
			        <%
			    } else {
			        for (Entity videoBlob : videoBlobs) {
			            if (videoBlob.getProperty("blobsize") != null && videoBlob.getProperty("filename") != null && (((User)videoBlob.getProperty("user")).getNickname()).equals(user.getNickname())) {
			                
			  				String videoFileName = videoBlob.getProperty("filename").toString();
			  				
			  				%>
			  				<a href = "/serve?blob-key= <%= ((BlobKey)videoBlob.getProperty("blobkey")).getKeyString() %>&amp;filename=<%=videoFileName %>" >
			  					<%= videoFileName %><br>
		  					</a> 
			  				<%
			            }
			        }
			    }
			%>
        </form>
        
        
                
<%
    } else {
%>

<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to upload and download your files.</p>

<%
    }
%>
  
  </body>
</html>
<script type="text/javascript">
	function checkImageFileExistence(){
	  fn = document.getElementById('imageFileNameId').value;
	  if(fn == ""){
	  	alert("Please select an image file.");
	  	return false;
	  }
	  else {
	  	if (isImage(fn)) {
	  		return true;
	  		}
	  	else{
	  		return false;
	  		}	
	  }
	};
	
	function checkAudioFileExistence(){
	  fn = document.getElementById('audioFileNameId').value;
	  if(fn == ""){
	  	alert("Please select an audio file.");
	  	return false;
	  }
	  else {
	  	if (isAudio(fn)) {
	  		return true;
	  		}
	  	else{
	  		return false;
	  		}	
	  }
	};
	
	function checkVideoFileExistence(){
	  fn = document.getElementById('videoFileNameId').value;
	  if(fn == ""){
	  	alert("Please select a video file.");
	  	return false;
	  }
	  else {
	  	if (isVideo(fn)) {
	  		return true;
	  		}
	  	else{
	  		return false;
	  		}	
	  }
	};
	
function getExtension(filename) {
    var parts = filename.split('.');
    return parts[parts.length - 1];
};

function isImage(filename) {
    var ext = getExtension(filename);
    switch (ext.toLowerCase()) {
    case 'jpg':
    case 'gif':
    case 'bmp':
    case 'png':
    case 'jpeg':
        
        return true;
    }
    alert("Please provide a valid image formatted file.");
    return false;
};

function isAudio(filename) {
    var ext = getExtension(filename);
    switch (ext.toLowerCase()) {
    case 'mp3':
    case 'mmf':
    case 'wma':
    case 'msv':
    case 'dvf':
        
        return true;
    }
    alert("Please provide a valid audio file.");
    return false;
};

function isVideo(filename) {
    var ext = getExtension(filename);
    switch (ext.toLowerCase()) {
    case 'm4v':
    case 'avi':
    case 'mpg':
    case 'mp4':
    case '3gp':
        
        return true;
    }
    alert("Please provide a valid video file.");
    return false;
};
		
</script>


      