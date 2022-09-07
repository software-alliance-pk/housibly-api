import consumer from "./consumer";

document.addEventListener('turbolinks:load', () => {
  const chat_id = $("#chatmessagebox").attr('data-id');
  consumer.subscriptions.create({channel: "SupportConversationChannel",chat_id: chat_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Channel Connected!!! To SupportConversationChannel"+chat_id);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
    }
  });
});