import 'frontend-js-spa-web/liferay/init.es';

const { reduce, forEach } = Array.prototype;

const CANDIDATES_SELECTOR = '[data-senna-transition-id]';
const NO_TRANSFORM = 'translate(0px, 0px) scale(1, 1)';

const query = selector => {
	try {
		return document.querySelector(selector);
	}
	catch (e) {
		return null;
	}
};

const clone = (node, ancestor, contentSelector) => {
	const outer = document.createElement('div');

	if (ancestor) {
		outer.innerHTML = ancestor.outerHTML;

		const content = contentSelector && outer.querySelector(contentSelector) || outer.children[0];

		content.innerHTML = node.outerHTML;
	}
	else {
		outer.innerHTML = node.outerHTML;
	}

	forEach.call(outer.querySelectorAll(CANDIDATES_SELECTOR), node => {
		node.removeAttribute('data-senna-transition-id');
	});

	const clone = outer.children[0];

	forEach.call(
		clone.querySelectorAll('[id]'),
		node => node.removeAttribute('id')
	);

	return clone;
};

export const indexNodes = root => {
	if (!root) {
		return [];
	}

	const { pageYOffset, pageXOffset } = window;
	const { top: rootTop, left: rootLeft } = root.getBoundingClientRect();

	return reduce.call(
		root.querySelectorAll(CANDIDATES_SELECTOR),
		(memo, node) => {
			const id = node.getAttribute('data-senna-transition-id');
			const ancestor = query(node.getAttribute('data-senna-transition-ancestor'));
			const contentSelector = node.getAttribute('data-senna-transition-ancestor-content-selector')

			const { height, left, top, width } = node.getBoundingClientRect();

			if (id) {
				memo[id] = {
					ancestor,
					contentSelector,
					id,
					node,
					height,
					left: pageXOffset + left - rootLeft,
					top: pageYOffset + top - rootTop,
					width
				};
			}

			return memo;
		},
		{}
	);
};

export const calculateTransform = (from, to) => {
	const tx = to.left - from.left;
	const ty = to.top - from.top;
	const sw = to.width / from.width;
	const sh = to.height / from.height;

	return `translate(${tx}px, ${ty}px) scale(${sw}, ${sh}) rotateY(0deg)`;
};

export function transitionFn(from, to) {
	if (from) {
		from.style.display = 'block';
	}

	if (to) {
		to.style.display = 'block';
	}

	const before = indexNodes(from);
	const after = indexNodes(to);

	if (from) {
		from.style.display = 'none';
		from.classList.remove('flipped');
	}

	if (to) {
		to.style.display = 'block';
		to.classList.add('flipped');
	}

	const beforeIds = Object.keys(before);
	const afterIds = Object.keys(after);

	if (beforeIds.length && afterIds.length) {
		const { top: rootTop, left: rootLeft } = to.getBoundingClientRect();

		beforeIds.forEach(id => {
			if (id in after) {
				const pre = before[id];
				const post = after[id];

				const preClone = clone(pre.node, pre.ancestor, pre.contentSelector);
				const postClone = clone(post.node, post.ancestor, post.contentSelector);

				pre.node.style.opacity = 0;

				preClone.style.position = 'absolute';
				preClone.style.zIndex = '499';
				preClone.style.top = (rootTop + pre.top) + 'px';
				preClone.style.left = (rootLeft + pre.left) + 'px';
				preClone.style.width = pre.width + 'px';
				//preClone.style.height = pre.height + 'px';
				preClone.style.margin = '0px';
				preClone.style.transform = NO_TRANSFORM;
				preClone.style.transformOrigin = '0px 0px';
				preClone.style.pointerEvents = 'none';

				preClone.style.opacity = 1;

				post.node.style.opacity = 0;

				postClone.style.position = 'absolute';
				postClone.style.zIndex = '499';
				postClone.style.top = (rootTop + post.top) + 'px';
				postClone.style.left = (rootLeft + post.left) + 'px';
				postClone.style.width = post.width + 'px';
				//postClone.style.height = post.height + 'px';
				postClone.style.margin = '0px';
				postClone.style.transform = calculateTransform(post, pre);
				postClone.style.transformOrigin = '0px 0px';
				postClone.style.pointerEvents = 'none';

				postClone.style.opacity = 0;

				preClone.style.transition = 'all 400ms';
				postClone.style.transition = 'all 400ms';

				to.appendChild(preClone);
				to.appendChild(postClone);

				setTimeout(function () {
					preClone.style.transform = calculateTransform(pre, post);
					preClone.style.opacity = 0;

					postClone.style.transform = NO_TRANSFORM;
					postClone.style.opacity = 1;

					[ preClone, postClone ].forEach(node => {
						node.addEventListener('transitionend', event => {
							if (node.parentNode) {
								node.parentNode.removeChild(node);
							}

							post.node.style.opacity = 1;
						});
					});
				}, 0);
			}
		});
	}
}

export function init() {
	const surface =
		Liferay.SPA &&
		Liferay.SPA.app &&
		Liferay.SPA.app.surfaces &&
		Liferay.SPA.app.surfaces[document.body.id];

	if (!surface) {
		return Liferay.once('SPAReady', init);
	}

	surface.setTransitionFn(function () {
		try {
			return transitionFn.apply(this, arguments);
		}
		catch (e) {
			console.error(e);
		}
	});
}
