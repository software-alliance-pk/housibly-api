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
import "./bootstrap.bundle.min"
import "./datepicker.min"
import "./main"


Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).on('turbolinks:load', function() {
    $("#guideline_select").change(function (){
        var id = $(this).val();
        var select_id_value =  $(this).attr('data-page');
        console.log(select_id_value);
        document.getElementById("guide_lines_"+id).click()
    });
  $(".pressdeactivelink").click(function (){
      var id = $(this).attr("id");
      $("#active_user_"+id).attr('hidden',true);
      $("#deactive_user_"+id).attr('hidden',false);
      $(".pressactivelinkwith_"+id).attr('hidden',false);
      $(".pressdeactivelinkwith_"+id).attr('hidden',true);
  });

  $(".pressactivelink").click(function (){
      var id = $(this).attr("id");
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
    var selected_id_option =  $("#guideline_select").attr('data-page');
    console.log(selected_id_option);
    $(".chat_msg").scrollTop($(".chat_msg")[0].scrollHeight);
})
