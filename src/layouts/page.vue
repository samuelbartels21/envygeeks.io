<template>
	<layout>
		<main class="content page">
			<header class=page__title>
				<h1>{{ title }}</h1>
			</header>
			<slot/>
		</main>
	</layout>
</template>

<script>
	import layout from "~/layouts/default.vue"
	export default {
		components: {
			layout
		},
    props: [
    	"title"
    ]
	}
</script>

<style lang="scss">
	.page {
		font-size: 1.125rem;
		line-height: 2.5rem;
		color: #58585B;


		p {
			margin: 2rem 0;
			padding: 0;
		}

		&__title {
			h1 {
				font-size: 3rem;
				line-height: 4rem;
				text-align: center;
				font-style: italic;
				margin: 3rem 0;
			}
		}
	}
</style>
