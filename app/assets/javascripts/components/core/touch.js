main.init('touch');

var touch = {
	get available() {
		return 'ontouchstart' in window || navigator.maxTouchPoints;
	}
};
