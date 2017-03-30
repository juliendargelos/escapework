//= require components/core/main

var problemsShow = {
	clues: document.querySelectorAll('.content strong'),
	click: function() {
		this.setAttribute('data-found', '');
	},
	init: function() {
		for(var i = 0; i < this.clues.length; i++) this.clues[i].on('click', this.click);
	}
};

main.exec('problemsShow', [
	'eventsManager'
]);
