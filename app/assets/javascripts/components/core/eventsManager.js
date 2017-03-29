main.init('eventsManager');

var eventsManager = {
	on: function(event, callback, element, useCapture) {
		switch(event) {
			case 'touchdown':
				if(touch.available) this.on('touchstart', callback, element, useCapture);
				else this.on('mousedown', callback, element, useCapture);
				break;
			case 'touchup':
				if(touch.available) this.on('touchend', callback, element, useCapture);
				else this.on('mouseup', callback, element, useCapture);
				break;
			default:
				element.addEventListener(event, callback, useCapture === undefined ? false : useCapture);
		}
	},
	no: function(event, callback, element) {
		switch(event) {
			case 'touchdown':
				if(touch.available) this.no('touchstart', callback, element);
				else this.no('mousedown', callback, element);
				break;
			case 'touchup':
				if(touch.available) this.no('touchend', callback, element);
				else this.no('mouseup', callback, element);
				break;
			default:
				element.removeEventListener(event, callback);
		}
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
