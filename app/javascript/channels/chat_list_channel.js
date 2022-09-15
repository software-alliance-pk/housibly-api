import consumer from "./consumer"
document.addEventListener('turbolinks:load', () => {
    consumer.subscriptions.create({channel: "ChatListChannel", id: "user_chat_list_2" }, {
        connected() {
            console.log("Connected to CHat LIST")
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            console.log(data)
            // Called when there's incoming data on the websocket for this channel
        }
    });

});
