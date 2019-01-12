<rank-tabs>
	<div class="top-tabs">
		<virtual each={opts.tabs}>
			<a if={current !== key} 
				href="javascript:;"
				onClick={ toggle.bind(this, key) }>{ label }</a>
			<span if={current === key}
				>{label}</span>
		</virtual>
	</div>

	<script>
	var _this = this;
	this.update({current: opts.current});
	this.toggle = function(key) {
		opts.ob.trigger('toggle', key);
	};
	</script>

	<style scoped type="text/less">
	@import "../less/less-rem";

	:scope {
		overflow: hidden;
	}
	.top-tabs {
		background: #fff;
		border: solid #05bf02;
		.px2rem(1px, border-width);
		.px2rem(10px, border-radius);
		.px2rem(12px*2, margin);
		.px2rem(30px*2, height);
		.px2rem(30px);
		display: flex;
		justify-content: space-around;
		align-items: center;
		overflow: hidden;

		a, 
		span {
			color: #05bf02;
			display: inline-block;
			text-align: center;
		    .px2rem(30px*2, line-height);
		    .px2rem(30px*2, height);
		    flex: 1;
		}
		a {
			border-right: solid #05bf02;
		    .px2rem(1px, border-right-width);
		    &:last-of-type {
		    	border: none;
		    }
		}
		span {
			background: #05bf02;
			color: #fff;
		}
	}
	</style>
</rank-tabs>