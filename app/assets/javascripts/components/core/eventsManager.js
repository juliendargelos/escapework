main.init('eventsManager');

var eventsManager = {
	on: function(event, callback, element, useCapture) {
		element.addEventListener(event, callback, useCapture === undefined ? false : useCapture);
	},
	no: function(event, callback, element) {
		element.removeEventListener(event, callback);
	},
	apply: function(element) {
		element.on = function(event, callback) {window.eventsManager.on(event, callback, this);};
		element.no = function(event, callback) {window.eventsManager.no(event, callback, this);};
	},
	init: function() {
		this.apply(window);
		this.apply(Node.prototype);
	}
};

