# Stealth Bandwidth SMS

The [Stealth](https://github.com/whoisblackops/stealth) Bandwidth SMS driver adds the ability to build your bot using Bandwidth's SMS service.

[![Gem Version](https://badge.fury.io/rb/stealth-bandwidth.svg)](https://badge.fury.io/rb/stealth-bandwidth)

## Supported Reply Types

* Text
* Image
* Audio
* Video
* File
* Delay

Image, Audio, Video, and File reply types will leverage the MMS protocol. It is recommended by Bandwidth that
the content is limited to images, however, this is the full list of supported content types: https://dev.bandwidth.com/faq/messaging/mediaType.html.

If you store your files on S3, please make sure you have set the `content-type` appropriately or Bandwidth might reject your media.

## Service Message

This driver will set `current_message.target_id` to the array of phone numbers the SMS message was delivered to. In most cases the array will just contain a single phone number (the phone number of your bot), but in the case of a group message, it will contain the phone numbers of each recipient in addition to your bot's phone number.
