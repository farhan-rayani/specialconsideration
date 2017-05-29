$(document).ready(function() {
	
	fillSelection();
	
	if($('#assign-to').text()!='Me'){
		$("select[name='selRecommendation']").attr('disabled','disabled');
		$('.accept-chk').attr('disabled','disabled');
		
		$("button").attr("disabled", "disabled");
		$('#tags').attr('disabled','disabled');
		//if($('#assign-to').text() == 'Not Assigned'){
			$('#assignBtn').removeAttr('disabled');
			$('#tags').removeAttr('disabled');
		//}
	}
   $('.btn-assessment').on('click', function(){
	   
	   if($('.tick-img').is(":visible")){
		   var recommendationSelValue = $( "#selRecommendation option:selected" ).val();
		   if(recommendationSelValue=="R"){
			   $('#confirmRejModal').modal('toggle');
		   }
		   else{
			   $('#confirmAssessmentModal').modal('toggle');
		   }
	   }
	   
   });
   
   $('#selRecommendation').on('change', function(){
	   fillSelection();
    } );
   
   $('#selRej').on('change', function(){
	   actionOnSelRej();
	   
    } );
   
   $('.accept-chk').on('click', function(){
	   if($(this). prop("checked") == true){
		   $("#selRecommendation").val("A").change(); 
		   disableCheckBox("To accept this document as the mandatory document, uncheck the document that has been accepted.");
		   var chkboxId=$(this).attr('id');
		   enableChkboxById(chkboxId);
		   activeTick();
	   }
	   else{
		   $("#selRecommendation").val("").change(); 
	   }
    });
   
   var recommendationValidators = {
	    validators: {
	        notEmpty: {
	            message: 'Please select your recommendation'
	        }
	    }
	},
	rejValidators = {
	    validators: {
	        notEmpty: {
	            message: 'Please select the reason for rejecting the mandatory supporting document'
	        }
	    }
	},
	mandatoryValidators = {
		   err: '#madatoryChkMessage',
		   /*notEmpty: {
			   message: "Please check 'Accept this document as the mandatory document’ for the document you want to accept",
	        },*/
		    validators: {
		       callback: {
                    message: "Please check 'Accept this document as the mandatory document’ for the document you want to accept",
                    callback: function(value, validator, $field) {
                    	var recommendationSelValue = $( "#selRecommendation option:selected" ).val();
                    	//console.log(" checked "+$field.prop('checked')+" id "+$field.attr('id')+" checked "+ );
                    	return (recommendationSelValue == 'REJECT_DOCUMENT' || recommendationSelValue == '') ? true : ($('input[name=madatoryChk]').is(":checked"));
                    }
                }
		    }
		}

	$('#processReqForm').on('init.field.fv', function(e, data) {
        if (data.field === 'madatoryChk') {
            var $icon = data.element.data('fv.icon');
            $icon.appendTo('#madatoryChkIcon');
        }
    })
	.formValidation({
	    framework: 'bootstrap',
	    icon: {
	        valid: 'glyphicon glyphicon-ok',
	        invalid: 'glyphicon glyphicon-remove',
	        validating: 'glyphicon glyphicon-refresh'
	    },
	    fields: {
	    	selRecommendation: recommendationValidators,
	    	selRej: rejValidators,
	    	madatoryChk: mandatoryValidators
	    }/*,
	    excluded: [':disabled'],
	    excluded: [':hidden']*/
	}).on('change', '[name="selRecommendation"]', function(e) {
        $('#processReqForm').formValidation('revalidateField', 'madatoryChk');
    });
   
   /*$('#save-btn').on('click', function(){
	   var form = $('#processReqForm');
       var formData = form.data('formValidation');
       
       // TODO validation
       var isValid = formData.isValid();
       if (isValid === null) {
           formData.validate({
               ignore: ":disabled"
           });
           isValid = formData.isValid();
       }
       console.log(" isValid "+isValid);
   });*/
	
   $(document).on("click", ".popover .close" , function(){
       $(this).parents(".popover").popover('hide');
  });
   
   
   var isIE = /*@cc_on!@*/false || !!document.documentMode;
   // Edge 20+
   var isEdge = !isIE && !!window.StyleMedia;
   output = "Is InternetExplorer? " + isIE;
   
   if (isIE) {
	   $('.showDoc').hide();
   }
   else{
		  $('.downloadDoc').hide()
	  }
   
   $('.downloadDoc').on('click', function(){
	   var fileId=$(this).attr("documentId");
	   downloadFile(fileId);
   });
   
   $('.downloadWordDoc').on('click', function(){
	   var fileId=$(this).attr("documentId");
	   downloadFile(fileId);
   });
   
   $.typeahead({
	    input: '.search-btn',
	    order: "desc",
	    source: {
	        data: [
			'Asilika Kumar',
			'Catherine Cranston',
			'Elizabeth Purcell',
			'Elira Willan',
			'Fiona Reedy',
			'Helen Syme',
			'Janice Korner',
			'Julie Linsell',
			'Jane Press',
			'Jason Hay',
			'Laura Bloomfield',
			'Lorem Ipsum',
			'Maria Drinkwater',
			'Marilyn Goldsmith',
			'Natalie Raczkowski',
			'Patsy Suckling',
			'Suzanne Jones',
			'Sushma Sharma',
			'Vicki Hennock'
	        ]
	    }
	});
   
   $('#assignBtn').on('click', function(){
	   $("select[name='selRecommendation']").attr('disabled','disabled');
	   $('.accept-chk').attr('disabled','disabled');
   });
   
});



function activeTick(){
	$('.remove-img').hide();
	$('.tick-img').show();
	$('.btn-assessment').removeAttr('disabled');
	$('.btn-assessment').attr('class','btn btn-primary btn-spacing btn-assessment');
}
function activeRemove(){
	$('.remove-img').show();
	$('.tick-img').hide();
	$('.btn-assessment').attr('class','btn btn-default btn-spacing btn-assessment');
	$('.btn-assessment').attr('disabled','disabled');
}

function disableCheckBox(toolTipTxt){
	$('.accept-chk').prop('checked', false);
	$('.accept-chk').attr('disabled','disabled');
	
	$('.spcon-label').addClass('spcon-label-disabled');
    $('.spcon-label').tooltip({placement: 'bottom'});
    //$('#supportDocLater').attr('disabled', true);
    $('.spcon-label').tooltip('hide')
          .attr('data-original-title', toolTipTxt)
          .tooltip('fixTitle');
}

function enableCheckBox(){
	$('.accept-chk').removeAttr('disabled');
	
	$('.spcon-label').removeClass('spcon-label-disabled');
    $('.spcon-label').tooltip('hide')
          .attr('data-original-title', "")
          .tooltip('fixTitle');
}

function enableChkboxById(chkId){
	$('#'+chkId).removeAttr('disabled');
	$('#'+chkId).prop('checked', true);
	$('#tooltip-'+chkId).removeClass('spcon-label-disabled');
    $('#tooltip-'+chkId).tooltip('hide')
          .attr('data-original-title', "")
          .tooltip('fixTitle');
}

function hideRejSel(){
	$('#reject-info-div').hide();
	$('#reject-sel-div').hide();
}

function showRejSel(){
	$('#reject-info-div').show();
	$('#reject-sel-div').show();
}

function downloadFile(fileId)
{
  if(fileId!=null){
	  download(document.getElementById("file"+fileId+"data").value,document.getElementById("file"+fileId+"name").value,document.getElementById("file"+fileId+"mime").value);
  }
}

function actionOnSelRej(){
   var rejSelValue = $( "#selRej option:selected" ).val();
   if(rejSelValue!=""){
	   activeTick();
   }
   else{
	   activeRemove();
   }
}

function fillSelection(){
	 var isChecked = $('input[name=madatoryChk]').prop('checked');
	   //console.log('isChecked '+isChecked);
	   var recommendationSelValue = $( "#selRecommendation option:selected" ).val();
	   if(recommendationSelValue=="A"){
		   if(isChecked == true){
			  activeTick();
		   }
		   else{
			  activeRemove();
		   }
		   hideRejSel();
		   enableCheckBox();
		   $('.btn-assessment').text("Send for Assessment");
	   }
	   else if(recommendationSelValue=="R"){
		   $('#reject-info-div').show();
		   $('#reject-sel-div').show();
		   actionOnSelRej();
		   disableCheckBox("To accept this document as the mandatory document, change Recommendation to Accept Selected Document.");
		   $('.btn-assessment').text("Send Document Request");
		   $("#madatoryChkMessage small:first").hide();
	   }
	   else{
		   $('#reject-info-div').hide();
		   $('#reject-sel-div').hide();
		   activeRemove();
		   enableCheckBox();
		   $('.btn-assessment').text("Send for Assessment");
	   }
}