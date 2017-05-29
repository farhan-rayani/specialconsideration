if (typeof jQuery !== 'undefined') {
    (function($) {

    	var regex = /^(.+?)(\d+)$/i;
        
    	 $(document).on('change', ':file', function() {
            var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });

        var declarationValidators = {
            validators: {
                notEmpty: {
                    message: 'Please indicate that you agree with the declaration before submitting your request'
                }
            }
        };

    	$(document).ready(function() {   

            //var isIE = /*@cc_on!@*/false || !!document.documentMode;
             // Edge 20+
            //var isEdge = !isIE && !!window.StyleMedia;
            /*
            output = "Is InternetExplorer? " + isIE;

            if (isIE) {
                    if(document.getElementById("downloadFile1") != null)
                    document.getElementById("downloadFile1").style.display = "";
                    if(document.getElementById("downloadFile2") != null)
                    document.getElementById("downloadFile2").style.display = "";
                    if(document.getElementById("downloadFile3") != null)
                    document.getElementById("downloadFile3").style.display = "";
                }
                else
                {
                    if(document.getElementById("viewFile1") != null)
                    document.getElementById("viewFile1").style.display = "";
                    if(document.getElementById("viewFile2") != null)
                    document.getElementById("viewFile2").style.display = "";
                    if(document.getElementById("viewFile3") != null)
                    document.getElementById("viewFile3").style.display = "";
                }
            */
            $('#scApplicationReviewForm').formValidation({
                framework: 'bootstrap',
                icon: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    declaration: declarationValidators
                },
                excluded: ['disabled', 'hidden'] 

            });
            function downloadFile1()
            {
              download(document.getElementById("file1data").value,document.getElementById("file1name").value,document.getElementById("file1mime").value);
            }

            function downloadFile2()
            {
              download(document.getElementById("file2data").value,document.getElementById("file2name").value,document.getElementById("file2mime").value);
            }

            function downloadFile3()
            {
              download(document.getElementById("file3data").value,document.getElementById("file3name").value,document.getElementById("file3mime").value);
            }            
            
            $('#downloadFile1').click(function(event) {
                download(document.getElementById("file1data").value,document.getElementById("file1name").value,document.getElementById("file1mime").value);
            });
            $('#downloadFile2').click(function(event) {
                download(document.getElementById("file2data").value,document.getElementById("file2name").value,document.getElementById("file2mime").value);
            });
            $('#downloadFile3').click(function(event) {
                download(document.getElementById("file3data").value,document.getElementById("file3name").value,document.getElementById("file3mime").value);
            });
            $('#downloadFileLink1').click(function(event) {
                download(document.getElementById("file1data").value,document.getElementById("file1name").value,document.getElementById("file1mime").value);
            });
            $('#downloadFileLink2').click(function(event) {
                download(document.getElementById("file2data").value,document.getElementById("file2name").value,document.getElementById("file2mime").value);
            });
             $('#downloadFileLink3').click(function(event) {
                download(document.getElementById("file3data").value,document.getElementById("file3name").value,document.getElementById("file3mime").value);
            });

            $(document).on("click", ".popover .close" , function(){
                 $(this).parents(".popover").popover('hide');
            });

            $('#scApplicationReviewForm').submit(function(event){
                event.preventDefault();
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

            $('#saveAppSubmit').click(function(event) {
                var form = $('#scApplicationReviewForm');
                var formData = form.data('formValidation');
                var isValid = null;
                
                // TODO validation
                //var isValid = formData.isValid();
                
                if (isValid === null) {

                    formData.validate();
                    isValid = formData.isValid();
                }

                console.log("Base URL: " + $.getBaseUrl());

                if (isValid) {
                    $.ajax({
                        type: form.attr('method'),
                        url: form.attr('action'),
                        data: form.serialize(),
                        beforeSend: function () {
                            $('#saveAppSubmit').attr('disabled', 'disabled');
                           $('#loading').html('<img src="' + $.getBaseUrl() + 'assets/spinner.gif" />');
                        },
                        success: function (data) {
                            if (data.errors === undefined) {
                                // All good
                                document.location = $.getBaseUrl() + 'application/complete?guid=' + data.guid + '&email='+ data.email + '&_t='+ (new Date()).getTime();
                                //console.log("Load next page...");
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
                    $('#confirmAppModal').modal('toggle');
                    //$('#actionResponse').removeClass();
                    //$('#actionResponse').addClass('alert alert-danger');
                    //$('#actionResponse').text("There are errors on the form. Please complete the required fields.");
                    $('#saveNextApp').removeAttr('disabled');
                    $('#loading').html('');
                }

                return false;
            });

    	}); // End Document.ready()

    })(jQuery);
}
