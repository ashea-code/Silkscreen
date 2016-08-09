## Silkscreen

Flash is a tool (kinda).

This is a tool for animations exported from Flash. It turns them into transparent (no stage background) Quicktime files so they can be composed in something like After Effects in post-production.

It doesn't do much else. It's not the best code. But it does a job!

If you just want to download it, jump to the [Releases](https://github.com/AaronShea/Silkscreen/releases).

### What?

This was a weekend hack project for a friend and animator [Dinnerjoe](https://www.youtube.com/user/Dinnerjoe). After he asked me to fix an existing tool to help encode SWF files into a transparent Quicktime video, I just went on a binge of weekend programming making this thing.

#### Things it does and how you do them

1. You pick a frame rate, width, height and `.mov` file to export to.
2. Next you select the SWF to encode.
3. Silkscreen will play the file in a new window, capture all the frames and encode them into a transparent video file.

It will play all movie clips, run all action script etc.

It will record it exactly the way it plays in Flash player. No mucking about with importing the SWF into AE.

#### Things it does not do

**Audio**

It wasn't really the goal of this tool to make an all purpose SWF to video converter. It's meant to be an animation tool where final audio mixing is assumed to be done in post-production.

#### Free?

Yup, and under the MIT license. Have at it. Though if you use it for your animations I'd really appreciate it if you'd credit the software and myself. That's optional though.

#### Why?

Because Flash.

(Also Haxe is pretty cool)
