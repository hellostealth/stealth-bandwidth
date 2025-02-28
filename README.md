# Stealth Bandwidth SMS

## Compatibility

⚠️ **Version 2.0 is only compatible with Stealth 3.0 [(Pull Request 420)](https://github.com/hellostealth/stealth/pull/420).** ⚠️

While Stealth V2 was a standalone Ruby application, Stealth V3 is a mounted engine within an existing Ruby on Rails application.

## Installation

In your **Rails** app, add the `stealth` and `stealth-bandwidth` gems:

```ruby
gem 'stealth', git: 'https://github.com/hellostealth/stealth.git', branch: '3.0-mountable'
gem 'stealth-bandwidth'
```

## Configurations

Create a Bandwidth Messaging App, and set up the webhook URL to point to your ngrok that forwards requests to your Rails app. You must append `/stealth/<service>`.

For example:
```ruby
https://abc1234.ngrok.io/stealth/bandwidth
```

## Reply Types

### Flow-based Replies

**Inline replies** can be created by calling the `say` method within `Stealth.flow`

```ruby
Stealth.flow :hello do
  state :say_hello do
    say "Hello world!"
  end
end
```

You can use the `send_replies` method within `Stealth.flow` to define the reply in `Stealth.reply`

```ruby
stealth/flows/hello_flow.rb

Stealth.flow :hello do
  state :say_hello do
    send_replies
  end
end

stealth/replies/hello/say_hello.rb

Stealth.reply :hello do
  state :say_hello do
    say "Hello world!"
  end
end
```

☝️ We recommend using the `send_replies` method, when replies are more complex and that you want to keep your `Stealth.flow` dry.
**Note:** To follow naming conventions, in the stealth/replies directory, you must create a subdirectory that matches the **flow name**, and inside it, a file named after the **state name**.

### Suggestions

Though suggestions are not a reply type on their own, they enhance the visual presentation of SMS replies by adding line breaks and formatting options as separate choices.

```ruby
Stealth.flow :animal do
  state :ask_if_like_dogs do
    say("Do you like dogs?", suggestions: ["Yes", "No"])
    update_session_to state: :get_if_like_dogs
  end

  state :get_if_like_dogs do
    handle_message(
      yes: proc { say("Woof") },
      no: proc { say("Too bad...") }
    )
    step_to state: :ask_favorite_animal
  end

  state :ask_favorite_animal do
    say("What's your favorite animal?", suggestions: ["Cat", "Dog", "Sloth"])
    update_session_to state: :get_favorite_animal
  end

  state :get_favorite_animal do
    translated_msg = get_match(
      ['Cat', 'Dog', 'Sloth'], raise_on_mismatch: true
    )
    say("I like #{translated_msg} too!")
  end
end
```

### Delays

**Delays** introduce pauses between text replies, improving user experience.

```ruby
Stealth.reply do
  say "Hello"
  say(reply_type: "delay", duration: "dynamic")
  say "How are you?"
  say(reply_type: "delay", duration: 2)
end
````

The duration can be a **floating point value** (in seconds) or **dynamic**, where the system automatically determines the delay.

To enable automatic delays globally:
```ruby
Stealth.config.auto_insert_delays
```


# Sending Media

Bandwidth supports various MMS file types. For more details, refer to: [Bandwidth Supported MMS File Types](https://support.bandwidth.com/hc/en-us/articles/360014128994-What-MMS-file-types-are-supported)

**You must use a valid URL where the file is hosted.**

### Images

```ruby
Stealth.reply do
  say(
    "Here's an image.",
    reply_type: "image",
    image_url: "https://example.org/image.png"
  )
end
```

### Videos

```ruby
Stealth.reply do
  say(
    "Here's a video.",
    reply_type: "video",
    video_url: "https://example.org/cool_video.mp4"
  )
end
```

### Audio

```ruby
Stealth.reply do
  say(
    "Here's an audio.",
    reply_type: "audio",
    audio_url: "https://example.org/podcast.mp3"
  )
end
```

### Files

```ruby
Stealth.reply do
  say(
    "Here's a PDF file.",
    reply_type: "file",
    file_url: "https://example.org/some.pdf"
  )
end
```
