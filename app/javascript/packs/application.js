// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import $ from 'jquery';
global.$ = jQuery;
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "./jquery.min"
import "./bootstrap.bundle.min"
import "./k_datepicker.min"
import "./main"


Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).on('turbolinks:load', function() {

    $(".datepicker").datepicker({
        // multidate: true,
        format: "mm-dd-yyyy",
        // todayHighlight: true,
        // multidateSeparator: ",  ",
    });

    $("#reset_password_button").click(function(){
        if ($("#error_explanation > ul > li").length >0)
        {

        }
        else
        {
            $(".customblk_id").removeClass("d-none");
        }
    });
    $("#selectedallcheckboxes").click(function (){
        this.checked ? selects() : deSelect()
    });

    $("#csearchbtn").keyup(function (){
        var word = $(this).val();
        $("#searchformc").trigger('click');
    });
    $('input[name="selected_checkbox"]').click(function() {
        let values = [];
        let checkboxes = document.querySelectorAll('input[name="selected_checkbox"]:checked');
        if(checkboxes.length > 0)
        {
            checkboxes.forEach((checkbox) => {
                values.push(checkbox.id);
            });
        }
        let href = $("#downloadbtncustom").attr('href');
        let new_href =  href.split('=')
        new_href = new_href[0] + "=" + values
        $("#downloadbtncustom").attr('href',new_href);
    });

    function selects(){
        let values = [];
        var ele=document.getElementsByName('selected_checkbox');
        for(var i=0; i<ele.length; i++){
            if(ele[i].type=='checkbox')
                ele[i].checked=true;
            values.push(ele[i].id);
        }
        let href = $("#downloadbtncustom").attr('href');
        let new_href =  href.split('=')
        new_href = new_href[0] + "=" + values
        $("#downloadbtncustom").attr('href',new_href);
    }
    function deSelect(){
        let values = [];
        var ele=document.getElementsByName('selected_checkbox');
        for(var i=0; i<ele.length; i++){
            if(ele[i].type=='checkbox')
                ele[i].checked=false;
            values.push([]);
        }
        let href = $("#downloadbtncustom").attr('href');
        let new_href =  href.split('=');
        $("#downloadbtncustom").attr('href',new_href[0]+"=");
    }
    $("#guideline_select").change(function (){
        let id = $(this).val();
        let select_id_value =  $(this).find(":selected").attr('data-page');
        document.getElementById("guide_lines_"+id).click()
        $("#guidelinepagevalue").val(select_id_value);
    });
    $("#submitmessagebutton").click(function ()
    {
        $("#typemessage").val("");
    });
  $(".pressdeactivelink").click(function (){
      let id = $(this).attr("id");
      $("#active_user_"+id).attr('hidden',true);
      $("#deactive_user_"+id).attr('hidden',false);
      $(".pressactivelinkwith_"+id).attr('hidden',false);
      $(".pressdeactivelinkwith_"+id).attr('hidden',true);
  });

  $(".pressactivelink").click(function (){
      let id = $(this).attr("id");
      $("#active_user_"+id).attr('hidden',false);
      $("#deactive_user_"+id).attr('hidden',true);
      $(".pressactivelinkwith_"+id).attr('hidden',true);
      $(".pressdeactivelinkwith_"+id).attr('hidden',false);
  });

    $("#clickaddphoto").click(function (){
        $("#submitaddphoto").trigger('click');
    });

    $("#clickaddfile").click(function (){
        $("#submitaddfile").trigger('click');
    });

    $("#submitbtnclick").click(function (){
      const html_content = $("#submitcontentfieldvalue").html();
      $("#submitcontentfield").val(html_content)
      $("#customsavebutton").trigger('click');
    })
    var selected_id_option =  $("#guideline_select").find(":selected").attr('data-page');
    $("#guidelinepagevalue").val(selected_id_option);
    // $(".chat_msg").scrollTop($(".chat_msg")[0].scrollHeight);

    $(".customjobclass").click(function (){
        let id = $(this).attr('id');
        $(".removeathis_"+id).trigger('click');
        $("#title_of_job_"+id).hide();
    })
});
