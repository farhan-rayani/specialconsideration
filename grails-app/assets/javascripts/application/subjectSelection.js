if (typeof jQuery !== 'undefined') {
    
    var formChanged = false;
   
    (function($) {
        var formSubmitting = false;
        var setFormSubmitting = function() { formSubmitting = true; };

        window.onload = function() {
            window.addEventListener("beforeunload", function (e) {
                console.log("formChanged = "+ formChanged);
                if(formChanged)
                {
                    var confirmationMessage = "Changes you made may not be saved";
                    if (formSubmitting) {
                        return undefined;
                    }
                    
                    (e || window.event).returnValue = confirmationMessage; //Gecko + IE
                    e.returnValue = confirmationMessage;
                    return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
                }
                /*else
                        return true;*/
            });

        };
         document.addEventListener("DOMContentLoaded", function(event) {
                var totalRequests = document.getElementById("requestTotal").value;
                initFormForUpdate(totalRequests);
                var assessmentElements = $(":input[id^='assessment']");
                var DOMelements = assessmentElements.get();

                for(var i = 0; i < DOMelements.length; i++) {
                    textCounter(DOMelements[i].id, 'counter'+i, 100);
                }
            });
        // We can attach the `fileselect` event to all file inputs on the page
        $(document).on('change', ':file', function() {
            var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });

        $(document).on('change', '.subjectSelect', function(e) {
        	var selId = $(this).attr("id")
        	selIndex = selId.substr(selId.length - 1);
        	
            var baseUrl = $('#scApplicationForm').data("so-base-url");
            var subject = $(this).find('option:selected');
            var subjectCode = subject.data("subject");
            var termCode = subject.data("term");
            var campus = subject.data("campus");
            var mode = subject.data("mode");
            //var href = $(this).parents('.subjectSelection').find('a.subjectOutlineLink').attr('href');
            $(this).parents('.subjectSelection').find('a.subjectOutlineLink').attr('href', baseUrl + subjectCode + '_' + termCode + '_' + campus + '_' + mode);
            formChanged=true;
        });

        // Change input fields based on Request Type
        $(document).on('change', '.requestTypeSelect', function(e) {
            var id = this.getAttribute('id');
            var idNo = id.charAt(id.length - 1);
            /*var curSubectElementID = "#subject"+cloneCounter;
            var subject = $(curSubectElementID +" option:selected").val();
            console.log("current subject option is **" + subject + "**");
            if (subject=='') {
                $("#" +id + ' option[selected="selected"]').each(
                    function() {
                        $(this).removeAttr('selected');
                    }
                );
                 $("#" +id +" option:first").attr('selected','selected');
            }*/
            var selectedType = $(this).val();
            
            console.log(" ID = " + id + " Number = " + idNo + " selected " + selectedType);
            // blanket hide & disable validation
            $(this).parents('.subjectSelection').find('.gp-row').slideUp();
            $(this).parents('.subjectSelection').find('.exr-row').slideUp();
            $(this).parents('.subjectSelection').find('.ext-date').slideUp();
            $(this).parents('.subjectSelection').find('.eg-item').slideUp();
            $(this).parents('.subjectSelection').find('.optional').slideUp();
            /* To enable assessment and date*/
            $('#assessment'+idNo).removeAttr('disabled');
            $('#extensionDate'+idNo).removeAttr('disabled');
            
            // Show row, depending on request type
            switch(selectedType) {
                case "GP":
                    $(this).parents('.subjectSelection').find('.gp-row').slideDown();
                    $(this).parents('.subjectSelection').find('.exr-row').slideUp();
                    $(this).parents('.subjectSelection').find('.ext-date').slideDown();
                    $(this).parents('.subjectSelection').find('.eg-item').slideDown();
                    $('#scApplicationForm').formValidation('enableFieldValidators', 'assessment' + idNo, true);
                    var gprow = $('#gpRow'+idNo);
                    gprow.find("label[for='assessment0']").text("For Assessment Item(s)");
                    $('#assessmentHelp'+idNo).removeClass("hidden-row");
                    $('#resiSchoolHelp'+idNo).addClass("hidden-row");
                    break;
                case "EXC":
                    $(this).parents('.subjectSelection').find('.gp-row').slideDown();
                    $(this).parents('.subjectSelection').find('.exr-row').slideUp();
                    $(this).parents('.subjectSelection').find('.optional').slideDown();
                    $('#scApplicationForm').formValidation('enableFieldValidators', 'assessment' + idNo, false);
                    var gprow = $('#gpRow'+idNo);
                    gprow.find("label[for='assessment0']").text("For Residential School(s)");
                    $('#resiSchoolHelp'+idNo).removeClass("hidden-row"); 
                    $('#assessmentHelp'+idNo).addClass("hidden-row");
                    break;
                case "EXR":
                	$(this).parents('.subjectSelection').find('.exr-row').slideDown();
                    $(this).parents('.subjectSelection').find('.gp-row').slideUp();
                    
                    /* To disable assessment and date*/
                    $('#assessment'+idNo).attr('disabled', 'disabled');
                    $('#extensionDate'+idNo).attr('disabled', 'disabled');
                    
                    var gprow = $('#gpRow'+idNo);
                    gprow.find("label[for='assessment0']").text("Details");
                    break;
                
            }
            
            $('#scApplicationForm').formValidation('resetField', 'assessment' + idNo);
            formChanged=true;
        });

        var regex = /^(.+?)(\d+)$/i;
        var cloneIndex = 1;
        var cloneCounter = 0;
        var selIndex = 0;
        var subjectValidators = {
            validators: {
                notEmpty: {
                    message: 'Please select your subject'
                }
            }
        },
        requestTypeValidators = {
            validators: {
                notEmpty: {
                    message: 'Please select the type of request that you need'
                }
            }
        },
        extensionDateValidators = {
            row: '.col-md-4',
            validators: {
                customFormat: {
                    message: 'Please specify your proposed extension date in the format DD/MM/YYYY',
                    format: 'D/M/YYYY'
                },
                requiredByGP: {
                    message: 'Please specify your proposed extension date in the format DD/MM/YYYY',
                    format: 'D/M/YYYY'
                },
                extensionMinDate: {
                    message: 'Proposed extension date must be later than the current date plus 2 business days.'
                }
            }
        },
        assessmentValidators = {
            row: '.col-md-6',
            validators: {
                requiredByGP: {
                    message: 'Please provide details of the assessment items'
                }
            }
        },
        detailValidators = {
                row: '.col-md-6',
                validators: {
                	requiredByEXR: {
                        message: 'Please provide details of the assessment items'
                    }
                }
            };

        function getRowId(fieldName) {
            var match = fieldName.match(regex);
            console.log("result from match: " + match);
            return 0;
        }

        function clone() {
            cloneCounter++
            var newElement = $("#subjectSelection0").clone()
            newElement.attr('id', 'subjectSelection' + cloneCounter).find('input,select,div,a,label').each(function() {
                var id = this.id || "";
                var match = id.match(regex) || [];
                if (match.length == 3) {
                    this.id = match[1] + (cloneCounter);
                    if (this.nodeName.toLowerCase() !== "div") this.name = this.id;
                }
            });
            newElement.attr('id', 'subjectSelection' + cloneCounter).find('i.form-control-feedback,small.help-block').remove();
            clearInputs(newElement);
            newElement.find('.subjectDivider').show();
            newElement.find('.gp-row').hide();
            newElement.find('.exr-row').hide();
            newElement.appendTo('#addRows').slideDown();
            initDatePicker('#extensionDateDiv' + cloneCounter);
            $('#counter'+cloneCounter).text("0/100");
            
            //$('#assessment'+cloneCounter).on("keyup", function(e) {
            /*$(document).on('keyup', '#assessment'+cloneCounter, function() {
                textCounter('assessment'+cloneCounter,'counter'+cloneCounter,100);
            });*/
            if (cloneIndex >= 1) {
                newElement.find('.removeButtonRow').show();
            }
            if (cloneIndex == 7) {
                $('#addSubject').attr('disabled', 'disabled').addClass('disabled');
                $('#tooltip-wrapper').attr('data-toggle', 'tooltip').attr('data-title', 'You have reached the maximum number of requests. You can add up to 8 requests per submission.');
                $('#tooltip-wrapper').tooltip({placement: 'bottom'});
            }

            initPopovers(newElement);

            $('#scApplicationForm').formValidation('addField', 'subject' + cloneCounter, subjectValidators);
            $('#scApplicationForm').formValidation('addField', 'requestType' + cloneCounter, requestTypeValidators);
            $('#scApplicationForm').formValidation('addField', 'assessment' + cloneCounter, assessmentValidators);
            $('#scApplicationForm').formValidation('addField', 'extensionDate' + cloneCounter, extensionDateValidators);
            $('#scApplicationForm').formValidation('addField', 'selDetail' + cloneCounter, detailValidators);
            $('#scApplicationForm').formValidation('resetField', 'subject' + cloneCounter);
            $('#scApplicationForm').formValidation('resetField', 'requestType' + cloneCounter);
            $('#scApplicationForm').formValidation('resetField', 'assessment' + cloneCounter);
            $('#scApplicationForm').formValidation('resetField', 'extensionDate' + cloneCounter);
            $('#scApplicationForm').formValidation('resetField', 'selDetail' + cloneCounter);
            $('#id'+cloneCounter).val('0');
            cloneIndex++;
            $('#subject'+cloneCounter+':first').focus();
        }

        function initFormForUpdate(elementCount)
        {
            var newElement = $("#subjectSelection0")
                       
            for(i=0;i<elementCount;i++)
            {
                newElement = $("#subjectSelection"+i);
                initDatePicker('#extensionDateDiv' + i);
                initPopovers(newElement);
                $('#scApplicationForm').formValidation('addField', 'subject' + i, subjectValidators);
                $('#scApplicationForm').formValidation('addField', 'requestType' + i, requestTypeValidators);
                $('#scApplicationForm').formValidation('addField', 'assessment' + i, assessmentValidators);
                $('#scApplicationForm').formValidation('addField', 'selDetail' + i, detailValidators);
                $('#scApplicationForm').formValidation('addField', 'extensionDate' + i, extensionDateValidators);
                $('#scApplicationForm').formValidation('resetField', 'subject' + i);
                $('#scApplicationForm').formValidation('resetField', 'requestType' + i);
                $('#scApplicationForm').formValidation('resetField', 'assessment' + i);
                $('#scApplicationForm').formValidation('resetField', 'selDetail' + i);
                $('#scApplicationForm').formValidation('resetField', 'extensionDate' + i);
            }
        }

        function removeClone() {
            var element = $(this).parents(".subjectSelection");
            console.log("element to remove: " + element[0].id);
            var name = element[0].id || "";
            var match = name.match(regex) || [];

            if (match.length == 3) {
                var index = match[2];
                console.log("index: " + index);
                $('#scApplicationForm').formValidation('removeField', 'subject' + index);
                $('#scApplicationForm').formValidation('removeField', 'requestType' + index);
                $('#scApplicationForm').formValidation('removeField', 'assessment' + index);
                $('#scApplicationForm').formValidation('removeField', 'selDetail' + index);
                $('#scApplicationForm').formValidation('removeField', 'extensionDate' + index);
            }

            element.remove();
            cloneIndex--;

            if (cloneIndex < 8) {
                $('#tooltip-wrapper').removeAttr('data-toggle').removeAttr('data-title').tooltip('destroy');
                $('#addSubject').removeAttr('disabled');
                $('#addSubject').removeClass('disabled');
            }
            $('#subject'+(cloneCounter-1)+':first').focus();

        }

        function initDatePicker(selector) {
            $(selector + ' .input-group.date').datepicker({
                format: "dd/mm/yyyy",
                maxViewMode: 2,
                //todayBtn: "linked",
                multidate: false,
                autoclose: true,
                todayHighlight: true,
                clearBtn: false,
                forceParse: false,
                keyboardNavigation: false,
                startDate: datePickerStartDate()
            }).on('changeDate', function(e) {
                $(selector).find('input').each(function() {
                    //this.trigger('change');
                    console.log(this.name);
                    //$('#scApplicationForm').formValidation('revalidateField', this.name);
                    $('#scApplicationForm').formValidation('revalidateField', this.name);
                })

            });
        }

        function clearInputs($element) {
            $element.find('input:text, input:password, input:file, select, textarea').val('');
            $element.find('input:radio, input:checkbox')
                .removeAttr('checked').removeAttr('selected');
        }

        function initPopovers($element) {
           var options = {
                trigger: 'click',
                html: true,
                container: 'body' //,
                //selector: '.has-popover'
            };
            $element.find('.has-popover').popover(options);
        }

        function addWeekdays(date, days) {
            date = moment(date); // clone
            if (days < 0) {
                // Don't do negative days.
                return date;
            }
            while (days > 0) {
                date = date.add(1, 'days');
                // decrease "days" only if it's a weekday.
                if (date.isoWeekday() !== 6 && date.isoWeekday() !== 7) {
                    days -= 1;
                }
            }
            return date;
        }

        function addMonths(date, months) {
            date = moment(date); // clone
            if (months < 0) {
                // Don't do negative months.
                return date;
            }
            
            date = date.add(months, 'months');
            
            return date;
        }

        function addDays(date, days) {
            date = moment(date); // clone
            date = date.add(days, 'days');
            
            return date;
        }

        function datePickerStartDate() {
            var startDate = addWeekdays(moment(), 3);
            return startDate.format('DD/MM/YYYY');
        }
        function getTermDateAsStr(element) {
            var termEndDateStr = null;
            if (element == '') 
            return termEndDateStr;
            var endDate = $(element).val();
            var res = endDate.split("_");
            if (res.length > 1) 
            termEndDateStr = res[2].toString();
            return termEndDateStr;
        }

        function beforeTwelveMonths(extDate,termEndDateStr)
        {
            if (extDate == '' || termEndDateStr == '') {
                return true;
            }

            var dateObj = new moment(extDate, 'D/M/YYYY', true);
            var termEndDate = new moment(termEndDateStr, 'D/M/YYYY', true);
            var maxAllowedDate = addMonths(termEndDate.toDate(), 12);
            //var twelveMonthsMaximum = addMonths(moment(), 12);
            //alert("Ext Date : " + extDate + "\nTerm End date : " + termEndDateStr + "\nMax Allowed date : "+ maxAllowedDate.toDate() + "\nBefore 12 months? " + dateObj.isBefore(maxAllowedDate, 'day'));
            return dateObj.isBefore(maxAllowedDate, 'day');
        }
        function getCurrentDate() {
           var tdate = new Date();
           var dd = tdate.getDate(); //yields day
           var MM = tdate.getMonth(); //yields month
           var yyyy = tdate.getFullYear(); //yields year
           var currDate = dd + "/" +( MM+1) + "/" + yyyy;

           return currDate;
        }

        function beforeCensusDate(censusDate)
        {
            if (censusDate == '' || censusDate == '') {
                return true;
            }
            var dt = getCurrentDate();
            
            var currDate = new moment(dt, 'D/M/YYYY', true);
            var censusDt = new moment(censusDate, 'D/M/YYYY', true);
            return currDate.isBefore(censusDt, 'day');
        }
        function twoWeeksBeforeTermEnds(termEndDateStr)
        {
            if (termEndDateStr=='' || termEndDateStr==null) {
                return true;
            }
            //var value = document.getElementById("extensionDate0").value;

                    //var dateObj = new moment(extDate, 'D/M/YYYY', true);
                    var dateObj = new moment();
                    var termEndDate = new moment(termEndDateStr, 'D/M/YYYY', true);
                    var maxAllowedDate = addDays(termEndDate.toDate(), -14);
                    //dateObj = addDays(dateObj.toDate(), 248);
                    return dateObj.isBefore(maxAllowedDate, 'day');
        }

        function checkDateFormat(value)
        {
            //var value = $(element).val();

            /*var regex8 = /^[0-9]{1}[\/][0-9]{1}[\/][0-9]{4}$/g;
            var regex10 = /^[0-9]{2}[\/][0-9]{2}[\/][0-9]{4}$/g;
            if ((value.length == 8 && value.match(regex8)) || (value.length == 10 && value.match(regex10))) {

                        return true;
                    }
                    else
                        return false;*/
            var dateObj = new moment(value, 'D/M/YYYY', true);
            return dateObj.isValid();
        }
           
        function checkResiSchoolExemptionForCompletedWork()
        {
            var items = document.getElementsByClassName("form-control selDetail");
            var alreadySelected = false;
            var cntr = 0;
            
            for (var i = items.length; i--;) {
                if (items[i].value==='COMPLETED') 
                {
                  cntr++;
                  if (cntr==2) 
                  alreadySelected = true;
                }
            }
            
            return alreadySelected;
        }

         function textCounter(inputFieldId,counterFieldId,maxlimit)
        {

         var countfield = document.getElementById(counterFieldId);
         var inputField = document.getElementById(inputFieldId);
         
         if ( inputField.value.length > maxlimit ) {
          inputField.value = inputField.value.substring( 0, maxlimit );
          return false;
         } else {
          countfield.innerHTML = inputField.value.length + '/' + maxlimit;
         }
         formChanged=true;
         
        }
        /* ************************************************************* */
        /* Document Ready block */
        /* ************************************************************* */
        $(document).ready(function() {
        	$('#subject0:first').focus();
        	
        	$('.modal').on('hidden.bs.modal', function (e) {
        		$('#requestType'+selIndex+':first').focus();
        	});           
        	
        	
        	
            $('#extensionDateDiv0 .input-group.date').datepicker({
                format: "dd/mm/yyyy",
                maxViewMode: 2,
                //todayBtn: "linked",
                multidate: false,
                autoclose: true,
                todayHighlight: true,
                clearBtn: false,
                forceParse: false,
                keyboardNavigation: false,
                startDate: datePickerStartDate()
            }).on('changeDate', function(e) {
                console.log('date updated');
                $('#scApplicationForm').formValidation('revalidateField', 'extensionDate0');
            });
            var totalRequests = document.getElementById("requestTotal").value;
            var mode = document.getElementById("mode").value;
            cloneIndex = (totalRequests > 0) ? totalRequests : 1;
            cloneCounter = (totalRequests > 0) ? totalRequests-1 : 0;
             if (totalRequests >= 8) {
                $('#addSubject').attr('disabled', 'disabled').addClass('disabled');
                $('#tooltip-wrapper').attr('data-toggle', 'tooltip').attr('data-title', 'You have reached the maximum number of requests. You can add up to 8 requests per submission.');
                $('#tooltip-wrapper').tooltip({placement: 'bottom'});
            }
            //PLEASE NOTE, I tried to dynamically bind keyup event in the clone function but for some reason it doesn't work
            //hence repeating the below event binder 8 times. the dynamic binding code is still commented in clone function
            //if you can manage to get it work, please remove below binders EXCEPT the firsy one for assessment0 element
            $(document).on('keyup', '#assessment0', function() {
                textCounter("assessment0",'counter0',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment1', function() {
                textCounter("assessment1",'counter1',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment2', function() {
                textCounter("assessment2",'counter2',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment3', function() {
                textCounter("assessment3",'counter3',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment4', function() {
                textCounter("assessment4",'counter4',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment5', function() {
                textCounter("assessment5",'counter5',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment6', function() {
                textCounter("assessment6",'counter6',100);
                formChanged=true;
            });
            $(document).on('keyup', '#assessment7', function() {
                textCounter("assessment7",'counter7',100);
                formChanged=true;
            });
            $(document).on("click", ".popover .close" , function(){
                 $(this).parents(".popover").popover('hide');
            });
            $("#removeSubject0").on("click", removeClone);
            $("#removeSubject1").on("click", removeClone);
            $("#removeSubject2").on("click", removeClone);
            $("#removeSubject3").on("click", removeClone);
            $("#removeSubject4").on("click", removeClone);
            $("#removeSubject5").on("click", removeClone);
            $("#removeSubject6").on("click", removeClone);
            $("#removeSubject7").on("click", removeClone);
            /*
             * Form Validation
             */
            FormValidation.Validator.customFormat = {
                validate: function(validator, $field, options, validatorName) {
                    var value = validator.getFieldValue($field, validatorName);
                    
                    if (value == ''){
                        return true;
                    }
                    
                    var dateObj = new moment(value, (options.format) ? options.format : 'D/MM/YYYY', true);
                    
                    return dateObj.isValid();
                }
            };
            
            FormValidation.Validator.customFutureDate = {
                validate: function(validator, $field, options, validatorName) {
                    var value = validator.getFieldValue($field, validatorName);

                    if (value === '') {
                        return true;
                    }

                    var dateObj = new moment(value, (options.format) ? options.format : 'D/MM/YYYY', true);
                    return dateObj.isAfter(moment(), 'day') || dateObj.isSame(moment(), 'day');
                }
            };

            FormValidation.Validator.extensionMinDate = {
                validate: function(validator, $field, options, validatorName) {
                    var value = validator.getFieldValue($field, validatorName);
                    if (value === '') {
                        return true;
                    }

                    var dateObj = new moment(value, (options.format) ? options.format : 'D/M/YYYY', true);
                    var threeDayMinimum = addWeekdays(moment(), 2);
                    if (dateObj.isValid()) 
                        return dateObj.isAfter(threeDayMinimum, 'day');
                    else
                        return true;
                }
            };

            /*FormValidation.Validator.extensionMaxDate = {
                validate: function(validator, $field, options, validatorName) {
                    var value = validator.getFieldValue($field, validatorName);
                    if (value === '') {
                        return true;
                    }

                    var dateObj = new moment(value, (options.format) ? options.format : 'D/M/YYYY', true);
                    var twelveMonthsMaximum = addMonths(moment(), 12);

                    return dateObj.isBefore(twelveMonthsMaximum, 'day');
                }
            };*/

            FormValidation.Validator.requiredByGP = {
                validate: function(validator, $field, options, validatorName) {
                    var value = validator.getFieldValue($field, validatorName);

                    var id = $field[0].id || "";
                    var requestType = 'requestType';
                    var match = id.match(regex) || [];
                    if (match.length == 3) {
                        var index = match[2];
                        requestType = requestType + index;
                    }
                    //console.log("requestType GP "+requestType +" value "+value)
                    var requestTypeVal = $('#' + requestType).val();
                    if ( requestTypeVal === 'GP' && value === '') {
                        //console.log("Validating required by GP for " + $field[0].id + " - failed");
                        return false;
                    }
                    //console.log("success validating required by GP for " + $field[0].id);
                    return true;
                }
            }
            
            FormValidation.Validator.requiredByEXR = {
                    validate: function(validator, $field, options, validatorName) {
                        var value = validator.getFieldValue($field, validatorName);

                        var id = $field[0].id || "";
                        var requestType = 'requestType';
                        var match = id.match(regex) || [];
                        if (match.length == 3) {
                            var index = match[2];
                            requestType = requestType + index;
                        }
                        //console.log("requestType EXR "+requestType +" value "+value)
                        var requestTypeVal = $('#' + requestType).val();
                        if (requestTypeVal === 'EXR' && value === '' ) {
                            console.log("Validating required by EXR for " + $field[0].id + " - failed");
                            return false;
                        }
                        //console.log("success validating required by EXR for " + $field[0].id);
                        return true;
                    }
                }
            $('#scApplicationForm').formValidation({
                framework: 'bootstrap',
                icon: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    subject0: subjectValidators,
                    requestType0: requestTypeValidators,
                    assessment0: assessmentValidators,
                    extensionDate0: extensionDateValidators,
                    selDetail0: detailValidators
                },
                excluded: ['disabled'],
                excluded: [':hidden']
            });



            $(document).on("input", ".assessment", function(event){
                formChanged=true;
            });

            $(document).on("change", ".selDetail", function(event){
                var value = $(this).val();
                if (value == 'COMPLETED' && checkResiSchoolExemptionForCompletedWork()==true) {
                    $('#resiEXRRequest').modal('toggle');
                    $(this).prop('selectedIndex',0);
                    $('#scApplicationForm').formValidation('resetField', $(this));
                }
                formChanged=true;
            });

            $(document).on("change", ".subjectSelect", function(){
                var reminderRepeat = false;
                var reqType = $("#requestType" + cloneCounter).val();
                var sessionAction = document.getElementById("getSessionDataAction").value;
                var censusDate = $("#subject"+cloneCounter).find(':selected').attr('census-date');
                var residentialSchool = $("#subject"+cloneCounter).find(':selected').attr('residential-school'); 
                
                if (residentialSchool==='N') {
                      $("#requestType" + cloneCounter +" option[value*='EX']").remove();
                      //prop('disabled', true);
                    }
                else{
                        if($("#requestType" + cloneCounter +" option[value='EXC']").val() === undefined){
                            $("#requestType" + cloneCounter).append($("<option>EXC</option>").attr("value","EXC").text("An extension past the end of session to complete a compulsory residential school"));
                        }
                        if($("#requestType" + cloneCounter +" option[value='EXR']").val() === undefined){
                            $("#requestType" + cloneCounter).append($("<option>EXR</option>").attr("value","EXR").text("An exemption or partial exemption from a compulsory residential school"));
                        }
                    
                    //$("#requestType" + cloneCounter)
                    //.find("option")
                    //.prop('disabled', false);;
                }
                if (beforeCensusDate(censusDate)) {
                    //$("#requestType" + cloneCounter +" option[value='AW']").prop('disabled', true);
                    $("#requestType" + cloneCounter +" option[value='AW']").remove();
                }
                else
                {
                    //$("#requestType" + cloneCounter +" option[value='AW']").prop('disabled', false);
                    //console.log(" val "+$("#requestType" + cloneCounter +" option[value='AW']").val());
                    //if($("#requestType" + cloneCounter +" option[value='']").val()===undefined)
                    //{
                        if($("#requestType" + cloneCounter +" option[value='AW']").val() === undefined){
                            $("#requestType" + cloneCounter).append($("<option>AW</option>").attr("value","AW").text("To withdraw from a subject after census date"));
                        }
                    //}
                    
                }

                var termEndDateStr = getTermDateAsStr("#subject"+cloneCounter);
                 
                if (!twoWeeksBeforeTermEnds(termEndDateStr)) {
                    $.ajax({
                        dataType: "JSON",
                      url: sessionAction,
                      data: { key: "END_OF_TERM_REMINDER_FLAG" },
                      cache: false,
                      success: function(data) {
                        reminderRepeat = (data.result == 'true');
                        if (typeof reminderRepeat != 'undefined' && !reminderRepeat)
                        {                                
                            $('#closeToEndOfTheTerm').modal('toggle');
                        }
                      }
                    });
                    
                } 
             });

            $(document).on("change", ".extensionDate", function(){
                var value = document.getElementById("extensionDate"+cloneCounter).value;
                var sessionAction = document.getElementById("getSessionDataAction").value;
                var reminderPostSession = false;
                var termEndDateStr = getTermDateAsStr("#subject"+cloneCounter);
                var dateObj = new moment(value, 'D/M/YYYY', true);
                formChanged=true;
                if(!dateObj.isValid())
                    event.preventDefault();
                else
                {
                $.ajax({
                  dataType: "json",
                  url: sessionAction,
                  contentType: "application/json",
                  data: { key: "POST_END_OF_SESSION_REMINDER_FLAG" },
                  cache: false,
                  success: function(data) {
                    reminderPostSession = (data.result == 'true');
                     if (!beforeTwelveMonths(value, termEndDateStr)) 
                        {   
                            if (typeof reminderPostSession != 'undefined' && !reminderPostSession)
                            {                                
                                $('#outsideTwelveMonths').modal('toggle');
                            }
                        } 
                  },
                  error: function (err) {
                      console.log("Some error occured." + err);
                  }
                });
                }     
            });


            //checkbox on the warning message clicked for the more than 12 months ext date
            $('#postEndOfSession').click(function(event) {
                var form = $('#scApplicationForm');
                var postEndOfSessionReminder = document.getElementById('postEndOfSession').value;
                var sessionAction = document.getElementById("setSessionDataAction").value;
                var dataVal = {flag: postEndOfSessionReminder, key: "POST_END_OF_SESSION_REMINDER_FLAG"};
                $.ajax({ 
                        dataType: JSON,
                        type: form.attr('method'),
                        //url: form.attr('action'),
                        url: sessionAction,
                        data: dataVal,
                        cache: false
                        });
            });                
            
            //checkbox on the warning message clicked for the more than 12 months ext date
            $('#endOfTerm').click(function(event) {
                var form = $('#scApplicationForm');
                var EndOfTermReminder = document.getElementById('endOfTerm').value;
                var sessionAction = document.getElementById("setSessionDataAction").value;
                var dataVal = {flag: EndOfTermReminder, key: "END_OF_TERM_REMINDER_FLAG"};
                $.ajax({ 
                        dataType: JSON,
                        type: form.attr('method'),
                        //url: form.attr('action'),
                        url: sessionAction,
                        data: dataVal,
                        cache: false
                        });
            });

            /*
             * Add another subject request block - clone.
             */
            $("#addSubject").on("click", function(event) {
                var form = $('#scApplicationForm');
                var formData = form.data('formValidation');

                // TODO validation
                var isValid = formData.isValid();
                
                if (isValid === null) {
                    formData.validate();
                    isValid = formData.isValid();
                }

                if (isValid) {
                    clone();
                }
                else{
                	focusHasError();
                }
                return isValid;
            });

            $("#addRows").on("click", "button.removeSubjectButton", removeClone);

            $('#addRows').on("click", ".help-btn", function(e) {
                e.preventDefault();
				return true;
            });

            /*
             * Yes button on Cancel dialog - Return to home.
             */
            $('#cancelAppYes').click(function(event) {
                setFormSubmitting();
                document.location = $.getBaseUrl();
            });

            /* 
            *  when user clicks on the 'Save & Next' button, perform form validation first
            *  i.e. before displaying the modal dialog box for any additional subjects
            */
            $('#saveNextApp').click(function(event) {
                var form = $('#scApplicationForm');
                var formData = form.data('formValidation');

                // TODO validation
                var isValid = formData.isValid();
                if (isValid === null) {
                    formData.validate();
                    isValid = formData.isValid();
                }
                
                if(!isValid){
                	focusHasError();
                }
                setFormSubmitting();
                return isValid;
            });
            
            /*
             * Yes button on Save dialog - Save form and continue
             */
            $('#saveAppYes').click(function(event) {
                var form = $('#scApplicationForm');
                var formData = form.data('formValidation');
                // TODO validation
                var isValid = formData.isValid();
                
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
                            $('#saveNextApp').attr('disabled', 'disabled');
                            $('#saveAppYes').attr('disabled', 'disabled');
                            $('#saveAppNo').attr('disabled', 'disabled');
                            $('#loading').html('<img src="' + $.getBaseUrl() + 'assets/spinner.gif" />');
                        },
                        success: function (data) {
                            console.log(data);
                            if (data.errors === undefined) {
                                // All good
                                if (mode != 'edit') 
                                    document.location = $.getBaseUrl() + 'application/reason?guid=' + data.guid + '&_t='+ (new Date()).getTime();
                                else
                                    document.location = $.getBaseUrl() + 'application/editReason?guid=' + data.guid 
                                    + '&mode='+ document.getElementById('mode').value + '&newRequest=' + document.getElementById('newRequest').value 
                                + '&_t='+ (new Date()).getTime();
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
                            console.log("Error saving the request"+data);
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

        });
    })(jQuery);
}

function focusHasError(){
	$(".has-error:first select:first").focus();
	if(!$(".has-error:first select:first").is(":focus")){
		$(".has-error:first input").focus();
	}
}
