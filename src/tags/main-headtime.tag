<main-headtime>

	<time>{ time }</time>
	<a href="javascript:;" 
		onClick={ go_time }>{ opts.i18n.main.toggle_time }</a>

	<script>
	var
		tarr = opts.time.split(',')
		,time = opts.utils.lang.read_i18n(
			opts.i18n.time_from_to, 
			tarr[0], 
			tarr[1]
		)
	;
	this.update({time: time});

	this.go_time = function(e) {
		riot.route('/timerange&from='+ opts.from +'&curr=' + opts.time);
	};
	</script>

	<style scoped type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/global";
	@import "../less/mods";

	:scope {
		background-color: rgba(255,255,255,.88);
		.px2rem(80px, height);
		display: flex;
		justify-content: space-between;
		align-items: center;
		.px2rem_2(0, 30px, padding);
		color: rgba(53,53,53,.8);
		.px2rem(28px);
		border-bottom: solid #E4E4E4;
		.px2rem(1px, border-bottom-width);
	}

	a {
		color: #576B94;
		&::after {
			.mod_arrow_after;
		}
	}
	</style>
</main-headtime>