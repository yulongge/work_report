<timerange class="cell" id={opts.id}>

	<div class="weui_cells_title head">
		<p>{ $k.title }</p>
		<a href="javascript:;" onClick={ make_today }>{ $k.label_today }</a>
		<a href="javascript:;" onClick={ make_yesterday }>{ $k.label_yesterday }</a>
	</div>
	<form name="form1" onsubmit="return false">
		<ul class="weui_cells weui_cells_form">
			<li class="weui_cell">
				<div class="weui_cell_bd field">
					<p id="tgr1">{yesterday}</p>
					<p class="to">{$k.label_to}</p>
					<p id="tgr2">{today}</p>
				</div>
			</li>
		</ul>
		<app-button onClick={ onsubmit }>{ parent.$k.btn_login }</app-button>
	</form>

	<script>
		/*if ( !(new RegExp(ROUTE_BASE_CHAR + 'time')).test(location.href) ) {
			this.unmount();
			return;
		}*/
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,tarr = params.curr
				? params.curr.split(',')
				: null
			,lCale = window['lunar-cale']
			,_this = this
			,_caleLock = false
			,_valid = true
			,enableBtn = function(bool) {
				var submit_btn = _this.form1.querySelector('.weui_btn');
				if (bool) {
					submit_btn.classList.add('weui_btn_primary');
					submit_btn.classList.remove('weui_btn_disabled');
					submit_btn.classList.remove('weui_btn_default');
				} else {
					submit_btn.classList.remove('weui_btn_primary');
					submit_btn.classList.add('weui_btn_disabled');
					submit_btn.classList.add('weui_btn_default');
				}
				submit_btn = null;
				_valid = bool;
			}
			,bindTriggerClick = function(which, idx) {
				var lc = new lCale({
					mode: lCale.SOLAR,
					startYear: 1970,
					endYear: moment().year(),
					initShownYMD: tarr
						? idx === 1
							? tarr[0]
							: tarr[1]
						: void(0),
					selectCallback: function(y,m,d,lunar) {
					},
					closeCallback: function(y,m,d,lunar) {
						_caleLock = false;   
						var target = idx === 1 ? 'yesterday' : 'today';
						var obj = {};
						obj[target] = [y,m,d].join('-');
						_this.update(obj);

						if (moment(_this.tgr1.innerHTML).valueOf() > moment().valueOf()
							|| moment(_this.tgr2.innerHTML).valueOf() > moment().valueOf()) {
							alert('最晚只能选择当天');
							enableBtn(false);
							return;
						}
						if (moment(_this.tgr1.innerHTML).valueOf() > moment(_this.tgr2.innerHTML).valueOf()) {
							alert('结束日期不可早于开始日期');
							enableBtn(false);
							return;
						}
						enableBtn(true);
					}
				});
				which.addEventListener('click', function(e) {
					if (_caleLock) return;
					_caleLock = true;
					lc.show();
				});
				_this.cale = lc;
			}
			,get_today = function() {
				return moment().format('YYYY-MM-DD');
			}
			,get_yesterday = function() {
				return moment().add(-1, 'days').format('YYYY-MM-DD')
			}
			,do_route = function(isFlush, time1, time2) {
				var r = isFlush
					? ['timerange&curr=', time1, ',', time2, '&from=', params.from]
					: [params.from, '&time=', time1, ',', time2];
				riot.route(r.join(''));
			}
		;

		this.update({
			$k: i18n.time,
			today: tarr ? tarr[1] : get_today(),
			yesterday: tarr ? tarr[0] : get_yesterday()
		});
		
		bindTriggerClick(this.tgr1, 1);
		bindTriggerClick(this.tgr2, 2);

		this.make_today = function(e) {
			do_route(true, get_today(), get_today());
		};
		this.make_yesterday = function(e) {
			do_route(true, get_yesterday(), get_yesterday());
		};

		this.onsubmit = function(e) {
			if (!_valid) return;
			do_route(false, _this.tgr1.innerHTML, _this.tgr2.innerHTML)
		};

		this.on('destruct', function() {
			_this.cale && _this.cale.hide();
		});
	</script>

	<style type="text/less">
	@img: "/img/";
@page-bk: #f5f5f5;


	.border-radius(...){
  -webkit-border-radius: @arguments;
     //-moz-border-radius: @arguments;
          border-radius: @arguments;
}
.box-shadow(...){
  -webkit-box-shadow: @arguments;
     //-moz-box-shadow: @arguments;
          box-shadow: @arguments;
}
.box-sizing(...) { //content-box|border-box|padding-box
	-webkit-box-sizing: @arguments;
	//-moz-box-sizing: @arguments;
	box-sizing: @arguments;
}
.font-smoothing(@type:antialiased){ //none|subpixel-antialiased|antialiased
	-webkit-font-smoothing: @type;
			font-smoothing: @type;
}
.circle(@diameter, @border-width: 0){
	display: inline-block;
	.size(@diameter, @diameter);
	.border-radius( unit(ceil((@diameter + @border-width * 2) / 2), px) );
}
.gradient(@from, @to){
	background-image: -webkit-gradient(linear, 0 0, 0 bottom, from( @from ), to( @to ));
}
.gradient-x(@from, @to){
	background-image: -webkit-gradient(linear, 0 0, right 0, from( @from ), to( @to ));
}
.gradient-r(@from, @to, @radius){
	background-image: -webkit-gradient(radial, center center, 0, center center, @radius, from( @from ), to( @to ));
}
.nowrap(){
	white-space:nowrap;
}
.wrap(){
  text-wrap: wrap;
  white-space: -moz-pre-wrap;
  word-wrap: break-word;
  word-break: break-all;
}
.no-text(){
	text-indent:-9999px;
	direction: ltr;
}
.min-size(@w,@h){
	min-width: unit(@w, px);
	min-height: unit(@h, px);
}
.max-size(@w,@h){
	max-width: unit(@w, px);
	max-height: unit(@h, px);
}
.font(@size; @line-height){
	font-size: unit(@size, px);
	line-height: unit(@line-height, px);
}
.font(@size; @line-height; @weight){
	font-size: unit(@size, px);
	line-height: unit(@line-height, px);
	font-weight: @weight;
}
.font_rem(@size; @line-height; @weight){
	.px2rem(unit(@size, px));
	.px2rem(unit(@line-height, px), line-height);
	font-weight: @weight;
}
.rel-obj(){
	position:relative;
}
.abs-obj(@p:tl) when (@p = tl){
	position:absolute;
	top:0;
	left:0;
}
.abs-obj(@p:tl) when (@p = rb){
	position:absolute;
	bottom:0;
	right:0;
}
.float-obj(@float:left){
	display:inline-block;
	float:@float;
}
.border(@color; @weight: 1px; @style: solid){
	border: @weight @style @color;
}
.size(@w, @h){
	width: unit(@w, px);
	height: unit(@h, px);
}
.size_rem(@w, @h){
	.px2rem(unit(@w, px), width);
	.px2rem(unit(@h, px), height);
}
.square(@diameter){
	.size(@diameter, @diameter);
}
.square_rem(@diameter) {
	.size_rem(@diameter, @diameter);
}
.circle(@diameter, @border-width: 0){
	display: inline-block;
	.size(@diameter, @diameter);
	.border-radius(50%);
}
.circle_rem(@diameter, @border-width: 0){
	display: inline-block;
	.size_rem(@diameter, @diameter);
	.px2rem(unit(ceil((@diameter + @border-width * 2) / 2), px), border-radius);
}
.bg-posi(@x, @y){
	background-position:unit(@x, px) unit(@y, px);
}
.bg-size(@w, @h:0) when ( isnumber(@w) ){
	-webkit-background-size:unit(@w, px) unit(@h, px);
	background-size:unit(@w, px) unit(@h, px);
}
.bg-size(@arg: contain){ //contain|cover
	-webkit-background-size: @arg;
	background-size: @arg;
}
.bg-size_rem(@w, @h) {
	.px2rem_2(unit(@w, px), unit(@h, px), background-size);
}
.clearProp(@property){
	@{property}: initial;
}
.arial(){
	font-family: Arial, sans-serif;
}
.ellipsis(){
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}
.alignTextWithSmall() {
	vertical-align: top;
	* {
		vertical-align: inherit;
	}
}
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


	//用页名提高样式优先级，覆盖插件原有样式
.page_timerange {
	input[type=checkbox].mod_round_checkbox{
		.px2rem(78px, width);
		.px2rem(47px, height);
		.px2rem(47px, border-radius);
		.px2rem(3px, border-weidth);
		&::after{
			.px2rem(-2px, top);
			.px2rem(-2px, left);
			.px2rem(44px, width);
			.px2rem(44px, height);
			border-radius: 50%;
			.px2rem(2px, border-width);
		}
		&:checked{
			&::after{
				.px2rem(30px, left);
			}
		}
	}
	#lunar_cale_panel{
		.px2rem(259px * 2, height);
		.px2rem(2px, border-top-width);
		.hd{
			.px2rem(88px, height);
			.px2rem(2px, border-bottom-width);
			label {
	    		input {
	    			.px2rem(10px, margin-right);
	    		}
			}
			.finishBtn{
				.px2rem(43px*2, width);
				.px2rem(28px*2, height);
				.px2rem(1px*2, border-width);
				.px2rem(4px*2, -webkit-border-radius);
				.px2rem(14px*2, font-size);
				.px2rem(28px*2, line-height);
				text-shadow: none;
			}
		}
		.bd{
			.px2rem(206px*2, height);
			.px2rem(8px*2, padding-top);
		}
		.win{
			.px2rem(195px*2, height);
			.px2rem(4px*2, -webkit-border-radius);
			.px2rem(1px*2, border-width);
		}
		.wdecoration {

			.wbk{
				.px2rem(195px*2, height);
				.px2rem_2(0, 2px*2, margin);
			}
			.wline{
				.px2rem(195px*2, height);
				.px2rem(2px*2, width);
			}
		}

		.wglass{
			.px2rem(41px*2, height);
			.px2rem(76px*2, top);
			.px2rem_4(2px, 0, 2px, 0, border-width);
		}

		.wmain{
			.px2rem(195px*2, height);

			.wbox{
				@mright: 8px;
				.px2rem(195px*2, height);
				.px2rem_2(0, 4px, margin);

				li{
					.px2rem(39px*2, height);
					.px2rem(39px*2, line-height);
					.px2rem(18px*2, font-size);
				}

				&.day,
				&.hour{
					.px2rem(4px*2, margin-right);
				}

				&.year{
					.px2rem(@mright, margin-right);
					i{
						.px2rem(15px*2, font-size);
					}
				}
				&.day {
					li.today{
						.px2rem(40px);
						text-shadow:0 1px #ededed;
					}
					i{
						.px2rem(30px);
					}
				}
				&.month{
					.px2rem(@mright, margin-right);
				}
			}
		}

		&.normal {
			.px2rem(28px);
			.hd {
				.px2rem(30px, margin-left);
			}
			.bd {
				.win {
					.wglass {
						.px2rem(2px, border-width);
						.px2rem(60px, height);
						transform: translateY( unit(-32px / @rem-base, rem) );
					}
				}
			}
		} //end of .normal

	} //end of #lunar_cale_panel
}
	body {
	background-color: #F0EFF5;
	font-family: HelveticaNeue-Light, Helvetica Neue Light, times;
}
a {/*color: inherit;*/}
ul {list-style: none;}
th {font-weight: normal;}
table{
	border-collapse:collapse;
	border-spacing:0;
	width:100%;
}

.Neue {
	font-family: HelveticaNeue, Helvetica Neue, times;
}


.weui_dialog_bd {
	display: flex;
	justify-content: center;
}
.weui_dialog_bd i {
	display: inline-block; // width: 25px; height: 25px; margin-right: 10px;
	background-repeat: no-repeat; background-size: contain;
}
.weui_dialog_bd i.success {background-image: url('@{img}dialog_icon_success.png')}
.weui_dialog_bd i.warn {background-image: url('@{img}dialog_icon_warn.png')}


	.page_timerange {
		#lunar_cale_panel .hd label{
			display: none;
		}
		.head {
			display: flex;

			p, a {
				display: block;
			}
			p {
				flex: 1;
			}
			a {
				color: #576B95;
				.px2rem(40px, padding-left);
			}
		}
		.field {
			width: 100%;
			display: flex;
			justify-content: space-between;

			p {
				display: block;
				&.to {
					color: #888888;
					.px2rem(30px);
				}
			}
		}
	}
	</style>

</timerange>