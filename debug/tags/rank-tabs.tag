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
	@remFac: 50;
@remUIWidth: 720;

.rem_base() {
	@rem-base: @remUIWidth / @remFac;
}
.px2rem(@px, @name: font-size){
	.rem_base();
	@{name}: unit(@px, px);
    @{name}: unit(@px / @rem-base, rem);
}
.px2rem_2(@px1, @px2, @name:font-size) {
	.rem_base();
	@{name}: unit(@px1, px) unit(@px2, px);
    @{name}: unit(@px1 / @rem-base, rem) unit(@px2 / @rem-base, rem);
}
.px2rem_3(@px1, @px2, @px3, @name:font-size) {
	.rem_base();
	@{name}: unit(@px1, px) unit(@px2, px) unit(@px3, px);
    @{name}: unit(@px1 / @rem-base, rem) unit(@px2 / @rem-base, rem) unit(@px3 / @rem-base, rem);
}
.px2rem_4(@px1, @px2,  @px3, @px4, @name:font-size) {
	.rem_base();
	@{name}: unit(@px1, px) unit(@px2, px) unit(@px3, px) unit(@px4, px);
    @{name}: unit(@px1 / @rem-base, rem) unit(@px2 / @rem-base, rem) unit(@px3 / @rem-base, rem) unit(@px4 / @rem-base, rem);
}

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