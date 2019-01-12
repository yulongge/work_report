<msg class="weui_msg" id={opts.id}>
	<div class="weui_icon_area"><i
		class="weui_icon_{type} weui_icon_msg"
		rel={errcode}></i></div>
	<div class="weui_text_area">
		<h2 class="weui_msg_title">{decodeURIComponent(errmsg)}</h2>
		<p class="weui_msg_desc" if={typeof detail !== 'undefined'}>
			{ detail ? decodeURIComponent(detail) : null }
		</p>
	</div>
	<div class="weui_opr_area" if={btns}>
		<p class="weui_btn_area">
			<virtual each={btns}>
				<app-button
					route={route}
					type={type||0} >
						{label}
				</app-button>
			</virtual>
		</p>
	</div>

	<script>
		//basic infos
		var
			args = opts.args
			,params = opts.params
			,data = {
				errcode: args[0]
				,errmsg: args[1]
				,detail: args.length<3 ? void(0) : args[2]
				,type: opts.utils.status(args[0])
			}
		;
		//buttons
		if (params.length) {
			var b = $.grep(params, function(item) {
				return /^btn\d+\=/.test(item);
			});
			if (b.length) {
				var btns = b.slice();
				btns = btns.map(function(item) {
					var
						arr = item.split('=')[1].split('|')
						,label = arr[0]
						,type = arr.length>1 ? arr[1] : null
						,route = arr.length>2 ? arr[2] : null
					;
					return {label:label, type:type, route:route};
				});
				data = $.extend({}, data, {btns:btns});
			}
		}
		this.update(data);
		//TODO detail & btns
	</script>

	<style>
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
	.ab1px() {
	.px2rem(1px, height);
	-webkit-transform: scaleY(1);
	transform: scaleY(1);
}

.weui_panel {
	width: 100%;
    .px2rem(20px, margin-top);
	&::before,
	&::after {
		.ab1px();
		.px2rem(1px, border-width);
	}
}
.weui_panel_hd {
	// .px2rem_2(20px,30px,padding);
	.px2rem_2(28px,30px,padding);
    .px2rem(26px);
	&::after {
		.ab1px();
		.px2rem(1px, border-width);
		//.px2rem(30px, left);
		left: 0;
	}
}

.weui_cells {
    .px2rem(10px, margin-top);
    line-height: 1.41176471;
    .px2rem(34px);
	&::after,
	&::before {
	    .ab1px();
	}
	&::before {
		.px2rem(1px, border-top-width);
	}
	&::after {
		.px2rem(1px, border-bottom-width);
	}
}
.weui_cell {
	// .px2rem_2(20px,30px,padding);
	.px2rem_2(28px,30px,padding);
	&::before {
	    .ab1px();
	    .px2rem(1px, border-top-width);
	    //.px2rem(30px, left);
		left: 0;
	}
}
.weui_cells_access .weui_cell_ft::after{
	.px2rem(16px, height);
    .px2rem(16px, width);
    .px2rem_4(2px, 2px, 0, 0, border-width);
    .px2rem(-1px, top);
}
.weui_cells_access::after {
	display: none;
}

.weui_btn {
	.px2rem(28px, padding-left);
	.px2rem(28px, padding-right);
	.px2rem(36px);
	.px2rem(10px, border-radius);
	.px2rem(20px, margin);
	&.weui_btn_mini {
		.px2rem(28px);
		.px2rem_2(0, 15px, padding);
	}
	&::after {
		.px2rem(20px, border-radius);
		.px2rem(1px, border-width);
	}
}

.weui_toast {
	.px2rem(10px, border-radius);
	width: 15rem;
	margin-left: -7.5rem;
}
.weui_loading_toast .weui_toast_content {
	.px2rem(28px);
	.px2rem(30px, margin-bottom);
}
.weui_loading_leaf:before {
	.px2rem(16px, width);
	.px2rem(6px, height);
	.px2rem(1px, border-radius);
    box-shadow: 0 0 unit(2px/@rem-base,rem) rgba(0,0,0,.0980392);
}

.weui-infinite-scroll {
	.px2rem(48px, height);
	.px2rem(48px, line-height);
	.px2rem(20px, padding);
	.infinite-preloader {
		.px2rem(8px, margin-right);
		.px2rem(-8px, vertical-align);
		.px2rem(40px, width);
		.px2rem(40px, height);
	}
}

.weui_dialog {
	width: 85%;
	left: 50%;
	transform: translateX(-50%) !important;
}
.weui_dialog_hd {
	.px2rem_3(24px, 0, 10px, padding);
}
.weui_dialog_title {
	.px2rem(34px);
}
.weui_dialog_bd {
	.px2rem_2(0,40px,padding);
	.px2rem(30px);
}
.weui_dialog_ft {
	.px2rem(84px, line-height);
	.px2rem(40px, margin-top);
    .px2rem(34px);
	&::after {
	    .ab1px();
		.px2rem(1px, border-top-width);
	}
}

.weui-popup-container {
	z-index: 100;
}

.weui_msg {
	.px2rem(72px, padding-top);
	.weui_icon_area {
		.px2rem(60px, margin-bottom);
	}
	.weui_text_area {
	    .px2rem(50px, margin-bottom);
		.px2rem_2(0, 40px, padding);
	}
	.weui_msg_title {
		.px2rem(10px, margin-bottom);
		.px2rem(40px);
	}
	.weui_msg_desc {
		.px2rem(28px);
	}
	.weui_opr_area{
		.px2rem(50px, margin-bottom);
	}
}
.weui_icon_msg:before {
    .px2rem(208px);
}
.weui_btn_area {
	.px2rem_3(24px,30px,6px, margin);
}

.weui_cells_title {
	.px2rem(26px);
	.px2rem_2(0, 30px, padding);
}

.weui_label {
	.px2rem(105px, width);
}


	</style>
</msg>