:title: HexScan on Ember.js
:section: blue
:tags: blue, ember.js, code
:weight: 20
---
So however trivial this may be it took me like, days to figure out. So What we want is to grab the users latitude & longitude (position) muck it about in ember a bit, and shoot it off to the server for some sweet sweet ruby lovin. Since the HTML5 GeoLocation API is all Javascript and ember is also all java script, should be easy right? Except its tooootaly not *(Well it toootaly is but man what a bitch figurein it out.)* As you'll see its pretty trivial, but not exactly immediately apparent. I could have done it the easy way. But what the fuck is the point of that right? I'm I'm gonna spend three days banging my head on the wall I may as well get something out of it. And I did.

Enlightenment. *(0o.. really)*

Anyway… here is some code:

### So obviously this is doing it wrong
With just straight jQuery.
		
	:::javascript
		
    var GeoLocation;
    
    GeoLocation = (function(location){
        $('#latitude').val(location.coords.latitude),
        $('#longitude').val(location.coords.longitude)
    });
    
    navigator.geolocation.getCurrentPosition(GeoLocation)
    
 Yup where're just getting your digits & setting the value of the two form fields to the right numbers. Some submit action and zoom its off to the server. But yeah…. whats the point of al the ember.js brain licking if were just gonna bypass the whole shebang add send if off with jQuery? *(ember uses jQuery internally so its part of the deal automagicly)* Surely there must be a better way…
 
### And there is…
The ember.js way. First we need some views.

    :::javascript
    
	script type="text/x-handlebars" data-template-name="application"
      | {{ outlet }}
  
    script type="text/x-handlebars" data-template-name="locate"
      | {{ message }}
      | <form id="coordinates">
      |   {{view Ember.TextField valueBinding = "latitude"  }}
      |   {{view Ember.TextField valueBinding = "longitude" }}
      | </form>

What is all this eyeball licking? Well my friend that is handlebars.js *(the third part of the ember.js trinity)* templates, INSIDE a slim template, 'cause sinatra is aces, I'll tell you more about it later, but for now, Trust me.

And then…

    :::javascript
		
	App.LocateRoute = Ember.Route.extend({
      setupController: function(controller, model) {
        navigator.geolocation.getCurrentPosition(controller.geoLocation)
      }
    });

    App.LocateController = Ember.Controller.extend({
      geoLocation: function(location){
        this.set('latitude', location.coords.latitude);
        this.set('longitude', location.coords.longitude);
      }
    });
    
Ya see that? The controller intercepts the model on its way to the view, assigns your digits to the text fields & where ready to mozy on our merry. Except this will not work. In fact it will raise a Type error on `this.set('latitude', location.coords.latitude);` and bitch that `undefined` isn't a function. So what do we do?

###mspisars to the rescue…

>The problem is that navigator.geolocation.getCurrentPosition() runs in window (global) scope so `"this" === window`, so you have to wrap the callback to `navigator.geolocation.getCurrentPosition()` in an anonymous function...

    :::javascript
		
	App.LocateRoute = Ember.Route.extend({
      model: function () {
        return App.Position.create();
      },
      setupController: function (controller, model) {
        this.set('content', model);
        navigator.geolocation.getCurrentPosition(function(res) {
            controller.geoLocation(res);
        });
      }
    });
    
So there you have it. That really wasn't so bad was it?