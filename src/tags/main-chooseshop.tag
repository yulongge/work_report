<main-chooseshop>

	<div class="weui_cells weui_cells_access">
		<a class="weui_cell mod_shop_cell" 
			href="javascript:;"
			onClick={ go_shop.bind(this, id) } >
			<div class="weui_cell_bd weui_cell_primary">
				<p>{name}</p>
			</div>
			<div class="weui_cell_ft">{ opts.i18n.main.toggle_shop }</div>
		</a>
	</div>

	<script>
	var data = opts.data;

	this.update(data);

	this.go_shop = function(id) {
		riot.route('/shops&currentShopId='+ data.id +'&fromRoute=' + encodeURIComponent(opts.from) );
	};
	</script>

	<style scoped type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	@import "../less/mods";

		.weui_cells_access {
			margin-top: 0;
		}
		.weui_cell {
			background: #FAFAFA;
			.px2rem(70px, height);
			.px2rem(35px, border-radius);
			.px2rem(20px, margin);
		}
	</style>
</main-chooseshop>