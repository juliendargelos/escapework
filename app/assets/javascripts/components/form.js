main.init('form', [
	'eventsManager',
	'offset'
]);

var form = {
	elements: document.querySelectorAll('form'),
	input: function(field, input) {
		input.on('click', function(event) {
			event.stopPropagation();
		});

		input.on('focus', function() {
			field.setAttribute('data-focus', '');
		});

		input.on('blur', function() {
			field.removeAttribute('data-focus');
			if(this.value == '') field.removeAttribute('data-filled');
			else field.setAttribute('data-filled', '');
		});

		field.focus = function() {
			this.querySelector('input').focus();
		};
	},
	field: function(field) {
		var inputs = field.querySelectorAll('input, textarea, select');

		if(inputs.length > 0) {
			var input = inputs[0];
			field.on('click', function() {
				input.focus();
			});

			for(var i = 0; i < inputs.length; i++) this.input(field, inputs[i]);
		}
	},
	parent: function(field) {
		while(field.tagName != 'FORM') field = field.parentNode;
		return field;
	},
	init: function() {
		for(var i = 0; i < this.elements.length; i++) {
			var fields = this.elements[i].querySelectorAll('.field');

			for(var j = 0; j < fields.length; j++) this.field(fields[j]);
		}
	}
};

