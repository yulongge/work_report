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