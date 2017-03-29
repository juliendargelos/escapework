main.init('header', [
	'eventsManager'
]);

var header = {
	nav: {
		element: document.querySelector('body > header nav'),
		toggler: document.querySelector('body > header .nav'),
		get isOpen() {
			return this.element.getAttribute('data-open') !== null;
		},
		open: function() {
			this.element.setAttribute('data-open', '');
			this.element.removeAttribute('data-close');
		},
		close: function() {
			this.element.setAttribute('data-close', '');
			this.element.removeAttribute('data-open');
		},
		toggle: function() {
			return this.isOpen ? this.close() : this.open();
		},
		get click() {
			var self = this;
			return function() {
				self.toggle();
			};
		},
		init: function() {
			if(this.element && this.toggler) {
				this.toggler.on('click', this.click);
			}
		}
	},
	init: function() {
		this.nav.init();
	}
};
