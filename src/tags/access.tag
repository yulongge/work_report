<access class="cell" id={opts.id}>
	<div class="no-access">{ $k.noaccess }</div>

	<script>
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,_this = this
			,data
		;

		_this.update({
			$k: i18n.access
		});
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";

	.no-access {
		.px2rem(160px, margin-top);
		.px2rem(220px, padding-top);
		.px2rem(30px, font-size);
		text-align: center;
		color: #aaa;
		background: url('@{img}no_access.png') no-repeat top center;
	}
	</style>

</access>
