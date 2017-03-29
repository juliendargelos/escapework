main.init('offset');

var offset = {
	left: function(element) {
		var left = 0;
	    do {
			if(!isNaN(element.offsetLeft)) left += element.offsetLeft;
	    } while(element = element.offsetParent);

	    return left;
	},
	top: function(element) {
		var top = 0;
	    do {
			if(!isNaN(element.offsetTop)) top += element.offsetTop;
	    } while(element = element.offsetParent);

	    return top;
	},
	apply: function(element) {
		Object.defineProperties(element, {
			offset: {
				get: function() {
					var self = this;
					return {
						get left() {
							return window.offset.left(self);
						},
						get top() {
							return window.offset.top(self);
						},
						get width() {
							return self.offsetWidth;
						},
						get height() {
							return self.offsetHeight;
						}
					};
				}
			}
		});
	},
	init: function() {
		this.apply(Node.prototype);
	}
};

