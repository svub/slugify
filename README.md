Slugify
=======
A collection behaviour (using sewdn:collection-behaviours) adding slugs to your objects.
A slug is a URL-safe string you can use in your route instead of the object's ID so that it is a) more human-readable and b) better in terms of SEO.

Basic use
---------
Say you have a collection called blogpost.
You can add slugs by calling once `blogpost.slugify();` and from that moment on, slugify will monitor insert and update actions and add a slug to each object automatically.

Configuration
-------------
By default, slugify assumes that the title/label of each object (which is used to create a human-readable slug) is in an attribute called "label" and that the slug will be put into the attribute "slug".

So, the default config is like this:
`blogpost.slugify({ attribute: "slug", source: "label" });
By passing a config object, you can adjust it.
Hint: source can be a function, too. It will be called to get the object's label.

Once the slug is generated, it will stay. If you want slugify to create a new slug (e.g. the label has changed), just update the object setting slug to '' and slugify will create a new slug for you.
