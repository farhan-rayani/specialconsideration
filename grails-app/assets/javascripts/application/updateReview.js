if (typeof jQuery !== 'undefined') {
    (function($) {

    	var regex = /^(.+?)(\d+)$/i;
        
         
    	 $(document).on('change', ':file', function() {
            var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });

        var isValidFileName=(function(){
              var rg1=/^[^\\/:\*\?"<>\|]+$/; // forbidden characters \ / : * ? " < > |
              //var rg1 = /\[a-z_\-\s0-9\.];
              var rg2=/^\./; // cannot start with dot (.)
              var rg3=/^(nul|prn|con|lpt[0-9]|com[0-9])(\.|$)/i; // forbidden file names
              return function isValid(fname){
                return rg1.test(fname);
              }
            });
        
       

	    function clearInputs($element) {
            $element.find('input:text, input:password, input:file, select, textarea caption').val('');
            $element.find('input:radio, input:checkbox')
                .removeAttr('checked').removeAttr('selected');
        }
        
        function slugDefault(filename) {
		    		return filename.replace(/[\~\,\@\`\!\-\[\]\/\{}:;#%=\(\)\*\+\?\\\^\$\|<>&"']/g, '_');
		}             
         
        function downloadFile(indx)
        {
          download(document.getElementById("file"+indx+"data").value,document.getElementById("file"+indx+"name").value,document.getElementById("file"+indx+"mime").value);
        }

    	$(document).ready(function() {
            //var isIE = /*@cc_on!@*/false || !!document.documentMode;
             // Edge 20+
            /*var isEdge = !isIE && !!window.StyleMedia;

            var output = "Is InternetExplorer? " + isIE;

            if (isIE) {
                    $('.downloadFile').css('display', '');
                }
                else
                {
                    $('.viewFile').css('display', '');
                }
            */
            
            $('.downloadFile').bind('click', function() {
                var currElementId = this.id;
                var indx = currElementId[currElementId.length-1];
                var docid = document.getElementById("docID"+indx).value;
                downloadFile(docid);
            });
            var document01FileName = null;
            var document02FileName = null;
            var document03FileName = null;
            //var steppingBack = false
            if (document.getElementById('documentFile1')) 
                document01FileName = document.getElementsByName('documentFile1')[0].getAttribute('data-initial-caption');
            if (document.getElementById('documentFile2')) 
                document02FileName = document.getElementsByName('documentFile2')[0].getAttribute('data-initial-caption');
            if (document.getElementById('documentFile3')) 
                document03FileName = document.getElementsByName('documentFile3')[0].getAttribute('data-initial-caption');
           
           
    		$('#scApplicationReviewForm').submit(function(event){
                event.preventDefault();
            });
            
            $('#askCSULink').click(function () {
		        var src = 'http://student.csu.edu.au/services-support/student-central/askcsu#/article/13531';
			 });
            
            $(document).on("click", ".popover .close" , function(){
                 $(this).parents(".popover").popover('hide');
            });


			$("#documentFile1").fileinput({
                showRemove: true,
            	showPreview: false,
            	showUpload: false, 
                maxFileCount: 1,
                fileSizeGetter: true,
                allowedFileExtensions: ["PDF", "DOC", "DOCX", "JPG", "JPEG", "RTF", "BMP", "PNG"],
                maxFileSize: 5120,
                slugCallback: slugDefault, 
				elErrorContainer: '#fileError0',
                msgSizeTooLarge: "The document you have chosen to upload is more than 5MB. Please reduce the size of the document and try again.", 
                msgInvalidFileExtension: 'Your document has a file extension that we cannot process. Please save the file in an alternative format ({extensions}) and try again.'   
        	});	

			$("#documentFile2").fileinput({
            	showPreview: false,
            	showRemove: true,
            	showUpload: false, 
                maxFileCount: 3,
                fileSizeGetter: true,
                allowedFileExtensions: ["PDF", "DOC", "DOCX", "JPG", "JPEG", "RTF", "BMP", "PNG"],
                maxFileSize: 5120,
                slugCallback: slugDefault, 
				elErrorContainer: '#fileError1',
                msgSizeTooLarge: "The document you have chosen to upload is more than 5MB. Please reduce the size of the document and try again.", 
                msgInvalidFileExtension: 'Your document has a file extension that we cannot process. Please save the file in an alternative format ({extensions}) and try again.'
        	});

        	$("#documentFile3").fileinput({
            	showPreview: false,
            	showRemove: true,
            	showUpload: false,
                maxFileCount: 3,
                fileSizeGetter: true,
                allowedFileExtensions: ["PDF", "DOC", "DOCX", "JPG", "JPEG", "RTF", "BMP", "PNG"],
                maxFileSize: 5120,
                slugCallback: slugDefault, 
				elErrorContainer: '#fileError2',
                msgSizeTooLarge: "The document you have chosen to upload is more than 5MB. Please reduce the size of the document and try again.", 
                msgInvalidFileExtension: 'Your document has a file extension that we cannot process. Please save the file in an alternative format ({extensions}) and try again.'
        	});
            
            

            /*
             * Yes button on Cancel dialog - Return to home.
             */
            $('#cancelAppYes').click(function(event) {
                var form = $('#scApplicationReviewForm');
                var formData = form.data('formValidation');
                var data = form.serialize();
                document.location = $.getBaseUrl();
                
                 $.ajax({
                        type: 'POST',
                        url: 'cancel' + '?param='+ data,
                        cache: false,
                        contentType: false,
                        processData : false,
                        data: data, 
                        beforeSend: function () {
                            $('#saveAppSubmit').attr('disabled', 'disabled');
                           $('#loading').html('<img src="' + $.getBaseUrl() + 'assets/spinner.gif" />');
                        },
                        success: function (data) {
                            if (data.errors === undefined) {
                                console.log("Load tracking page...");
                                // All good
                                document.location = $.getBaseUrl() + 'trackRequest/index';
                                
                            } else {
                                $('#confirmAppModal').modal('toggle');
                                $('#actionResponse').removeClass();
                                $('#actionResponse').addClass('alert alert-danger');
                                $('#actionResponse').text((data.errors !== undefined) ? data.errors.join(", ") : "Unable to cancel your request at this time. Please try again later.");
                                $('#uploadDocuments').removeAttr('disabled');
                                $('#loading').html('');
                            }
                        },
                        error: function (data) {

                        }
                    });

                return false;
            });
          

            $('#uploadDocuments').click(function(event) {
                var form = $('#scApplicationReviewForm');
                var formData = form.data('formValidation');
                var serializedData = $("form").serialize();
                var formData01 = new FormData($("form").get(0));
                var isValid = true;
                
                if(document.getElementById('documentFile1').files[0] == null && document.getElementById('documentFile2').files[0] == null && document.getElementById('documentFile3').files[0] == null)
                {
                    $('#errorAppModal').modal('show');
                    return false;
                }
               
                
                formData01.append('file1', document.getElementById('documentFile1').files[0]);
                formData01.append('file2', document.getElementById('documentFile2').files[0]);
                formData01.append('file3', document.getElementById('documentFile3').files[0]);
                if(document.getElementById('documentFile1').files[0] != null)              
                    formData01.append('fileName1', slugDefault(document.getElementById('documentFile1').files[0].name));
                
                if(document.getElementById('documentFile2').files[0] != null)
                    formData01.append('fileName2', slugDefault(document.getElementById('documentFile2').files[0].name));

                if(document.getElementById('documentFile3').files[0] != null)
                    formData01.append('fileName3', slugDefault(document.getElementById('documentFile3').files[0].name));
                
                // TODO validation

                console.log("Base URL: " + $.getBaseUrl());
                
                if (isValid) {
                    $.ajax({
                        type: 'POST',
                        url: form.attr('action'),
                        cache: false,
                        contentType: false,
                        processData : false,
                        data: formData01,
                        beforeSend: function () {
                            $('#uploadDocuments').attr('disabled', 'disabled');
                            $('#saveAppYes').attr('disabled', 'disabled');
                            $('#saveAppNo').attr('disabled', 'disabled');
                            $('#loading').html('<img src="' + $.getBaseUrl() + 'assets/spinner.gif" />');
                        },
                        success: function (data) {
                            console.log(data);

                            if (data.errors === undefined) {
                                // All good
                                console.log("Load tracking page...");
                                $('#successModal').modal('show');
                                document.location = $.getBaseUrl() + 'trackRequest/index'
                            } else {
                                $('#confirmAppModal').modal('toggle');
                                $('#actionResponse').removeClass();
                                $('#actionResponse').addClass('alert alert-danger');
                                $('#actionResponse').text((data.errors !== undefined) ? data.errors.join(", ") : "Unable to save your request at this time. Please try again later.");
                                $('#uploadDocuments').removeAttr('disabled');
                                $('#loading').html('');
                            }
                        },
                        error: function (data) {
                            console.log("An error occurred while uploading docs " + data.errors);
                        }
                    });
                } else {
                    $('#confirmAppModal').modal('toggle');
                    $('#uploadDocuments').removeAttr('disabled');
                    $('#loading').html('');
                }

                return false;
            });
            
            $("#backToList").on("click", function(e) {
                var mode = document.getElementById('mode').value;
                if(mode == 'edit' && (document01FileName != '' || document02FileName != '' || document03FileName != ''))
                    $('#backToListModal').modal('show');
                else
                    document.location = $.getBaseUrl() + 'trackRequest/index';
            });

            /*
             * abortAction button on move to list dilog
             */
            $('#abortBackToList').click(function(event) {
                return false;
            });

            /*
             * abortAction button on move to list dilog
             */
            $('#abortChanges').click(function(event) {
               document.location = $.getBaseUrl() + 'trackRequest/index';
            });

            $("#addDocument").on("click", function(e) {
                if($('#supportDocument1').is(':hidden')) {
                    $('#supportDocument1').slideDown('fast');
                    $('#tooltip-addDoco').attr('title', '');
                    $(this).attr('disabled', true);
                }
                else
                {   
                    $('#supportDocument2').slideDown('fast');
                    $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "Only the mandatory supporting document plus a maximum of two additional supporting documents can be submitted.")
                      .tooltip('fixTitle');
                    //$('#tooltip-addDoco').tooltip({placement: 'bottom'});
                    $(this).attr('disabled', true);
                };

                $("#removeDocoDiv").removeClass('hidden');
                $("#checkBoxMsg").addClass('hidden');
            });

            $("#removeDocument").on("click", function(e) {
                if(!$('.supportDocument1').is(':hidden') && !$('.supportDocument2').is(':hidden'))
                {
                    $('#documentFile3').fileinput('clear');
                    $('#supportDocument2').slideUp('fast');
                }
                else {
                    $('#documentFile2').fileinput('clear');
                    $('#supportDocument1').slideUp('fast');
                    $("#removeDocoDiv").addClass('hidden');
                }

                if (document02FileName != '' || document.getElementById('documentFile1').value != '')
                {
                     $('#addDocument').removeAttr('disabled');
                     $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "")
                      .tooltip('fixTitle');  
                }
                else
                {
                   $('#tooltip-addDoco').tooltip('hide');
                   $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "To provide an additional supporting document, first select a mandatory supporting document.")
                      .tooltip('fixTitle');
                }
            });


            //File selection management
            $('#documentFile1').on('fileselect', function(event, numFiles, label) {
                
                var file = document.getElementById('documentFile1').files[0];

                if(numFiles > 0 ) 
                {
                    $('#uploadDocuments').removeAttr('disabled');
                    $('#addDocument').removeAttr('disabled');
                    $('#tooltip-addDoco').tooltip('hide').attr('data-original-title', '');                    
                }
                
                document01FileName = label;
                $("#removeDoc01Flag").val('false');
                
            });

           
            $('#documentFile1').on('fileclear', function(event) {
                document01FileName = '';
                $("#removeDoc01Flag").val('true');
            });

            $('#documentFile1').on('filecleared', function(event) {
                $('#addDocument').attr('disabled', 'true');
                $('#uploadDocuments').attr('disabled', 'true');
                if(($('.supportDocument1').is(':hidden') || $('.supportDocument2').is(':hidden'))) 
                {
                    $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "To provide an additional supporting document, first select a mandatory supporting document.")
                      .tooltip('fixTitle');
                }
                $('#tooltip-wrapper').removeClass('spcon-label-disabled');
                $('#tooltip-wrapper').tooltip('hide')
                          .attr('data-original-title', "")
                          .tooltip('fixTitle');
            });

            $('#documentFile1').on('fileerror', function(event, data, msg) {
                document01FileName = '';
                $("#removeDoc01Flag").val('false');
                $('#addDocument').attr('disabled', true);
                $('#uploadDocuments').attr('disabled', true);
                $('#tooltip-wrapper').removeClass('spcon-label-disabled');
                $('#tooltip-wrapper').tooltip('hide')
                          .attr('data-original-title', "")
                          .tooltip('fixTitle');
            });
            
            $('#documentFile2').on('fileerror', function(event, data, msg) {
                document02FileName = '';
                $("#removeDoc02Flag").val('false');
                $('#addDocument').attr("disabled", true);
            });
            $('#documentFile3').on('fileerror', function(event, data, msg) {
                document03FileName = '';
                $("#removeDoc03Flag").val('false');
                $('#addDocument').attr("disabled", true);
            });

             $('#documentFile2').on('fileselect', function(event, numFiles, label) {
                var file = document.getElementById('documentFile2').files[0];
                if (file) {
                    if (document.getElementById('documentFile1').value != '' || document01FileName != '')
                        $('#addDocument').removeAttr('disabled');
                }                 
                document02FileName = label;
                $("#removeDoc02Flag").val('false');           
             });

             $('#documentFile3').on('fileselect', function(event, numFiles, label) {
                var file = document.getElementById('documentFile3').files[0];
                document03FileName = label;
                $("#removeDoc03Flag").val('false');         
             });

             $('#documentFile2').on('fileclear', function(event, numFiles, label) {
                if (document.getElementById('documentFile3').value=='') {
                    $('#documentFile1').fileinput('enable');
                    $('#file-tooltip').removeAttr('data-toggle').removeAttr('data-title').tooltip('destroy');
                }
                document02FileName = '';
                $("#removeDoc02Flag").val('true');
             });
             
             $('#documentFile3').on('fileclear', function(event, numFiles, label) {
                if (document.getElementById('documentFile2').value=='') {
                    $('#documentFile1').fileinput('enable');
                    $('#file-tooltip').removeAttr('data-toggle').removeAttr('data-title').tooltip('destroy');
                }
                 document03FileName = '';
                $("#removeDoc03Flag").val('true');
             });
             
    	}); // End Document.ready()

    })(jQuery);
}
