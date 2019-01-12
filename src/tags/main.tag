<main id={opts.id}>
	
	<header></header>
	<section></section>
	<footer>
		<div></div>
		<menu></menu>
	</footer>

	<script>
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,_this = this
		;

		utils.do_get('/main?time=' + (params.time||'') ).then(
			function(rst) {
				//头部
				utils.load_tag('main-headtime', {
					from: 'main',
					time: rst.time
				}, 'header');
				//主体
				rst.data.forEach(function(item) {
					var ar = document.createElement('article');
					var sc = document.querySelector('#' + opts.id + ' section');
					utils.load_tag('main-box', {
						data: item
					}, ar);
					sc.appendChild(ar);
				});
				//尾部门店选择
				if ('shop' in rst && rst.shop.name) {
					utils.load_tag('main-chooseshop', {
						data: rst.shop,
						from: '/'
					}, 'footer div');
				}
				//尾部tabs
				utils.load_tag('main-foottabs', {
					current: 'chart',
					time: params.time
				}, 'footer menu');
			}
		);
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	
	.root_main,
	.page_main {
		height: 100%;
	}
	#main {
		height: 100%;
		display: flex;
		flex-direction: column;

		section {
			flex: 1;
			overflow-x: hidden;
			overflow-y: auto;
			-webkit-overflow-scrolling:touch;
		}
	}
	</style>

</main>