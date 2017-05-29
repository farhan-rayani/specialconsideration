if (typeof jQuery !== 'undefined') {
    (function($) {
    	/*$(function(){
		    resizeCanvas();
		});

		$(window).on('resize', function(){
		    resizeCanvas();
		});

		function resizeCanvas()
		{
		    var canvas = $('#canvas');
		    canvas.css("width", $(window).width());
		    canvas.css("height", $(window).height());
		}
		*/
		

    	$(document).ready(function() {
             
	         $(".nav").hide();
	         var mimeType = document.getElementById('mimeType').value;
	         console.log("mimeType = " + mimeType);
	         if(mimeType == 'application/pdf')
	         {
	             var pdfData = atob(document.getElementById('filedata').value);
	             var pageNum = 1
	             var totalpages = 0
	             PDFJS.workerSrc = '/assets/pdfjs/pdf.worker.js';
	             var pdfDoc = PDFJS.getDocument({data: pdfData});
	             //PDFJS.disableWorker = true;
	    		// If absolute URL from the remote server is provided, configure the CORS
	    		
	    		pdfDoc.promise.then(function(pdf) {
				  console.log('PDF loaded');
				  document.getElementById('page_count').textContent = pdf.numPages;
				  totalpages = pdf.numPages;
				  if (totalpages > 1) 
				  	$('#pagination').removeAttr('style');
				  renderPage(pdf, 1);
				}, function (reason) {
				  // PDF loading error
				  console.error(reason);
				});

	    		function renderPage(pdf,pageNumber) {
	    			pdf.getPage(pageNumber).then(function(page) {
					    console.log('Page loaded');
					    
					    var scale = 1.5;
					    var viewport = page.getViewport(scale);

					    // Prepare canvas using PDF page dimensions
					    var canvas = document.getElementById('canvas');
					    var context = canvas.getContext('2d');
					    canvas.height = viewport.height;
					    canvas.width = viewport.width;

					    // Render PDF page into canvas context
					    var renderContext = {
					      canvasContext: context,
					      viewport: viewport
					    };
					    var renderTask = page.render(renderContext);
					    renderTask.then(function () {
					      console.log('Page rendered');
					    });
					  });
	    			document.getElementById('page_num').textContent = pageNumber;
				  };

				  /**
			 * Displays previous page.
			 */
			
			$("#prev").on("click", function(event) {
	                
	          if (pageNum <= 1) {
			    return;
			  }
			  $('#next').removeClass('disabled');
			  pageNum--;
			  if (pageNum <= 1)
			  $('#prev').addClass('disabled');
			  pdfDoc.promise.then(function(pdf) {
				  console.log('PDF loaded');
				  renderPage(pdf, pageNum);
				}, function (reason) {
				  // PDF loading error
				  console.error(reason);
				});
			  event.preventDefault();
			});

			

			/**
			 * Displays next page.
			 */
			
			$("#next").on("click", function(event) {
	         if (pageNum >= totalpages) {
			    return;
			  }
			  $('#prev').removeClass('disabled');
			  pageNum++;
			  if (pageNum >= totalpages)
			  $('#next').addClass('disabled');
			  pdfDoc.promise.then(function(pdf) {
				  console.log('PDF loaded');
				  renderPage(pdf, pageNum);
				}, function (reason) {
				  // PDF loading error
				  console.error(reason);
				});
			  	event.preventDefault();
			});
		} //for PDF docs

		//for images
		if (mimeType == 'image/png' || mimeType == 'image/jpeg' || mimeType == 'image/jpg' || mimeType == 'image/tif' || mimeType == 'image/tiff' 
			|| mimeType == 'image/bmp') 
		{
			var canvas = document.getElementById("canvas");
			var ctx = canvas.getContext("2d");
			var BASE64Data = ''
			var image = new Image();
			ctx.canvas.width  = window.innerWidth;
  			ctx.canvas.height = window.innerHeight;
			image.onload = function() {
			    ctx.drawImage(image, 0, 0, image.width,    image.height, 0, 0, canvas.width, canvas.height);
			};
			if (mimeType == 'image/png') 
				BASE64Data = "data:image/png;base64,"
			if (mimeType == 'image/jpeg' || mimeType == 'image/jpg') 
				BASE64Data = "data:image/jpeg;base64,"
			if (mimeType == 'image/tif' || mimeType == 'image/tiff') 
				BASE64Data = "data:image/tiff;base64,"
			if (mimeType == 'image/bmp') 
				BASE64Data = "data:image/bmp;base64,"
			BASE64Data = BASE64Data + document.getElementById("filedata").value;
			image.src = BASE64Data;
		}

    	}); // End Document.ready()

    })(jQuery);
}
