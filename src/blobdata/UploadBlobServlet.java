package blobdata;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobInfo;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


public class UploadBlobServlet extends HttpServlet{
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	    @Override
	    public void doPost(HttpServletRequest req, HttpServletResponse res)
	        throws ServletException, IOException {
	    	
	    	UserService userService = UserServiceFactory.getUserService();
	        User user = userService.getCurrentUser();
	        
	        // We have one entity group per BlobData with all Uploaded Blobs residing
	        // in the same entity group as the BlobData to which they belong.
	        // This lets us run an ancestor query to retrieve all
	        // Blobs for a given BlobData.  However, the write rate to each
	        // BlobData should be limited to ~1/second.

	        Key rootKey = KeyFactory.createKey("BlobSpace", "root");
	        Entity uploadingBlob = new Entity("BlobSpace", rootKey);

    	    res.setContentType("text/html");
    	    PrintWriter out = res.getWriter();
    	    out.append("Below file has been uploaded successfully.");
	    	  
	        Map<String,List<BlobInfo>> blobInfo = blobstoreService.getBlobInfos(req);
	        
	        java.util.Iterator<Entry<String, List<BlobInfo>>> entries = blobInfo.entrySet().iterator();
			while (entries.hasNext()) {

				Entry<String, List<BlobInfo>> thisEntry = entries.next();
				
				String tagName = thisEntry.getKey();
				List<BlobInfo> blobInfos = thisEntry.getValue();

				java.util.Iterator<BlobInfo> it = blobInfos.iterator();
				while (it.hasNext()) {
					BlobInfo currentBlobInfo = it.next();
					String fn = currentBlobInfo.getFilename();
					BlobKey currentBlobKey = currentBlobInfo.getBlobKey();
					long blobSize = currentBlobInfo.getSize();
					
					out.append(" <pre>" + fn + "</pre>");
					uploadingBlob.setProperty("user", user);
					uploadingBlob.setProperty("filename", fn);
					uploadingBlob.setProperty("tagname", tagName);
					uploadingBlob.setProperty("blobkey", currentBlobKey);
					uploadingBlob.setProperty("blobsize", blobSize);
					
			        datastore.put(uploadingBlob);
				}
			}
				out.append("Click ");
	            out.append("<a href='/blobdata.jsp'>Home</a>");
	            out.append(" to navigate to home page");		
		        out.close();
		        
	    }

}



