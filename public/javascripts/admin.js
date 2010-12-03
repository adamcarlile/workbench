$.fn.ajaxGetLink = function(target){
  var collection = this;
  this.each(function(){
    $(this).click(function(){
      target.load( this.href );
      return false;
    })
  });
}

$.fn.ajaxForm = function(){
  this.unbind('submit').submit(function(){
    data = $(this).serializeArray();
    $.post(this.action, data, null, 'script');
    return false;
  });
}

$.fn.visible = function(){
  return this.is(':visible');
}

$(document).ready(function(){
  
  $(".ui-tabs").tabs({
    load: function(event, ui) { doContentLoaded() },
    cache: false
  });

  $("#site-map").treeTable();

  $("body").ajaxComplete(function(){

    $("#content_browser.ajax .pagination a").ajaxGetLink($("#content_browser .results"));
    $("#Children .pagination a").ajaxGetLink($("#Children"));
    doContentLoaded();

  })
  
  $('.visibility_toggle').click(function(){
    var target = $('#'+this.target);
    if( target.visible()){
      target.hide();
      $(this).html($(this).html().replace('Hide', 'Show'));
    } else {
      target.show();
      $(this).html($(this).html().replace('Show', 'Hide'));
    }
    return false;
  });

  doContentLoaded();
    
})

function doContentLoaded()
{

  $("#content_browser.ajax > form").submit(function(){
    data = $(this).serialize();
    $("#content_browser .results").load(this.action, data);
    return false;
  });  

  $("#content_browser.ajax .tag_list a").ajaxGetLink($("#content_browser .results"));

  $("#content_browser.ajax .results form, #page_attachments form").ajaxForm();
  
  $('table.sortable').tableDnD({
    onDrop: function(table,rows){ 
      var i = 0;
      $(table.rows).each(function(){
        $(this).find('input.position').val(i);
        i++;
      });
    },
    serializeRegexp: /[^_]*$/ 
  }).find('input.position').hide();

  $(".dialog").each(function(dialog){
    $(this).dialog({ autoOpen: false, resizeable: true, width: 400})
  });

  $('a.dialog_link').click(function(){
    $('#'+this.target).dialog('open');
    return false;
  })

  $('a.ajax_dialog_link').click(function(){
    $('#'+this.target).html(' ').load(this.href).dialog('open');
    return false;
  })

	$(function(){
		if($('.user_autocomplete').length != 0 ){
  	$('.user_autocomplete').autocomplete({
			minLength: 0,
			source: user_autocomplete_url,
			focus: function(event, ui) {
							$('.user_autocomplete').val(ui.item.label)
							return false;
						},
			select: function(event, ui) {
							$('.user_autocomplete').val(ui.item.label);
							$('.user_id_field').val(ui.item.value);
							return false;
						}
		}).data( "autocomplete" )._renderItem = function( ul, item ) {
			return $( "<li></li>" ).data( "item.autocomplete", item ).append( "<a>" + item.label + "<br>" + item.desc + "</a>" ).appendTo( ul );
		};
		}		
	});

	$(function() {
			function split(val) {
				return val.split(/,\s*/);
			}
			function extractLast(term) {
				return split(term).pop();
			}

			$(".tags_autocomplete").autocomplete({
				source: function(request, response) {
					$.getJSON(tags_autocomplete_url, {
						term: extractLast(request.term)
					}, response);
				},
				search: function() {
					// custom minLength
					var term = extractLast(this.value);
				},
				focus: function() {
					// prevent value inserted on focus
					return false;
				},
				select: function(event, ui) {
					var terms = split( this.value );
					// remove the current input
					terms.pop();
					// add the selected item
					terms.push( '"' + ui.item.value + '"' );
					// add placeholder to get the comma-and-space at the end
					terms.push("");
					this.value = terms.join(", ");
					return false;
				}
			});
		});
}
