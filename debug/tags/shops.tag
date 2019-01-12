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

	//用于居右的请选择等after伪类灰色小箭头
.mod_arrow_after(@content: '>') {
	content: @content;
	color: #9B9B9B;
	display: inline-block;
	.px2rem(24px);
	.px2rem(16px, padding-left);
	.arial;
	.no-text();
	background: url('@{img}link_arrow.png') no-repeat 50% 50%;
	background-size: contain;
	.px2rem(12px, margin-left);
}

.mod_flex {
	display: flex;
}

.weui_cell.mod_shop_cell,
.mod_shop_cell {
	box-sizing: border-box;
	.px2rem(100px, padding-left);
	.rel-obj;
	::before {
		content: '';
		.px2rem(38px, width);
		.px2rem(36px, height);
		background: url('@{img}shop_icon.png') no-repeat 0 0;
		background-size: contain;
		position: absolute;
		top: 50%;
		.px2rem(33px, left);
		transform: translateY(-50%);
	}
	&.current {
		color: #09BB07;
	}
}
	
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