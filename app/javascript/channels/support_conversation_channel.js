import consumer from "./consumer";

$(document).ready(function(){
  const chat_id = $("#chatmessagebox").attr('data-id');
  consumer.subscriptions.create({channel: "SupportConversationChannel", id: "support_conversations_" + chat_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Channel Connected!!! To SupportConversationChannel");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      $("#filter_form").trigger("reset");
      console.log(data)
      if(data.body.support_conversation_id== chat_id)
      {
        data = data.body;
        var aDay = 24 * 60 * 60 * 1000;
        console.log(data);
        if (data.recipient_id == data.user_id) {
        } else {
          $(".chat_msg").append(
              '<div class="user_msg">' +
              '<div class="profile_pic">' +
              '<div class="img_blk">' +
              "<img src="+data.user_profile+">" +
              '</div>' +
              '</div>' +
              '<div class="d-flex flex-column">' +
              '<div class="msg">' +
              '<p>' + data.body + '</p>' +
              (data.image !== null ? "<img src="+data.image+">" : '') +
              '</div>' +
              '<p class="msg_time mt-2">' + timeSince(new Date(Date.now())) + '</p>' +
              '</div>' +
              '</div>'
          );


        }
      }
      $(".chat_msg").scrollTop($(".chat_msg")[0].scrollHeight);
    }
  });

  function timeSince(date) {

    var seconds = Math.floor((new Date() - date) / 1000);

    var interval = seconds / 31536000;

    if (interval > 1) {
      return Math.floor(interval) + " years";
    }
    interval = seconds / 2592000;
    if (interval > 1) {
      return Math.floor(interval) + " months";
    }
    interval = seconds / 86400;
    if (interval > 1) {
      return Math.floor(interval) + " days";
    }
    interval = seconds / 3600;
    if (interval > 1) {
      return Math.floor(interval) + " hours";
    }
    interval = seconds / 60;
    if (interval > 1) {
      return Math.floor(interval) + " minutes";
    }
    return " less than a minute";
  }
});