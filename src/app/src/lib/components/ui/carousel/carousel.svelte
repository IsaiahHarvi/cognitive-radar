<script lang="ts">
	import {
		type CarouselAPI,
		type CarouselProps,
		type EmblaContext,
		setEmblaContext
	} from './context.js';
	import { cn } from '$lib/utils.js';

	let {
		opts = {},
		plugins = [],
		setApi = () => {},
		orientation = 'horizontal',
		class: className,
		children,
		...restProps
	}: CarouselProps = $props();

	let carouselState = $state<EmblaContext>({
		api: undefined,
		scrollPrev,
		scrollNext,
		orientation,
		canScrollNext: false,
		canScrollPrev: false,
		handleKeyDown,
		options: opts,
		plugins,
		onInit,
		scrollSnaps: [],
		selectedIndex: 0,
		scrollTo
	});

	setEmblaContext(carouselState);

	function scrollPrev() {
		carouselState.api?.scrollPrev();
	}
	function scrollNext() {
		carouselState.api?.scrollNext();
	}
	function scrollTo(index: number, jump?: boolean) {
		carouselState.api?.scrollTo(index, jump);
	}

	function onSelect(api: CarouselAPI) {
		if (!api) return;
		carouselState.canScrollPrev = api.canScrollPrev();
		carouselState.canScrollNext = api.canScrollNext();
		carouselState.selectedIndex = api.selectedScrollSnap();
	}

	function handleKeyDown(e: KeyboardEvent) {
		if (e.key === 'ArrowLeft') {
			e.preventDefault();
			scrollPrev();
		} else if (e.key === 'ArrowRight') {
			e.preventDefault();
			scrollNext();
		}
	}

	$effect(() => {
		setApi(carouselState.api);

		if (carouselState.api) {
			onSelect(carouselState.api);
			carouselState.api.on('select', onSelect);
			carouselState.api.on('reInit', onSelect);
		}

		return () => {
			carouselState.api?.off('select', onSelect);
		};
	});

	function onInit(event: CustomEvent<CarouselAPI>) {
		carouselState.api = event.detail;

		carouselState.scrollSnaps = carouselState.api.scrollSnapList();
	}
</script>

<div class={cn('relative', className)} role="region" aria-roledescription="carousel" {...restProps}>
	{@render children?.()}
</div>
