if (typeof jQuery !== 'undefined') {
    var formChanged = false;
    var steppingBack = false;
    var regex = /^(.+?)(\d+)$/i;
    (function($) {   	
        var formSubmitting = false;
        var setFormSubmitting = function() { formSubmitting = true; };

        window.onload = function() {

            console.log("****** formChanged = " + formChanged);
             // add class to the parent tag on focus event on file input
            // remove the class from the parent tag on focus out event
            
            if($("#fragment").val() == "suppDocs") {
                $('#documentFile1').focus();
                $('#documentFile1').parent().addClass("file-focus");
            }
            
            $( "input:file" ).focus( function() {
                $(this).parent().addClass("file-focus");
            }).focusout( function() {
                $(this).parent().removeClass("file-focus");
            });
            
            window.addEventListener("beforeunload", function (e) {
                var confirmationMessage = "Changes you made may not be saved";
                if(formChanged)
                {
                    var confirmationMessage = "Changes you made may not be saved";
                    if (formSubmitting) 
                        return undefined;
                    
                    (e || window.event).returnValue = confirmationMessage; //Gecko + IE
                    e.returnValue = confirmationMessage;
                    return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
                }
                else
                {
                   
                        console.log("Load Previous page...GUID" + document.getElementById('guid').value);
                        if(skipStep2a == "true"){
                            document.location = $.getBaseUrl() + 'application/editSubjects?guid=' + document.getElementById('guid').value + 
                            '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                             '&_t='+ (new Date()).getTime();
                        }
                        else{
                                document.location = $.getBaseUrl() + 'application/editReason?guid=' + document.getElementById('guid').value + 
                            '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                             '&_t='+ (new Date()).getTime();  
                        }
                   
                }
                });
        };
         document.addEventListener("DOMContentLoaded", function(event) {
            
            var document01FileName = document.getElementsByName('documentFile1')[0].getAttribute('data-initial-caption');
            if (document01FileName != '') {
                        $('#supportDocument0 div.file-input').removeClass('file-input-new');
            }

            //scroll to the supporting documents section if the user has selected the 'Modify' link from the Review page under the supporting documents label
            var fragmentVal = document.getElementById('fragment').value;
             if (fragmentVal != '') {
                   //window.location.href = "#"+fragment;
                   $(document).scrollTop( $("#"+fragmentVal).offset().top );
                }
            //update the total chars for the reason desc
            var countfield = document.getElementById('counter');
            var reasonDesc = document.getElementById('descriptionText');
            countfield.innerHTML = reasonDesc.value.length + '/500';
            });
         
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
        
        $(document).on('paste', "#descriptionText", function()
           {
               setTimeout(function()
               { 
                  //get the value of the input text
                  var data= $( '#descriptionText' ).val() ;
                  //replace the special characters to '' 
                  //var dataFull = data.replace(/[^\w\s()\[\]]/gi, '');
                  var dataFull = data.replace(/[^\x20-\x7E]+/g, '');
                  //set the new value of the input text without special characters
                  $( '#descriptionText' ).val(dataFull);
               });
               formChanged = true;
            });


        function textCounter(field,field2,maxlimit)
        {
         var countfield = document.getElementById(field2);
         if ( field.value.length > maxlimit ) {
          field.value = field.value.substring( 0, maxlimit );
          return false;
         } else {
          countfield.innerHTML = field.value.length + '/' + maxlimit;
         }
        }

	    function clearInputs($element) {
            $element.find('input:text, input:password, input:file, select, textarea caption').val('');
            $element.find('input:radio, input:checkbox')
                .removeAttr('checked').removeAttr('selected');
        }
        
        function slugDefault(filename) {
		    		return filename.replace(/[\~\,\@\`\!\-\[\]\/\{}:;#%=\(\)\*\+\?\\\^\$\|<>&"']/g, '_');
		}      

       var reasonValidators = {
            validators: {
                notEmpty: {
                    message: 'Please select the main reason for your request'
                }
            }
        },
        reasonDetailValidators = {
            validators: {
                notEmpty: {
                    message: 'Please provide details of the reason for your request'
                }
            }
        },
        fileUploadValidators = {
            validators: {
                notEmpty: {
                    message: 'Please provide the mandatory supporting document or select the check box below to provide the mandatory supporting document later.'
                }
            }
        };

        
         

    	$(document).ready(function() {

    		/* Setting focus */
    		if($("#fragment").val() != "suppDocs"){
    			$('#descriptionText').focus();
    		}
    		
    		$('.modal').on('hidden.bs.modal', function (e) {
    			focusHasError();
        	});   
    		
            //$('#tooltip-addDoco').attr('data-toggle', 'tooltip').attr('data-original-title', 'To provide an additional supporting document, first select a mandatory supporting document.');
            $('#tooltip-addDoco').tooltip({placement: 'bottom'});
            var document01FileName = document.getElementsByName('documentFile1')[0].getAttribute('data-initial-caption');
            
            
            var isValidData = null;

            $("#descriptionText").on("keyup", function(e) {
                textCounter(this,'counter',500);
                formChanged = true;
            });
           
    		$('#scApplicationReasonForm').submit(function(event){
                event.preventDefault();
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

			
            $('#scApplicationReasonForm').formValidation({
                framework: 'bootstrap',
                icon: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    descText: reasonDetailValidators 
                },
                excluded: ['disabled', 'hidden'] 

            });

            

            /*
             * Yes button on Cancel dialog - Return to home.
             */
            $('#cancelAppYes').click(function(event) {
                var form = $('#scApplicationReasonForm');
                var formData = form.data('formValidation');
                var data = form.serialize();
                document.location = $.getBaseUrl();
                setFormSubmitting();
                 $.ajax({
                        type: 'POST',
                        url: 'delete' + '?param='+ data,
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
                                
                                // All good
                                //document.location = $.getBaseUrl() + 'application/index';
                                //console.log("Load next page...");
                            } else {
                                $('#confirmAppModal').modal('toggle');
                                $('#actionResponse').removeClass();
                                $('#actionResponse').addClass('alert alert-danger');
                                $('#actionResponse').text((data.errors !== undefined) ? data.errors.join(", ") : "Unable to delete your request at this time. Please try again later.");
                                $('#saveNextApp').removeAttr('disabled');
                                $('#loading').html('');
                            }
                        },
                        error: function (data) {

                        }
                    });

                return false;
            });

           
            $('#stepBack').click(function(event) {
                steppingBack = true;
                
                var descriptionText = document.getElementById('descriptionText').value;
                var skipStep2a = $('#skipStep2a').val()
                //if user hasn't made any changes in the current page and decides to step back to page 1, simply redirect as there is nothing to validate\save
                if (steppingBack && descriptionText == '') {
                    console.log("Load Previous page...GUID" + document.getElementById('guid').value);
                    if(skipStep2a == "true"){
                    	document.location = $.getBaseUrl() + 'application/editSubjects?guid=' + document.getElementById('guid').value + 
		                '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
		                 '&_t='+ (new Date()).getTime();
                    }
                    else{
		                    document.location = $.getBaseUrl() + 'application/editReason?guid=' + document.getElementById('guid').value + 
		                '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
		                 '&_t='+ (new Date()).getTime();  
                    }
                }
                else
                $('#saveNextApp').trigger("click");
                if (!isValidData) 
                {
                    isValidData = null;
                    return false;
                }

            });

            $('#saveNextApp').click(function(event) {
                var form = $('#scApplicationReasonForm');
                var formData = form.data('formValidation');
                var serializedData = $("form").serialize();
                var formData01 = new FormData($("form").get(0));
                var skipStep2a = $('#skipStep2a').val()
                
                var isValid = null;
                setFormSubmitting();
                formData.validate();
                isValid = formData.isValid();

                //if steping back to step 1 and there are invalid data, return from here
                if (steppingBack && !isValid) {
                    isValidData = isValid;
                    steppingBack = false;
                    focusHasError();
                    return false;
                }
                
                
                console.log(" valid data? "+ isValid);
                formData01.append('file1', document.getElementById('documentFile1').files[0]);
                
                if(document.getElementById('documentFile1').files[0] != null)              
                    formData01.append('fileName1', slugDefault(document.getElementById('documentFile1').files[0].name));
                
                
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
                            $('#saveNextApp').attr('disabled', 'disabled');
                            $('#saveAppYes').attr('disabled', 'disabled');
                            $('#saveAppNo').attr('disabled', 'disabled');
                            $('#loading').html('<img src="' + $.getBaseUrl() + 'assets/spinner.gif" />');
                        },
                        success: function (data) {
                            console.log(data);

                            if (data.errors === undefined) {
                                // All good
                                
                                if (!steppingBack) {
                                	 var fromStep2b = "true"
                                	 if(skipStep2a == "true"){
                                		 fromStep2b = "false"
                                	 }
                                    document.location = $.getBaseUrl() + 'application/review?guid=' + data.guid + 
                                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                                     '&_t='+ (new Date()).getTime()+ '&fromStep2b='+fromStep2b+ '&skipStep2a='+skipStep2a;
                                    console.log("Load next page...GUID" + data.guid);
                                }
                                else 
                                    {
                                		if(skipStep2a == "true"){
	                                        console.log("Load Previous page...GUID" + data.guid);
	                                        document.location = $.getBaseUrl() + 'application/editSubjects?guid=' + data.guid + 
	                                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
	                                     '&_t='+ (new Date()).getTime();   
	                                	}
                                		else{
                                			console.log("Load Previous page...GUID" + data.guid);
	                                        document.location = $.getBaseUrl() + 'application/editReason?guid=' + data.guid + 
	                                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
	                                     '&_t='+ (new Date()).getTime();   
                                		}
                                    }
                                    
                            } else {
                                $('#confirmAppModal').modal('toggle');
                                $('#actionResponse').removeClass();
                                $('#actionResponse').addClass('alert alert-danger');
                                $('#actionResponse').text((data.errors !== undefined) ? data.errors.join(", ") : "Unable to save your request at this time. Please try again later.");
                                $('#saveNextApp').removeAttr('disabled');
                                $('#loading').html('');
                            }
                        },
                        error: function (data) {
                            
                        }
                    });
                } else {
                    steppingBack = false;
                    $('#confirmAppModal').modal('toggle');
                    console.log("There are errors on the form. Please complete the required fields.");
                    $('#saveNextApp').removeAttr('disabled');
                    $('#loading').html('');
                }

                return false;
            });

            //File selection management
            $('#documentFile1').on('fileselect', function(event, numFiles, label) {
                var file = document.getElementById('documentFile1').files[0];
                document01FileName = label;
                $("#removeDoc01Flag").val('false');
                formChanged = true;
            });

           
            $('#documentFile1').on('fileclear', function(event) {
                document01FileName = '';
                $("#removeDoc01Flag").val('true');
                formChanged = true;
            });

           

            $('#documentFile1').on('fileerror', function(event, data, msg) {
                document01FileName = '';
                $("#removeDoc01Flag").val('false');
                formChanged = true;
            });
            
          
    	}); // End Document.ready()

    })(jQuery);
}

function focusHasError(){
	$(".has-error:first select:first").focus();
	if(!$(".has-error:first select:first").is(":focus")){
		$(".has-error:first textarea").focus();
	}
}