<main-foottabs>

	<div class="chart {
		!isRanking ? 'current' : null
	}" onClick={
		!isRanking ? null : go_tab('main')
	}>{ opts.i18n.main.label_chart }</div>
	<div class="ranking {
		isRanking ? 'current' : null
	}" onClick={
		isRanking ? null : go_tab('ranking')
	}>{ opts.i18n.main.label_rank }</div>

	<script>
	this.update({
		isRanking: opts.current === 'ranking'
	});
	this.go_tab = function(to) {
		return function(e) {
			var r = to + '&time=' + (opts.time||'');
			riot.route(r);
		}
	};
	</script>

	<style scoped type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	@import "../less/mods";

	//首页和排行页下方的tab
	:scope {
		border-top: 1px solid #DCDCDC;
		.px2rem(1px, border-top-width);
		.px2rem(120px, height);
		display: flex;
		align-items: stretch;
		background: #fff;
	}
	div {
		flex: 1;
		display: inline-flex;
		flex-direction: column;
	    justify-content: flex-end;
	    align-items: center;
		border-right: 1px solid #E4E4E4;
		background: #fff;
		color: #888888;
		.px2rem(24px);
		.px2rem(44px, line-height);
		&:last-of-type {
			border-right: none;
		}
		&.current {
			background: rgba(234,234,234,.26);
			color: #09BB07;
		}
		&::before {
			content: ' ';
			display: block;
			.px2rem(56px, width);
			.px2rem(56px, height);
			.bg-size(contain);
			background-position: 50% 50%;
			background-repeat: no-repeat;
		}

		&.chart {
			&::before {background-image: url('@{img}tab_chart_off.png')}
			&.current::before {background-image: url('@{img}tab_chart_on.png')}
		}
		&.ranking {
			&::before {background-image: url('@{img}tab_rank_off.png')}
			&.current::before {background-image: url('@{img}tab_rank_on.png')}
		}
	}
	</style>
</main-foottabs>