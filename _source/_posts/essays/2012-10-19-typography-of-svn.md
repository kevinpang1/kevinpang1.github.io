---
title: "The Typography behind the Signal vs. Noise redesign"
category: writes
svn: 3285
preview: Dissecting my typography-first redesign I did for the 37signals blog
---
## We’ve been sharing our process and company values on Signal vs. Noise since 1999. It’s where we’ve planted the seeds for Getting Real and REWORK. And for many readers, it’s their first taste of 37signals. Yet, we haven’t given the look and feel any serious attention since 2005.

So I decided to tackle a much-needed redesign. In planning the overhaul, I wanted to focus on creating a beautiful, clear, focused reading experience.

## Designing Outward
“Blog” has such a temporary, read-and-forget tone to it. On SvN, we take our time writing and editing every article. So rather than treating this like a “blog,” I shifted the mindset to that of a tenured publication. So, the entire redesign process started with typesetting the post, and designing outward.

Instead of poring over other blogs, I spent a week studying books, magazines, and of course, Bringhurst. Capturing the right feel for body text was step one—it sets the tone from here on out.

Perhaps it’s me, but there’s something about 13px sans-serif faces on the web that feels like “my Rails app just spit this out of a database.” I want you to read articles, not text rendered on a screen. Kepler, set at a comfortable size, wound up being a beautiful serif that added the touch of humanity I was looking for. Setting the headlines in Acta added to the look I was going for, and Freight Sans wound up being a great sans-serif pairing.

More often than not, company blogs are littered with pitches for their product. I don’t want to throw new job opportunities at you right away. I don’t want to ask you to subscribe to our RSS feed when you haven’t even read anything yet. These rules informed the layout: content first, everything else second.

I often hear that mobile experiences tend to feel more focused than the desktop counterpart. I agree, mostly. But there’s a stark similarity that mobile devices share with physical books that desktop browsers don’t: a consistent canvas size.

Designers, especially those transitioning from print to web, yearn for that controlled page size. We’re lucky to have it on phones, but the varying sizes of desktop browsers throw us in a loop. Despite that, I was bullish on keeping the width of the desktop text at a comfortable 65-70 characters per line no matter how long your browser becomes. I was steadfast in keeping the content on top—not hugged by filters, settings, search bars and ads. More space in your window doesn’t mean you have to fill it.

## Responsive as I go
Signal vs. Noise is a Rails app. I got my hands dirty digging through every view, restructuring the markup as I went along. (And Noah fixed all the things I broke. Thanks Noah!) During the design of each page, I styled mobile views at the same time as the desktop. Writing custom Sass @mixins for responsive views sped this process up immensely.

Like JZ mentioned, while the multiple @media query instances aren’t ideal, it’s a better trade off with clarity in code.

## Designing in the open
There’s plenty more I’ll share, including the concepts behind the waveforms, the language, the new writers page, and our new post editor. This may be just a blog, but it’s our blog. Our ideas. They matter to us, and we want you to feel like they matter to you. We’ll continue to make this—and the rest of our public facing sites—better. And we’ll continue to design in the open.