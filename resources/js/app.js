import { createInertiaApp } from '@inertiajs/svelte';
import { mount } from 'svelte'; // Correctly import mount from Svelte

createInertiaApp({
    resolve: (name) => {
        const pages = import.meta.glob('./Pages/**/*.svelte', { eager: true });
        return pages[`./Pages/${name}.svelte`];
    },
    setup({ el, App, props }) {
        mount(App, { target: el, props }); // Use mount instead of render
    },
});
