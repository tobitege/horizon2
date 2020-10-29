GameHUDRemover = (function()
    local this = HorizonModule("Stock HUD remover", "Removes the stock game HUD", "Start", true, 0)

    this.Stop = function()
        system.print("Showing UI")
        system.print([[
            <style>
            #reticle_crosshair_wrapper,
            #action_bar,
            #BuildHelperButtonZone,
            #main_chat_notification_icon,
            #persistent_notification,
            #playerStatus_wrapper,
            #custom_screen_click_layer,
            #minimap_bezel,
            #minimap_face,
            #clip_mask,
            #minimap_blips
            { display: block !important; }
            #minimap {
                width: 23.14814815vh;
                height: 23.14814815vh;
                top: 2.77777778vh;
                right: 2.77777778vh;
                z-index: 1;
            }
            #main-chat, #main-chat > * {
                user-select: none !important;
                pointer-events: all !important;
            }
            #main-chat > .message_queue {
                background: rgba(0, 10, 26, 0.6) !important;
            }
            </style>
        ]])
    end
    this.Update = function()
        system.print("Hiding UI")
        system.print([[
            <style>
                #reticle_crosshair_wrapper,
                #action_bar,
                #BuildHelperButtonZone,
                #main_chat_notification_icon,
                #persistent_notification,
                #playerStatus_wrapper,
                #custom_screen_click_layer,
                #minimap_bezel,
                #minimap_face,
                #clip_mask,
                #minimap_blips
                { display: none !important; }
                #minimap {
                    width: 20vh;
                    height: 20vh;
                    top: -1vh;
                    right: calc(50vw - (20vh / 2));
                    z-index: -100;
                }
                #main-chat, #main-chat > * {
                    user-select: all !important;
                    -webkit-user-select: all !important;
                    pointer-events: all !important;
                    cursor: text !important;
                }
                #main-chat > .message_queue {
                    background: transparent !important;
                }
            </style>
        ]])
    end

    Horizon.Event.Stop.Add(this.Stop)

    return this
end)()