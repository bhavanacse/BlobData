package blobdata;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class ServeBlobServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	@Override
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws IOException {
            BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
            String fname = req.getParameter("filename");
            
            res.setContentType("application/x-download");
            
            res.setHeader("Content-Disposition", "attachment; filename=" + fname);
            res.setHeader("Content-Type", "text/plain");
            res.setHeader("Content-Encoding", "gzip");
            
            blobstoreService.serve(blobKey, res);
        }
    }
