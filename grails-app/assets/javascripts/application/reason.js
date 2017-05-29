if (typeof jQuery !== 'undefined') {
    
    var formChanged = false;
    
    (function($) {
    	var formSubmitting = false;
        var setFormSubmitting = function() { formSubmitting = true; };

        window.onload = function() {
            console.log("formChanged : " + formChanged);
            
            if($("#fragment").val() == "suppDocs") {
                $('#documentFile1').focus();
                $('#documentFile1').parent().addClass("file-focus");
            }
            // add class to the parent tag on focus event on file input
            // remove the class from the parent tag on focus out event
            $( "input:file" ).focus( function() {
                $(this).parent().addClass("file-focus");
            }).focusout( function() {
                $(this).parent().removeClass("file-focus");
            });
            
            window.addEventListener("beforeunload", function (e) {
                var guid = document.getElementById('guid').value;
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
                    //$( "#stepBack" ).trigger( "click" );
                    console.log("Load Previous page...GUID" + guid);
                    document.location = $.getBaseUrl() + 'application/editSubjects?guid=' + guid + 
                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                     '&_t='+ (new Date()).getTime();  
                }
            });
            
        };
    	var regex = /^(.+?)(\d+)$/i;
         document.addEventListener("DOMContentLoaded", function(event) {
            var selectedReason = document.getElementById('reasonType').value;
            var document01FileName = document.getElementsByName('documentFile1')[0].getAttribute('data-initial-caption');
            var document02FileName = document.getElementsByName('documentFile2')[0].getAttribute('data-initial-caption');
            var document03FileName = document.getElementsByName('documentFile3')[0].getAttribute('data-initial-caption');
            showReasonText(selectedReason);
                var fileInputs = document.getElementsByClassName('file-input');
                
                for (var i = 0; i < fileInputs.length; i++) {
                    if (document01FileName != '') 
                    {
                        $('#supportDocument0 div.file-input').removeClass('file-input-new');
                        $('#supportDocLater').attr('disabled', true);
                    }
                    if (document02FileName != '') 
                        $('#supportDocument1 div.file-input').removeClass('file-input-new');
                    if (document03FileName != '') 
                        $('#supportDocument2 div.file-input').removeClass('file-input-new');
                }
                
                changeTooltipForSupportingDocuments();

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

		// Change on-screen text based on Reason Type
        $(document).on('change', '#reasonType', function(e) {
            
            var selectedReason = $(this).val();
            var slideupSpeed = 'fast';
            var slidedownSpeed = 'fast';
			// blanket hide & disable validation
            //$(this).parents('.reasonSelection').find('.onScreenTextRow').slideUp();
            $(this).parents('.reasonSelection').find('.ABI').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.EI').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.FPR').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.ER').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.AI').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.RC').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.MC').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.LC').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.OE').slideUp(slideupSpeed);
            $(this).parents('.reasonSelection').find('.CI').slideUp(slideupSpeed);
            $('.ci-show').hide();
            $('.ci-hide').show();
            showReasonText(selectedReason)
            changeTooltipForSupportingDocuments();
            formChanged = true;
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
               formChanged=true;
            });
        

        function changeTooltipForSupportingDocuments()
        {
            var document01FileName = $('#documentFile1').attr('data-initial-caption');
            var document02FileName = $('#documentFile2').attr('data-initial-caption');
            var document03FileName = $('#documentFile3').attr('data-initial-caption');

            
            if (document01FileName==='' && ($('#supportDocument1').is(":hidden") || $('#supportDocument2').is(":hidden"))) {
                if ($('#reasonType').val() != "CI") {
                  $('#tooltip-addDoco').attr('data-toggle', 'tooltip').attr('data-original-title', 'To provide an additional supporting document, first select a mandatory supporting document.');
                }
                else
                {
                  $('#tooltip-addDoco').attr('data-toggle', 'tooltip').attr('data-original-title', 'To provide an additional supporting document, first select a supporting document.');
                }
                $('#addDocument').attr('disabled', true);
            }            
            else if ($('#supportDocument0').is(":visible") && $('#supportDocument1').is(":visible") && $('#supportDocument2').is(":visible"))
            {
               if ($('#reasonType').val() != "CI") {
                $('#tooltip-addDoco').attr('data-toggle', 'tooltip').attr('data-original-title', 'Only the mandatory supporting document plus a maximum of two additional supporting documents can be submitted.')
                .tooltip('fixTitle');
                }
                else
                {
                  $('#tooltip-addDoco').attr('data-toggle', 'tooltip')
                  .attr('data-original-title', "Only one supporting document plus a maximum of two additional supporting documents can be submitted.")
                  .tooltip('fixTitle');
                } 
                $('#addDocument').attr('disabled', true);
            }
            else
            {
                if(($('#supportDocument1').is(":visible") && document02FileName !== '') || $('#supportDocument1').is(":hidden"))
                {
                    $('#tooltip-addDoco').tooltip('hide')
                          .attr('data-original-title', "")
                          .tooltip('fixTitle');
                    $('#addDocument').removeAttr('disabled');
                }
                else
                {
                    $('#addDocument').attr('disabled', true);
                    $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "")
                      .tooltip('fixTitle');
                }
            }
        }

        function showReasonText(selectedReason)
        {
            var slidedownSpeed = 'fast';
            // Show row, depending on request type
            switch(selectedReason) {
                case "ABI":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.ABI').slideDown(slidedownSpeed);
                    break;
                case "EI":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.EI').slideDown(slidedownSpeed);
                    break;
                case "FPR":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.FPR').slideDown('fast');
                    break;
                case "ER":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.ER').slideDown(slidedownSpeed);
                    break;
                case "AI":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.AI').slideDown(slidedownSpeed);
                    break;
                case "RC":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.RC').slideDown(slidedownSpeed);
                    break;
                case "MC":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.MC').slideDown(slidedownSpeed);
                    break;
                case "LC":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.LC').slideDown(slidedownSpeed);
                    break;
                case "OE":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.OE').slideDown(slidedownSpeed);
                    break;
                case "CI":
                    $('.reasonSelection').find('.onScreenTextRow').slideDown(slidedownSpeed);
                    $('.reasonSelection').find('.CI').slideDown(slidedownSpeed);
                    $('.ci-show').show();
                    $('.ci-hide').hide();
                    break;
                    
                default:
                    break;
            }
        }
        var isValidFileName=(function(){
              var rg1=/^[^\\/:\*\?"<>\|]+$/; // forbidden characters \ / : * ? " < > |
              //var rg1 = /\[a-z_\-\s0-9\.];
              var rg2=/^\./; // cannot start with dot (.)
              var rg3=/^(nul|prn|con|lpt[0-9]|com[0-9])(\.|$)/i; // forbidden file names
              return function isValid(fname){
                return rg1.test(fname);
              }
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
                    return truncateFileName(filename.replace(/[\~\,\@\`\!\-\[\]\/\{}:;#%=\(\)\*\+\?\\\^\$\|<>&"']/g, '_'));
		}      

        function truncateFileName(filename)
        {
            if (filename.length <= 50)
                return filename;

            var name = filename;
            var temp = filename;
            var ext = "";
            var pos = name.indexOf('.');
            
            if (pos > 0) {
                if (name.length > 50)
                {
                    temp = name.substring(0,pos);
                    ext = name.substring(pos, name.length);
                    temp = temp.substring(0, 50-(ext.length))
                    name = temp +  ext;
                }
            }
            else
                if (name.length > 50) {
                    name = name.substring(0,50);
                }
            
            return name;
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
            // file upload field is wrap around div by bootstrap
            // it take a while to load
    	    if($("#fragment").val() == "reason"){
    			$('#descriptionText').focus();
    		}
    		else{
    			$('#reasonType:first').focus();
    		}
    		
    		$('.modal').on('hidden.bs.modal', function (e) {
    			focusHasError();
        	});   
    		
    		if($('#reasonType').val() == "CI"){
    			$('.ci-show').show(); //to show critical incident required contents
                $('.ci-hide').hide();
    		}
    		else{
    			$('.ci-show').hide(); //to hide critical incident required contents
    		}
            //$('#tooltip-addDoco').attr('data-toggle', 'tooltip').attr('data-original-title', 'To provide an additional supporting document, first select a mandatory supporting document.');
            $('#tooltip-addDoco').tooltip({placement: 'bottom'});
            
            var steppingBack = false;
            var isValidData = null;
           
            $("#descriptionText").on("keyup", function(e) {
                textCounter(this,'counter',500);
                formChanged=true;
            });
           
    		$('#scApplicationReasonForm').submit(function(event){
                event.preventDefault();
                //var els=document.getElementById("saveForLater");
                //els.value = "false";
                //$('#saveNextApp').trigger("click");
            });
            
            $('#askCSULink').click(function () {
		        var src = 'http://student.csu.edu.au/services-support/student-central/askcsu#/article/13531';

		        //$('#askCSU iframe').attr('src', src);
                 //load the url and show modal on success
                //$("#askCSU .modal-body").load(src, function() { 
                //     $("#askCSU").modal("show"); 
                //});
                //$('#askCSU').modal('show');
			 });


			//$("#addDocument").on("click", clone);

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
            
            $('#scApplicationReasonForm').formValidation({
                framework: 'bootstrap',
                icon: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    reasonType: reasonValidators,
                    descText: reasonDetailValidators 
                },
                excluded: ['disabled', 'hidden'] 

            });

            FormValidation.Validator.fileUploadValidators = {
                validate: function(validator, $field, options, validatorName) {
                    var value = validator.getFieldValue($field, validatorName);
                    if (value === '') {
                        return true;
                    }
                    var filename = document.getElementById('documentFile1').files[0].name;
                    var laterFlag = document.getElementById('supportDocLater').checked;
                    if (filename = '' && !laterFlag && $('#reasonType').val() != "CI") // for critical incident supporting document is optional
                        return false;
                    else
                        return true;
                }
            };

            /*
             * Yes button on Cancel dialog - Return to home.
             */
            $('#cancelAppYes').click(function(event) {
                var form = $('#scApplicationReasonForm');
                var formData = form.data('formValidation');
                var data = form.serialize();
                setFormSubmitting();
                document.location = $.getBaseUrl();
                
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

            $('#saveAppYes').click(function(event) {
                var els=document.getElementById("saveForLater");
                els.value = "true";
                $('#saveNextApp').trigger("click");
            });

            $('#stepBack').click(function(event) {
                steppingBack = true;
                var document01FileName = document.getElementsByName('documentFile1')[0].getAttribute('data-initial-caption');
                var document02FileName = document.getElementsByName('documentFile2')[0].getAttribute('data-initial-caption');
                var document03FileName = document.getElementsByName('documentFile3')[0].getAttribute('data-initial-caption');
                var reason = document.getElementById('reasonType').value;
                var descriptionText = document.getElementById('descriptionText').value;
                //if user hasn't made any changes in the current page and decides to step back to page 1, simply redirect as there is nothing to validate\save
                if (steppingBack && (reason == '' && descriptionText == '' && document01FileName == '' && document02FileName == '' && document03FileName == '')) {
                    console.log("Load Previous page...GUID" + document.getElementById('guid').value);
                    document.location = $.getBaseUrl() + 'application/editSubjects?guid=' + document.getElementById('guid').value + 
                '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                 '&_t='+ (new Date()).getTime();   
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
                var document01FileName = document.getElementsByName('documentFile1')[0].getAttribute('data-initial-caption');
                var document02FileName = document.getElementsByName('documentFile2')[0].getAttribute('data-initial-caption');
                var document03FileName = document.getElementsByName('documentFile3')[0].getAttribute('data-initial-caption');
                var form = $('#scApplicationReasonForm');
                var formData = form.data('formValidation');
                var serializedData = $("form").serialize();
                var formData01 = new FormData($("form").get(0));
                var els=document.getElementById("saveForLater");
                var isValid = null;

                formData.validate();
                isValid = formData.isValid();
                setFormSubmitting();
                //if steping back to step 1 and there are invalid data, return from here
                if (steppingBack && !isValid) {
                    isValidData = isValid;
                    steppingBack = false;
                    focusHasError();
                    return false;
                }
                
                if(document01FileName == '' && $('#reasonType').val() != "CI")
                {
                    $('#errorAppModal').modal('show');
                    isValidData = false;
                    steppingBack = false;
                    return false;
                }
                /*}
                else
                    isValid = true;*/
                console.log(" valid data? "+ isValid);
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
                            $('#saveNextApp').attr('disabled', 'disabled');
                            $('#saveAppYes').attr('disabled', 'disabled');
                            $('#saveAppNo').attr('disabled', 'disabled');
                            $('#loading').html('<img src="' + $.getBaseUrl() + 'assets/spinner.gif" />');
                        },
                        success: function (data) {
                            console.log(data);

                            if (data.errors === undefined) {
                                // All good
                            	if (els.value=="false" && !steppingBack && $("#showStep2b").val()=="true"){
                            		document.location = $.getBaseUrl() + 'application/reasonResSchoolExemption?guid=' + data.guid + 
                                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                                    '&_t='+ (new Date()).getTime();
                                    console.log("Load next page step 2b...GUID" + data.guid);
                            	}
                            	else if (els.value=="false" && !steppingBack) {
                                    document.location = $.getBaseUrl() + 'application/review?guid=' + data.guid + 
                                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                                     '&_t='+ (new Date()).getTime();
                                    console.log("Load next page...GUID" + data.guid);
                                }
                                else if(steppingBack)
                                    {
                                        console.log("Load Previous page...GUID" + data.guid);
                                        document.location = $.getBaseUrl() + 'application/editSubjects?guid=' + data.guid + 
                                    '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value +
                                     '&_t='+ (new Date()).getTime();   
                                    }
                                    else {
                                        document.location = $.getBaseUrl() + 'trackRequest/index'
                                    }
                                    //document.location = $.getBaseUrl();
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
            
            $("#addDocument").on("click", function(e) {
                if($('#supportDocument1').is(':hidden')) {
                    $('#supportDocument1').slideDown('fast');
                    $('#tooltip-addDoco').attr('title', '');
                    $(this).attr('disabled', true);
                }
                else
                {   
                    $('#supportDocument2').slideDown('fast');
                    changeTooltipForSupportingDocuments();
                    $(this).attr('disabled', true);
                };
                
                $("#removeDocoDiv").removeClass('hidden');
                $("#checkBoxMsg").addClass('hidden');
            });

            $("#removeDocument").on("click", function(e) {
                if(!$('#supportDocument1').is(':hidden') && !$('#supportDocument2').is(':hidden'))
                {
                    $('#documentFile3').fileinput('clear');
                    $('#supportDocument2').slideUp('fast');
                    $("#supportDocument2").hide();
                }
                else {
                    $('#documentFile2').fileinput('clear');
                    $('#supportDocument1').slideUp('fast');
                    $("#supportDocument1").hide();
                    $("#removeDocoDiv").addClass('hidden');
                }
                changeTooltipForSupportingDocuments();
            });

            //Mandatry document later checkbox click event
            $('#supportDocLater').on('click', function() {
                if (this.checked) {
                    //$('#documentFile1').fileinput('disable');
                    //$('#addDocument').attr('disabled', 'disabled').addClass('disabled');
                    //$('#file-tooltip').attr('data-toggle', 'tooltip').attr('data-title', 'Please first uncheck the checkbox below with the title \'I will provide mandatory documents later\'.');
                    //$('#file-tooltip').tooltip({placement: 'bottom'});
                    $('#documentFile1').fileinput('clear');
                    $('#documentFile3').fileinput('clear');
                    $('#supportDocument2').slideUp('fast');
                    $('#documentFile2').fileinput('clear');
                    $('#supportDocument1').slideUp('fast');
                    $("#removeDocoDiv").addClass('hidden');
                    $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "To provide a document, uncheck 'I will provide mandatory supporting documentation later'.")
                      .tooltip('fixTitle');
                    $('#addDocument').attr('disabled',true);
                    $("#checkBoxMsg").addClass('hidden');
                }
                else
                {
                    $('#documentFile1').fileinput('disable').fileinput('enable');
                    $('#file-tooltip').tooltip('hide');
                    if (document.getElementById('documentFile1').value == '') {
                        $('#tooltip-addDoco').tooltip('hide')
                      .attr('data-original-title', "To provide an additional supporting document, first select a mandatory supporting document.")
                      .tooltip('fixTitle');
                    }
                }
               
            });

            //File selection management
            $('#documentFile1').on('fileselect', function(event, numFiles, label) {
                
                var file = document.getElementById('documentFile1').files[0];
                var document01FileName = '';
            
                if ($('#supportDocLater').is(':checked')) {
                    $('#supportDocLater').prop("checked", false);
                }

               
                if(numFiles > 0)
                {
                    $('#tooltip-wrapper').addClass('spcon-label-disabled');
                    $('#tooltip-wrapper').tooltip({placement: 'bottom'});
                    $('#supportDocLater').attr('disabled', true);
                    $('#tooltip-wrapper').tooltip('hide')
                          .attr('data-original-title', "You have already selected a mandatory supporting document. If you intend to provide this document later, remove it and then check this box.")
                          .tooltip('fixTitle');
                }
                else
                {
                    $('#supportDocLater').removeAttr('disabled');
                    $('#tooltip-wrapper').removeClass('spcon-label-disabled');
                    $('#tooltip-wrapper').tooltip('hide')
                          .attr('data-original-title', "")
                          .tooltip('fixTitle');
                }
                document01FileName = truncateFileName(label);
                document.getElementsByName('documentFile1')[0].setAttribute('data-initial-caption', document01FileName);
                $("#removeDoc01Flag").val('false');
                changeTooltipForSupportingDocuments();
                formChanged=true;
            });

           
            $('#documentFile1').on('fileclear', function(event) {
                $("#removeDoc01Flag").val('true');
                document.getElementsByName('documentFile1')[0].setAttribute('data-initial-caption', '');
                changeTooltipForSupportingDocuments();
                formChanged=true;
            });

            $('#documentFile1').on('filecleared', function(event) {
                $("#checkBoxMsg").addClass('hidden');
                $('#supportDocLater').removeAttr('disabled');
                $('#tooltip-wrapper').removeClass('spcon-label-disabled');
                $('#tooltip-wrapper').tooltip('hide')
                          .attr('data-original-title', "")
                          .tooltip('fixTitle');
            });

            $('#documentFile1').on('fileerror', function(event, data, msg) {
                document.getElementsByName('documentFile1')[0].setAttribute('data-initial-caption', '');
                $("#removeDoc01Flag").val('false');
                //$('#addDocument').attr('disabled', true);
                $("#checkBoxMsg").addClass('hidden');
                $('#supportDocLater').removeAttr('disabled');
                $('#tooltip-wrapper').removeClass('spcon-label-disabled');
                $('#tooltip-wrapper').tooltip('hide')
                          .attr('data-original-title', "")
                          .tooltip('fixTitle');
                changeTooltipForSupportingDocuments();
                formChanged=true;
            });
            
            $('#documentFile2').on('fileerror', function(event, data, msg) {
                document.getElementsByName('documentFile2')[0].setAttribute('data-initial-caption', '');
                $("#removeDoc02Flag").val('false');
                $("#checkBoxMsg").addClass('hidden');
                changeTooltipForSupportingDocuments();
                formChanged=true;
            });
            $('#documentFile3').on('fileerror', function(event, data, msg) {
                document.getElementsByName('documentFile3')[0].setAttribute('data-initial-caption', '');
                $("#removeDoc03Flag").val('false');
                $("#checkBoxMsg").addClass('hidden');
                changeTooltipForSupportingDocuments();
                formChanged=true;
            });

             $('#documentFile2').on('fileselect', function(event, numFiles, label) {
                var file = document.getElementById('documentFile2').files[0];
                var document02FileName = truncateFileName(label);
                document.getElementsByName('documentFile2')[0].setAttribute('data-initial-caption', document02FileName);
                $("#removeDoc02Flag").val('false');   
                changeTooltipForSupportingDocuments();
                formChanged=true;     
             });

             $('#documentFile3').on('fileselect', function(event, numFiles, label) {
                var file = document.getElementById('documentFile3').files[0];
                var document03FileName = truncateFileName(label);
                document.getElementsByName('documentFile3')[0].setAttribute('data-initial-caption', document03FileName);
                $("#removeDoc03Flag").val('false'); 
                changeTooltipForSupportingDocuments();
                formChanged=true;
             });

             $('#documentFile2').on('fileclear', function(event, numFiles, label) {
                if (document.getElementById('documentFile3').value=='') {
                    $('#documentFile1').fileinput('enable');
                    $('#file-tooltip').removeAttr('data-toggle').removeAttr('data-title').tooltip('destroy');
                }
                document.getElementsByName('documentFile2')[0].setAttribute('data-initial-caption', '');
                $("#removeDoc02Flag").val('true');
                changeTooltipForSupportingDocuments();
                formChanged=true;
             });
             
             $('#documentFile3').on('fileclear', function(event, numFiles, label) {
                if (document.getElementById('documentFile2').value=='') {
                    $('#documentFile1').fileinput('enable');
                    $('#file-tooltip').removeAttr('data-toggle').removeAttr('data-title').tooltip('destroy');
                }
                 document.getElementsByName('documentFile3')[0].setAttribute('data-initial-caption', '');
                $("#removeDoc03Flag").val('true');
                changeTooltipForSupportingDocuments();
                formChanged=true;
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