:title: Hello Starshine!
:section: home
:tags: home, anotherawesometag,
:weight: 0
---
### The Earth Says Hello!  
Articles with 'home' in the `:section:` tag will be displayed at the site root `'/'`. The string on the `:title:` line will be used as the H2 title of this article. Articles in the 'home' section will be ordered by the value of `:weight:`, the more `:weight:` the farther down the page the article will appear.  

Edit this article to create your first front page article. duplicate & edit this file to create more articles. set the `:weight:` tag to order the articles on your home page.

You must run `rake development:deply` from the site root after editing articles to update the articles in the database. Automatic deploy & images are not suported in this version. Images may however be hotlinked useing standard markdown syntax.

If this site is hosted on Heroku, you must run `heroku run rake --trace devolopment:deploy` from the local site root to populate the postgres database *(the db on heroku must be provisoned befor the initial deploy)*

####This section is Ipsum text & means nothing
Donec ullamcorper nulla non metus auctor fringilla. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Nulla vitae elit libero, a pharetra augue. Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Cras mattis consectetur purus sit amet fermentum.

Sed posuere consectetur est at lobortis. Maecenas faucibus mollis interdum. Nulla vitae elit libero, a pharetra augue. Nulla vitae elit libero, a pharetra augue. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Maecenas sed diam eget risus varius blandit sit amet non magna.