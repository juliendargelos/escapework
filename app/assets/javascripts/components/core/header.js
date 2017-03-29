main.init('header', [
	'eventsManager'
]);

var header = {
	nav: {
		element: document.querySelector('body > header nav'),
		toggler: document.querySelector('body > header .nav'),
		transition: 600,
		breakpoint: 800,
		get isOpen() {
			return this.element.getAttribute('data-open') !== null;
		},
		get isClosed() {
			return this.element.getAttribute('data-close') !== null;
		},
		get hasState() {
			return this.isOpen || this.isClosed;
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
		clear: function() {
			this.element.removeAttribute('data-open');
			this.element.removeAttribute('data-close');
		},
		get click() {
			var self = this;
			return function() {
				self.toggle();
			};
		},
		get resize() {
			var self = this;

			return function() {
				if(self.hasState && window.innerWidth >= self.breakpoint) self.clear();
			};
		},
		init: function() {
			if(this.element && this.toggler) {
				this.toggler.on('click', this.click);
				window.on('resize', this.resize);
			}
		}
	},
	init: function() {
		this.nav.init();
	}
};
