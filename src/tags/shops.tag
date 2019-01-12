<shops id={opts.id}>
	
	<p>{ opts.utils.lang.read_i18n(opts.i18n.shops.shops_select, tel) }</p>
	<div class="weui_cells weui_cells_access">
		<a class="weui_cell mod_shop_cell {isCurr ? 'current' : null}" 
			href="javascript:;" onClick={ go_main.bind(this, id) }
			each={shops}>
			<div class="weui_cell_bd weui_cell_primary">
				<p>{name}</p>
			</div>
			<div class="weui_cell_ft"></div>
		</a>
	</div>

	<script>
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,_this = this
		;

		/*
		this.on('update', function(data) {	
		});
		this.on('destruct', function() {
		});
		*/
	
		this.go_main = function(id) {
			utils.do_post('/shops', {
				currentShopId: id,
				fromRoute: decodeURIComponent(params.fromRoute)
			});
		};

		utils.do_get('/shops?currentShopId=' + params.currentShopId).then(
			function(rst) {
				_this.update(rst);
			}
		);
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	@import "../less/mods";
	
	.root_shops,
	.page_shops {
		height: 100%;
		background-color: #F3F1EE;
	}
	#shops {
		>p {
			color: #878787;
			.px2rem(26px);
			.px2rem(70px, line-height);
			.px2rem_4(11px, 0, 0, 33px, padding);
		}
	}
	</style>

</shops>